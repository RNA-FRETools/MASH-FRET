function edit_SFparam_minHWHM_Callback(obj, evd, h_fig)

% retrieve value from edit field
val = str2double(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. spot width must be a number.', h_fig, 'error');
    return
end

% collect processing parameters
h = guidata(h_fig);
p = h.param;
nChan = p.proj{p.curr_proj}.nb_channel;
curr = p.proj{p.curr_proj}.VP.curr;
coordslct = curr.gen_crd{2}{5};
avimg = curr.res_plot{2};

% save minimum spot width
chan = get(h.popupmenu_SFchannel,'value');
curr.gen_crd{2}{3}(chan,3) = val;

% reset spot selection
if size(coordslct,1)>=0
    curr.gen_crd{2}{5} = [];
end

% don't start SF if not previously started by user
if isempty(curr.gen_crd{2}{4})
    p.proj{p.curr_proj}.VP.curr = curr;
    h.param = p;
    guidata(h_fig, h);
    return
end

% find spots
curr = updateSF(avimg, false, curr, h_fig);

% set coordinates to transform
spots = [];
for c = 1:nChan
    spots = cat(1,spots,curr.gen_crd{2}{5}{c});
end
curr.res_crd{1} = spots;
curr.gen_crd{3}{1}{1} = spots(:,[1,2]);

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
