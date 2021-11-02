function edit_thm_fwhmUp_Callback(obj, evd, h_fig)

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
expT = p.proj{proj}.frame_rate;
curr = p.proj{proj}.HA.curr{tag,tpe};

isInt = tpe <= 2*nChan*nExc;

gauss = get(h.popupmenu_thm_gaussNb, 'Value');
val = str2num(get(obj, 'String'));
minVal = curr.thm_start{3}(gauss,8);

if isInt
    if perSec
        minVal = minVal/expT;
    end
end

set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>minVal)
    setContPan(sprintf(['The upper limit of Gaussian FWHM ' ...
        'must be higher than the starting value (%d)'],minVal), ...
        'error', h_fig);
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    return
end

if isInt
    if perSec
        val = val*expT;
    end
end

curr.thm_start{3}(gauss,9) = val;

p.proj{proj}.HA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig, h);
updateFields(h_fig, 'thm');
