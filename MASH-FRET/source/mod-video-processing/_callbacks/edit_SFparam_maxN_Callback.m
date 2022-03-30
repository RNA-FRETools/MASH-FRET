function edit_SFparam_maxN_Callback(obj, evd, h_fig)

% retrieve value from edit field
val = round(str2double(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Max. number of peak must be >= 0.', h_fig, 'error');
    return
end

% collect processing parameters
h = guidata(h_fig);
p = h.param;
nChan = p.proj{p.curr_proj}.nb_channel;
curr = p.proj{p.curr_proj}.VP.curr;
def = p.proj{p.curr_proj}.VP.def;
coordslct = curr.gen_crd{2}{5};
avimg = curr.res_plot{2};
bgfilt = curr.edit{1}{4};

% save maximum number of spots
chan = get(h.popupmenu_SFchannel,'value');
curr.gen_crd{2}{3}(chan,1) = val;

% reset spot selection
if size(coordslct,1)>=0
    curr.gen_crd{2}{5} = def.gen_crd{2}{5};
end

% don't start SF if not previously started by user
if isequal(curr.gen_crd{2}{4},def.gen_crd{2}{4})
    p.proj{p.curr_proj}.VP.curr = curr;
    h.param = p;
    guidata(h_fig, h);
    return
end

% check if any image filter is applied
isBgCorr = ~isempty(bgfilt);

% filter image
if isBgCorr
    for c = 1:numel(aveimg)
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

% set coordinates to plot
curr.plot{1}(2) = 1;

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
p.proj{p.curr_proj}.VP.prm.gen_crd{2} = curr.gen_crd{2};
p.proj{p.curr_proj}.VP.prm.res_crd = curr.res_crd;
h.param = p;
guidata(h_fig, h);

% bring tab forefront
h.uitabgroup_VP_plot.SelectedTab = h.uitab_VP_plot_avimg;

% refresh calculations, plot and GUI
updateFields(h_fig, 'imgAxes');
