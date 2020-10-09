function edit_bgParam_02_Callback(obj, evd, h_fig)

% get interface parameters
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
channel = get(h.popupmenu_bgChanel, 'Value');
p = h.param.movPr;

% collect processing parameters
method = p.movBg_method;

set(obj, 'String', val);
if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Background correction parameter must be >= 0.', ...
        h_fig, 'error');
    return
elseif method==8 && val>1
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Background correction must be in the range [0,1].', ...
        h_fig, 'error');
    return
end
    

p.movBg_p{method,channel}(2) = val;

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_edExpVidPan(h_fig)
