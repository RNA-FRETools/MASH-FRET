function edit_nbMol_Callback(obj, evd, h_fig)

% update by MH, 19.12.2019: clear randomly generated coordinates when the sample size changes

% retrieve sample size from edit field
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Number of molecules must be an integer > 0','error',h_fig);
    return
end

% retrieve project's simulation parameters
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.sim.curr;

% update parameter's value
curr.gen_dt{1}(1) = val;

% re-sort/clear coordinates
curr = resetSimCoord(curr,h_fig);

% save modifications
p.proj{p.curr_proj}.sim.curr = curr;
h.param = p;
guidata(h_fig, h);

% refresh panel
ud_S_moleculesPan(h_fig);
