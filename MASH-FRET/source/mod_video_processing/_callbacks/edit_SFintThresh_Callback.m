function edit_SFintThresh_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be >= 0.'], ...
        h_fig, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    chan = get(h.popupmenu_SFchannel, 'Value');
    if h.param.movPr.SF_method == 4 % Schmied2012
        h.param.movPr.SF_intRatio(chan) = val;
    else
        if h.param.movPr.perSec
            val = val*h.param.movPr.rate;
        end
        h.param.movPr.SF_intThresh(chan) = val;
    end
    guidata(h_fig, h);
    ud_SFspots(h_fig);
    ud_SFpanel(h_fig);
end