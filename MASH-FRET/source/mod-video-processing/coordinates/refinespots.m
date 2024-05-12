function refinespots(refineprm,h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
curr = p.proj{proj}.VP.curr;
def = p.proj{proj}.VP.def;

coordslct = curr.gen_crd{2}{5};
avimg = curr.res_plot{2};
bgfilt = curr.edit{1}{4};

% reset spot selection
if size(coordslct,1)>=0
    curr.gen_crd{2}{5} = def.gen_crd{2}{5};
end

% save parameters for refinement
curr.gen_crd{2}{3} = refineprm;

% don't start SF if not previously started by user
if isequal(curr.gen_crd{2}{4},def.gen_crd{2}{4})
    p.proj{proj}.VP.curr = curr;
    h.param = p;
    guidata(h_fig, h);
    return
end

% check if any image filter is applied
isBgCorr = ~isempty(bgfilt);

% filter image
if isBgCorr
    for c = 1:numel(avimg)
        avimg{c} = updateBgCorr(avimg{c}, p, h_fig);
    end
end

% find spots
curr = updateSF(avimg, false, curr, h_fig);

% set coordinates to transform
spots = cell(1,nChan);
for c = 1:nChan
    if ~isempty(curr.gen_crd{2}{5}{c})
        spots{c} = curr.gen_crd{2}{5}{c}(:,[1,2]);
    end
end
curr.res_crd{1} = spots;

% reset coordinates file to transform
curr.gen_crd{3}{1}{2} = '';

% reset single molecule coordinates file for one channel videos
if nChan==1
    curr.res_crd{4} = spots{1};
    curr.gen_int{2}{2} = '';
end

% set coordinates to plot
curr.plot{1}(2) = 1;

% save modifications
p.proj{proj}.VP.curr = curr;
p.proj{proj}.VP.prm.gen_crd{2} = curr.gen_crd{2};
p.proj{proj}.VP.prm.res_crd = curr.res_crd;
h.param = p;
guidata(h_fig, h);

% bring tab forefront
h.uitabgroup_VP_plot.SelectedTab = h.uitab_VP_plot_avimg;

% refresh calculations, plot and GUI
updateFields(h_fig, 'imgAxes');
