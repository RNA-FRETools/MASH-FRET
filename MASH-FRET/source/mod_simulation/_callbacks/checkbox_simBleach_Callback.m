function checkbox_simBleach_Callback(obj, evd, h_fig)

% Last update by MH, 19.12.2019
% >> delete previous state sequences (and associated results) when
%  photobleaching option changes

h = guidata(h_fig);
h.param.sim.bleach = get(obj, 'Value');

% clear any results to avoid conflict
if isfield(h,'results') && isfield(h.results,'sim')
    h.results = rmfield(h.results,'sim');
end

guidata(h_fig, h);
guidata(h_fig, h);
updateFields(h_fig, 'sim');