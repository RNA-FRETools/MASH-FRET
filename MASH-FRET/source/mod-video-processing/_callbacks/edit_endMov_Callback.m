function edit_endMov_Callback(obj, evd, h_fig)

% get VP parameters
h = guidata(h_fig);
p = h.param;
L = p.proj{p.curr_proj}.movie_dat{1}{3};
curr = p.proj{p.curr_proj}.VP.curr;
start = curr.edit{2}(1);

% retrieve value from edit field
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val)==1 && ~isnan(val) && val>=start && ...
        val<=L)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Ending frame must be >= starting frame and <= frame ',...
        'length.'],h_fig,'error');
    return
end

curr.edit{2}(2) = val;

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_edExpVidPan(h_fig)

