function edit_intNpix_Callback(obj, evd, h_fig)

% gte interface parameters
val = round(str2double(get(obj,'String')));
h = guidata(h_fig);
p = h.param.movPr;

% get processing parameterss
nMax = prod(p.itg_dim^2);

if val>nMax
    val = nMax;
    set(obj, 'String', num2str(val));
end
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Number of integrated pixels must be an integer > 0.', ...
        h_fig, 'error');
    return
end

p.itg_n = val;
    
% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values 
ud_VP_intIntegrPan(h_fig);

