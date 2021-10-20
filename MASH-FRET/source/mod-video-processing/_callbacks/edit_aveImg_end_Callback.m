function edit_aveImg_end_Callback(obj, evd, h_fig)

% collect project and VP parameters
h = guidata(h_fig);
p =  h.param;
L = p.proj{p.curr_proj}.movie_dat{3};
curr = p.proj{p.curr_proj}.VP.curr;
start = curr.gen_crd{1}(1);

% retrieve value from edit field
val = round(str2double(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=start && val<=L)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Ending frame must be >= starting frame and <= ' ...
        'frame length.'], h_fig, 'error');
    return
end

% save upper bound of frame range for average image calculation
curr.gen_crd{1}(2) = val;

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_molCoordPan(h_fig);
