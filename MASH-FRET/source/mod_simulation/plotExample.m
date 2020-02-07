function plotExample(h_fig)
% Create and plot the first simulated trajectory and video frame.
%
% h_fig: handle to main MASH-FRET figure.

% Last update: 29.11.2019 by MCASH
% >> create separate functions for 1) generating the background image, 2) 
%    create intensity time traces and 3) create video frame; this allows to 
%    call the same scripts here and in exportResults.m and prevents 
%    unilateral modifications
% >> remove useless handling of font size in axes labels (set upstream
%    when building MASH-FRET main figure)

% collect simulation parameters
h = guidata(h_fig);
p = h.param.sim;

% collect simulated state sequences and coordinates
dat = h.results.sim.dat;
N = size(dat{1},2);
if N==0
    % abort if no state sequence was simulated
    return
end
Idon = dat{1};
Iacc = dat{2};
coord = dat{3};
L = size(Idon{1},1);

% get background image
[img_bg,err] = getBackgroundImage(p);
if isempty(img_bg)
    % abort if background image can not be created
    updateActPan(err, h_fig, 'error');
    return
end

% determine camera saturation value (slow process, done only once per update)
[~,p.sat] = Saturation(p.bitnr);

% create first donor-acceptor intensity traces
[I_don_ic,I_acc_ic,err] = createIntensityTraces(Idon{1},Iacc{1},coord(1,:),...
    img_bg,p);
if isempty(I_don_ic) || isempty(I_acc_ic)
    % abort if traces can not be created
    updateActPan(err, h_fig, 'error');
    return
end

% create first video frame
[img,p.matGauss,err] = createVideoFrame(1,Idon,Iacc,coord,img_bg,p);
if isempty(img)
    % abort if video frame can not be created
    updateActPan(err, h_fig, 'error');
    return
end

% save calculated parameters (p.sat and p.gaussMat)
h.param.sim = p;
guidata(h_fig, h);

% get plot units
units = p.intOpUnits;
if ~strcmp(units, 'photon')
    units = 'image';
end

% plot first traces
timeaxis = (1:L)'/p.rate;
plot(h.axes_example, timeaxis,I_don_ic,'-b',timeaxis,I_acc_ic,'-r');
ylim(h.axes_example,'auto');
xlim(h.axes_example,[0 size(I_don_ic,1)/p.rate]);
xlabel(h.axes_example,'time (sec)');
ylabel(h.axes_example,[units,' counts']);
grid(h.axes_example,'on');
legend(h.axes_example,'donor','acceptor');

% histogram first traces
[~,edges] = histcounts([I_don_ic, I_acc_ic]);
[I_don_ic_hist,don_edges] = histcounts(I_don_ic,edges);
[I_acc_ic_hist] = histcounts(I_acc_ic,edges);

% check MATLAB version for bar transparency
mtlbDat = ver;
for i = 1:size(mtlbDat,2)
    if strcmp(mtlbDat(1,i).Name,'MATLAB')
        break;
    end
end
newvers = str2num(mtlbDat(1,i).Version) >= 9;

% plot histogram of first traces
if newvers
    bar(h.axes_example_hist,don_edges(1:size(don_edges,2)-1),I_don_ic_hist,...
        'EdgeColor','none','FaceColor','blue','Barwidth',1,'Facealpha',...
        0.5);
    set(h.axes_example_hist,'nextplot','add');
    bar(h.axes_example_hist,don_edges(1:size(don_edges,2)-1),I_acc_ic_hist,...
        'EdgeColor','none','FaceColor','red','Barwidth',1,'Facealpha',0.5);
else
    bar(h.axes_example_hist,don_edges(1:size(don_edges,2)-1),I_don_ic_hist,...
        'EdgeColor','none','FaceColor','blue','Barwidth',1);
    set(h.axes_example_hist,'nextplot','add');
    bar(h.axes_example_hist,don_edges(1:size(don_edges,2)-1),I_acc_ic_hist,...
        'EdgeColor','none','FaceColor','red','Barwidth',1);
end
set(h.axes_example_hist,'yscale','log','nextplot','replacechildren',...
    'xtickmode','auto');
xlim(h.axes_example_hist, 'auto');
ylim(h.axes_example_hist, 'auto');
xlabel(h.axes_example_hist, [units ' counts']);
ylabel(h.axes_example_hist, 'frequency');
grid(h.axes_example_hist, 'on');
legend(h.axes_example_hist, 'donor', 'acceptor');

% plot video frame
imagesc(h.axes_example_mov,'xdata',[0.5,p.movDim(1)-0.5],'ydata',...
    [0.5,p.movDim(2)-0.5],'cdata',img);
xlim(h.axes_example_mov,[0,p.movDim(1)]);
ylim(h.axes_example_mov,[0,p.movDim(2)]);
caxis(h.axes_example_mov,[min(min(img)),max(max(img))]);
ylabel(h.cb_example_mov, [units,' counts/time bin']);

% make all axes visible
set([h.axes_example,h.axes_example_hist,h.axes_example_mov,...
    h.cb_example_mov],'visible','on');


