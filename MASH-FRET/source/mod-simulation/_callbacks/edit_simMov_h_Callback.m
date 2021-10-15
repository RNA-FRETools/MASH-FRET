function edit_simMov_h_Callback(obj, evd, h_fig)

% update by MH, 17.12.2019: erase previous random coordinates or re-sort coordinates imported from file when video dimensions change.

% retrieve video pixel height value from edit field
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Movie dimensions must be integers > 0', 'error', h_fig);
    return
end

% retrieve project's simulation parameters
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.sim.curr;

% reset coordinates
if val~=curr.gen_dat{1}{2}{1}(2)
    curr = resetSimCoord(curr,h_fig);
end

% save modifications
curr.gen_dat{1}{2}{1}(2) = val;
p.proj{p.curr_proj}.sim.curr = curr;
h.param = p;
guidata(h_fig, h);

% refresh panel
ud_S_vidParamPan(h_fig);
