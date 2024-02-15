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
exc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;
perSec = p.proj{proj}.cnt_p_sec;
expT = p.proj{proj}.resampling_time;
curr = p.proj{proj}.HA.curr{tag,tpe};

% abort if histogram is imported from files
fromfile = isfield(p.proj{proj},'histdat') && ...
    ~isempty(p.proj{proj}.histdat);
if fromfile
    setContPan('Binning of imported histograms can not be modified.',...
        'error',h_fig);
    ud_thmPlot(h_fig);
    return
end

em0 = find(chanExc~=0);
inclem = true(1,numel(em0));
for em = 1:numel(em0)
    if ~sum(chanExc(em)==exc)
        inclem(em) = false;
    end
end
em0 = em0(inclem);
nDE = numel(em0);

isInt = tpe <= (2*nChan*nExc + 2*nDE);
if isInt
    if perSec
        val = val*expT;
    end
end

curr.plot{1}(1,1) = val;
curr.plot{2} = [];

p.proj{proj}.HA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig, h);
updateFields(h_fig, 'thm');
