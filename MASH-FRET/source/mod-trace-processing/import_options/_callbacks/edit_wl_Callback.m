function edit_wl_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
val = str2num(get(obj, 'String'));
exc = get(h.trImpOpt.popupmenu_exc, 'Value');

set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>0)
    updateActPan('Wavelengths must be > 0', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    return
end

% collect import options
m = guidata(h.figure_trImpOpt);

m{1}{2}(exc) = val;

% save modifications
guidata(h.figure_trImpOpt, m);

% set GUI to proper values
ud_trImpOpt(h_fig);



