function edit_camNoise_06_Callback(obj, evd, h_fig)

% retrieve noise parameter from edit field
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
h = guidata(h_fig);
ind = get(h.popupmenu_noiseType, 'Value');
switch ind
    case 3  % User defined, exponential decay constant
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('Exponential tail decay constant must be >= 0',...
                'error',h_fig);
            return
        end

    case 5 % Hirsch or PGN-model, analog-to-digital factor
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('Analog-to-Digital factor must be > 0','error',...
                h_fig);
            return
        end
        
    otherwise
        return
end

% save modifications
p = h.param;

p.proj{p.curr_proj}.sim.curr.gen_dat{1}{2}{5}(ind,6) = val;

h.param = p;
guidata(h_fig,h);

% refresh panel
ud_S_vidParamPan(h_fig);
