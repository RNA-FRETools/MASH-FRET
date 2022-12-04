function edit_nbStates_Callback(obj, evd, h_fig)

% update by MH, 19.12.2019: delete previous state sequences (and associated results) when the number of states changes
% updateby MH,  19.4.2019: (1) move function from MASH.m to separate file (2) include tip in error message

% default
Jmax = 5;

% retrieve number of states from edit field
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val)==1 && ~isnan(val) && val>0 && val<=Jmax)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan(cat(2,'The number of states must be >0 and <= 5\n',...
        'To simulate a larger system, please load a presets file.'), ...
        'error', h_fig);
    return
end

% save modifications
h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.sim.curr.gen_dt{1}(3) = val;

h.param = p;
guidata(h_fig, h);

% adjust FRET values
updateSimStates(h_fig);

% refresh panel
ud_S_moleculesPan(h_fig);
