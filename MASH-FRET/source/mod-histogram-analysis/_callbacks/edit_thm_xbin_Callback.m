function edit_thm_xbin_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('x-binning must be > 0', 'error', h_fig);
    return
end

proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
perSec = p.proj{proj}.cnt_p_sec;
perPix = p.proj{proj}.cnt_p_pix;
expT = p.proj{proj}.frame_rate;
nPix = p.proj{proj}.pix_intgr(2);
curr = p.proj{proj}.HA.curr{tag,tpe};

isInt = tpe <= 2*nChan*nExc;
if isInt
    if perSec
        val = val*expT;
    end
    if perPix
        val = val*nPix;
    end
end

curr.plot{1}(1,1) = val;
curr.plot{2} = [];

p.proj{proj}.HA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig, h);
updateFields(h_fig, 'thm');
