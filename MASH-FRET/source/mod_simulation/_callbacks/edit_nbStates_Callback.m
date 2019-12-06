function edit_nbStates_Callback(obj, evd, h_fig)

% Last update: 19.4.2019 by MH
% >> move function from MASH.m to separate file
% >> include tip in error message

val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0 && val ...
        <= 5)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan(cat(2,'The number of states must be >0 and <= 5\n',...
        'To simulate a larger system, please load a presets file.'), ...
        'error', h_fig);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    h.param.sim.nbStates = val;
    for i = 1:h.param.sim.nbStates
        if i > size(h.param.sim.stateVal,2)
            h.param.sim.stateVal(i) = h.param.sim.stateVal(i-1);
            h.param.sim.FRETw(i) = h.param.sim.FRETw(i-1);
        end
    end
    h.param.sim.stateVal = h.param.sim.stateVal(1:h.param.sim.nbStates);
    h.param.sim.FRETw = h.param.sim.FRETw(1:h.param.sim.nbStates);
    h.results.sim.mix = [];
    guidata(h_fig, h);

    set(h.popupmenu_states, 'Value', 1);
    set(h.edit_stateVal, 'String', num2str(h.param.sim.stateVal(1)));
    updateFields(h_fig, 'sim');
end