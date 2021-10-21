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
curr = p.proj{p.curr_proj}.VP.curr;
coordslct = curr.gen_crd{2}{5};
persec = curr.plot{1}(1);
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
