function edit_photoblParam_01_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
method = p.proj{proj}.TP.curr{mol}{2}{1}(2);
chan = p.proj{proj}.TP.curr{mol}{2}{1}(3);

if method~=2 % Threshold
    return
end

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Data threshold must be a number.', h_fig, 'error');
    return
end

if chan > nFRET + nS % threshold for intensities
    perSec = p.proj{proj}.cnt_p_sec;
    if perSec
        expT = p.proj{proj}.frame_rate;
        val = val*expT;
    end
end
p.proj{proj}.TP.curr{mol}{2}{2}(chan,1) = val;

h.param = p;
guidata(h_fig, h);

ud_bleach(h_fig);
