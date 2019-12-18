function edit_simMov_w_Callback(obj, evd, h_fig)

% Last update by MH, 17.12.2019
% >> erase previous random coordinates or re-sort coordinates imported from 
%  file when video dimensions change.

val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Movie dimensions must be integers > 0', 'error', ...
        h_fig);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    h.param.sim.movDim(1) = val;
    
    h.param.sim = resetSimCoord(h.param.sim,h_fig);
    
    guidata(h_fig, h);
    updateFields(h_fig, 'sim');
end