function edit_photobl_stop_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
expT = p.proj{proj}.frame_rate;
nExc = p.proj{proj}.nb_excitations;
len = nExc*size(p.proj{proj}.intensities,1);
inSec = p.proj{proj}.time_in_sec;
method = p.proj{proj}.TP.curr{mol}{2}{1}(2);
start = p.proj{proj}.TP.curr{mol}{2}{1}(4);

if method~=1 % Manual
    return
end

val = str2num(get(obj, 'String'));
if inSec
    val = expT*round(val/expT);
    minVal = expT*start;
    maxVal = expT*len;
else
    val = round(val);
    minVal = start;
    maxVal = len;
end
set(obj, 'String', num2str(val));
if ~(numel(val) == 1 && ~isnan(val) && val >= minVal && val <= maxVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Data end must be >= ' num2str(minVal) ' and <= ' ...
        num2str(maxVal)], h_fig, 'error');
    return
end

if inSec
    val = val/expT;
end

p.proj{proj}.TP.curr{mol}{2}{1}(4+method) = val;

h.param = p;
guidata(h_fig, h);

ud_bleach(h_fig);
