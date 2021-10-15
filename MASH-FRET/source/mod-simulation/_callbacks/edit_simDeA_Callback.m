function edit_simDeA_Callback(obj, evd, h_fig)

% retrieve acceptor direct excitation from edit field
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val)==1 && ~isnan(val) && val>=0  && val<=1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Direct excitation coefficient must be >= 0 and <= 1', ...
        'error', h_fig);
    return
end

% save modification
h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.sim.curr.gen_dat{5}(2,2) = val;

h.param = p;
guidata(h_fig, h);

% refresh panel
ud_S_moleculesPan(h_fig);