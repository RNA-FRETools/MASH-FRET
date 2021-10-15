function edit_camNoise_05_Callback(obj, evd, h_fig)

% retrieve noise parameter from edit field
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
h = guidata(h_fig);
ind = get(h.popupmenu_noiseType, 'Value');
if ind==5 % Hirsch or PGN-model, EM register gain
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('EM register gain must be >= 0','error',h_fig);
        return
    end
else % overall gain
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Overall system gain must be >= 0','error',h_fig);
        return
    end
end

% save modifications
p = h.param;

p.proj{p.curr_proj}.sim.curr.gen_dat{1}{2}{5}(ind,5) = val;

h.param = p;
guidata(h_fig,h);

% refresh panel
ud_S_vidParamPan(h_fig);
