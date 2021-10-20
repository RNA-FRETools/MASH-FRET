function refreshPlotExample(h_fig)
% Create and plot the first simulated trajectory and video frame.
%
% h_fig: handle to main MASH-FRET figure.

% update 29.11.2019 by MH: (1) create separate functions for 1) generating the background image, 2) create intensity time traces and 3) create video frame; this allows to call the same scripts here and in exportResults.m and prevents unilateral modifications (2) remove useless handling of font size in axes labels (set upstream when building MASH-FRET main figure)

% collect simulation parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'sim')
    return
end
proj = p.curr_proj;
curr = p.proj{proj}.sim.curr;
prm = p.proj{proj}.sim.prm;

if ~(isfield(prm,'res_dt') && ~isempty(prm.res_dt{1}))
    return
end

% collect simulation parameters
br = prm.gen_dat{1}{2}{2};
outun = curr.exp{2};

% retrieve simulated trajectories and coordinates
N = size(prm.res_dat{1},3);
if N==0
    return
end
coord = prm.gen_dat{1}{1}{2};
Idon = permute(prm.res_dat{1}(:,1,:),[1,3,2]);
Iacc = permute(prm.res_dat{1}(:,2,:),[1,3,2]);

% get background image
[img_bg,err] = getBackgroundImage(prm);
if isempty(img_bg)
    % abort if background image can not be created
    updateActPan(err, h_fig, 'error');
    return
end

% determine camera saturation value (slow process, done only once per update)
[~,prm.gen_dat{1}{2}{5}(2,6)] = Saturation(br);

% create first donor-acceptor intensity traces
[I_don_ic,I_acc_ic,err] = ...
    createIntensityTraces(Idon(:,1),Iacc(:,1),coord(1,:),img_bg,prm,outun);
if isempty(I_don_ic) || isempty(I_acc_ic)
    % abort if traces can not be created
    updateActPan(err, h_fig, 'error');
    return
end

% create first video frame
[img,prm.gen_dat{6}{3},err] = ...
    createVideoFrame(1,Idon,Iacc,coord,img_bg,prm,outun);
if isempty(img)
    % abort if video frame can not be created
    updateActPan(err, h_fig, 'error');
    return
end

% save calculated parameters (plots, sat and gaussMat)
prm.res_plot{1} = img;
prm.res_plot{2} = [I_don_ic,I_acc_ic];
p.proj{proj}.sim.prm = prm;
p.proj{proj}.sim.curr.gen_dat = prm.gen_dat;
p.proj{proj}.sim.curr.res_plot = prm.res_plot;
h.param = p;
guidata(h_fig, h);

