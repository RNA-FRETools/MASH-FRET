function edit_nLasers_Callback(obj, evd, h_fig)

% collect interface parameters
val = round(str2double(get(obj, 'String')));
h = guidata(h_fig);
p = h.param.movPr;
    
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('The number of lasers must be an integer > 0.', h_fig, ...
        'error');
    return
end

% adjust processing parameters
p.itg_nLasers = val;
p = ud_VP_nL(p);

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_expSetPan(h_fig);
