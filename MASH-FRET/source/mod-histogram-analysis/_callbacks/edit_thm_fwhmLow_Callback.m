function edit_thm_fwhmLow_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
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

gauss = get(h.popupmenu_thm_gaussNb, 'Value');
val = str2num(get(obj, 'String'));
maxVal = curr.thm_start{3}(gauss,8);

if isInt
    if perSec
        maxVal = maxVal/expT;
    end
    if perPix
        maxVal = maxVal/nPix;
    end
end

set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val<maxVal)
    setContPan(sprintf(['The lower limit of Gaussian FWHM ' ...
        'must be lower than the starting value (%d)'],maxVal), ...
        'error', h_fig);
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    return
end

if isInt
    if perSec
        val = val*expT;
    end
    if perPix
        val = val*nPix;
    end
end

curr.thm_start{3}(gauss,7) = val;

p.proj{proj}.HA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig, h);
updateFields(h_fig, 'thm');