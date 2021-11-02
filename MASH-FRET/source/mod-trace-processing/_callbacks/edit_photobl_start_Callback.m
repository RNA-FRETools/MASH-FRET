function edit_photobl_start_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
expT = p.proj{proj}.frame_rate;
nExc = p.proj{proj}.nb_excitations;
I = p.proj{proj}.intensities;
inSec = p.proj{proj}.time_in_sec;
method = p.proj{proj}.TP.curr{mol}{2}{1}(2);
pbcorr = p.proj{proj}.TP.curr{mol}{2}{1}(1);
pbpos = p.proj{proj}.TP.curr{mol}{2}{1}(4+method);

if pbcorr
    stop = pbpos;
else
    stop = nExc*size(I,1);
end

val = str2num(get(obj, 'String'));
if inSec
    val = expT*round(val/expT);
    minVal = expT;
    maxVal = expT*stop;
else
    val = round(val);
    minVal = 1;
    maxVal = stop;
end
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=minVal && val<=maxVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Data start must be >= ' num2str(minVal) ' and <= ' ...
        num2str(maxVal)], h_fig, 'error');
    return
end

if inSec
    val = val/expT;
end

p.proj{proj}.TP.curr{mol}{2}{1}(4) = val;

h.param = p;
guidata(h_fig, h);

ud_bleach(h_fig);
updateFields(h_fig, 'ttPr');
