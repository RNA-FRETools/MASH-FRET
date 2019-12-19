function edit_nbMol_Callback(obj, evd, h_fig)

% Last update by MH, 19.12.2019
% >> clear randomly generated coordinates when the sample size changes

% control input value
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Number of molecules must be an integer > 0', 'error', ...
        h_fig);
    return
end

% store value
h = guidata(h_fig);
h.param.sim.molNb = val;

% re-sort/clear coordinates
h.param.sim = resetSimCoord(h.param.sim,h_fig);

% save results
guidata(h_fig, h);

% set GUI to proper values
set(obj, 'BackgroundColor', [1 1 1]);
updateFields(h_fig, 'sim');
