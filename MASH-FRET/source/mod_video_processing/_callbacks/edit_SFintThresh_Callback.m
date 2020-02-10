function edit_SFintThresh_Callback(obj, evd, h_fig)

% collect interface parameters
val = str2double(get(obj, 'String'));
h = guidata(h_fig);
chan = get(h.popupmenu_SFchannel, 'Value');
p = h.param.movPr;

set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be >= 0.'], h_fig, ...
        'error');
    return
end

if p.SF_method==4 % Schmied2012
    p.SF_intRatio(chan) = val;
else
    % convert to proper intensity units
    if p.perSec
        val = val*p.rate;
    end
    p.SF_intThresh(chan) = val;
end

% reset spot selection
if ~isempty(p.SFres)
    p.SFres(2,:) = [];
end

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% refresh calculations, plot and set GUI to proper values
updateFields(h_fig,'imgAxes');
