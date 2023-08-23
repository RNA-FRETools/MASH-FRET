function edit_trBgCorr_bgInt_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;
expT = p.proj{proj}.frame_rate;
perSec = p.proj{proj}.cnt_p_sec;
selected_chan = p.proj{proj}.TP.fix{3}(6);
    
% get channel and laser corresponding to selected data
chan = 0;
for l = 1:nExc
    for c = 1:nChan
        chan = chan+1;
        if chan==selected_chan
            break
        end
    end
    if chan==selected_chan
        break
    end
end
method = p.proj{proj}.TP.curr{mol}{3}{2}(l,c);
if method~=1
    ud_ttBg(h_fig);
    return
end

val = str2num(get(obj, 'String'));
if ~(numel(val) == 1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Background intensity must be a number.',h_fig,'error');
    return
end

if perSec
    val = val*expT;
end

p.proj{proj}.TP.curr{mol}{3}{3}{l,c}(method,3) = val;

h.param = p;
guidata(h_fig, h);

ud_ttBg(h_fig);
