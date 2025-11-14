function edit_photoblParam_02_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
expT = p.proj{proj}.resampling_time;
inSec = p.proj{proj}.time_in_sec;
method = p.proj{proj}.TP.curr{mol}{2}{1}(2);

if method~=2 % Threshold
    return
end

val = str2num(get(obj, 'String'));
if inSec
    val = expT*round(val/expT);
else
    val = round(val);
end
set(obj, 'String', num2str(val));
if ~(isscalar(val) && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Time threshold must be >= 0',h_fig, 'error');
    return
end

if inSec
    val = val/expT;
end
chan = h.popupmenu_bleachChan.Value;
p.proj{proj}.TP.curr{mol}{2}{2}(chan,2) = val;

h.param = p;

guidata(h_fig, h);
ud_bleach(h_fig);
