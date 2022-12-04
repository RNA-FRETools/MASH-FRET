function edit_SFparam_minI_Callback(obj, evd, h_fig)

% retrieve value from edit field
val = str2double(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be >= 0.'], h_fig, ...
        'error');
end

% collect VP parameters
h = guidata(h_fig);
p = h.param;
nChan = p.proj{p.curr_proj}.nb_channel;
expT = p.proj{p.curr_proj}.frame_rate;
persec = p.proj{p.curr_proj}.cnt_p_sec;
curr = p.proj{p.curr_proj}.VP.curr;
coordslct = curr.gen_crd{2}{5};
avimg = curr.res_plot{2};

% convert intensity units
if persec
    val = val*expT;
end

% save minimum spot intensity
chan = get(h.popupmenu_SFchannel,'value');
curr.gen_crd{2}{3}(chan,2)= val;
    
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
if isempty(spots)
    curr.gen_crd{3}{1}{1} = [];
else
    curr.gen_crd{3}{1}{1} = spots(:,[1,2]);
end

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
