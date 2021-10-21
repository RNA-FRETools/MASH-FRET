function edit_SFparam_minDspot_Callback(obj, evd, h_fig)

% retrieve value from edit field
val = round(str2double(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. peak-peak distance must be >= 0.', h_fig, 'error');
end

% collect processing parameters
h = guidata(h_fig);
p = h.param;
nChan = p.proj{p.curr_proj}.nb_channel;
curr = p.proj{p.curr_proj}.VP.curr;
coordslct = curr.gen_crd{2}{5};
avimg = curr.res_plot{2};

% save minimum inter-spot distance
chan = get(h.popupmenu_SFchannel,'value');
curr.gen_crd{2}{3}(chan,6) = val;

% reset spot selection
if size(coordslct,1)>=0
    curr.gen_crd{2}{5} = [];
end

% find spots
curr = updateSF(avimg, false, curr, h_fig);

% set coordinates to transform
spots = [];
for c = 1:nChan
    spots = cat(1,spots,curr.gen_crd{2}{5}{c});
end
curr.gen_crd{3}{1}{1} = spots(:,[1,2]);

% reset coordinates file to transform
curr.gen_crd{3}{1}{2} = '';

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
p.proj{p.curr_proj}.VP.prm.gen_crd{2} = curr.gen_crd{2};
h.param = p;
guidata(h_fig, h);

% refresh calculations, plot and GUI
updateFields(h_fig, 'imgAxes');
