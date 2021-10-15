function edit_camNoise_04_Callback(obj, evd, h_fig)

% retrieve noise parameter from edit field
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
h = guidata(h_fig);
ind = get(h.popupmenu_noiseType, 'Value');
switch ind
    case 2 % Gaussian, s_q
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan(['Standard deviaton of analog-to-digital ',...
                'conversion noise must be >= 0'],'error', h_fig);
            return
        end

    case 3  % User defined, sig
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan(['Gaussian camera noise standard deviation width ',...
                'must be >= 0'],'error', h_fig);
            return
        end

    case 5 % Hirsch or PGN-model, CIC noise
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('CIC contribution must be >= 0','error', h_fig);
            return
        end
        
    otherwise
        return
end

% save modifications
p = h.param;

p.proj{p.curr_proj}.sim.curr.gen_dat{1}{2}{5}(ind,4) = val;

h.param = p;
guidata(h_fig,h);

% refresh panel
ud_S_vidParamPan(h_fig);
