function edit_thm_xlim1_Callback(obj, evd, h_fig)

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

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));

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
maxVal = curr.plot{1}(1,3);
if isInt
    if perSec
        maxVal = maxVal/expT;
    end
end

if ~(numel(val)==1 && ~isnan(val) && val<maxVal)
    setContPan(sprintf(['Lower limit of x-axis must be lower than ' ...
        '%d.'],maxVal), 'error', h_fig);
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    return
end

if isInt
    if perSec
        val = val*expT;
    end
end
curr.plot{1}(1,2) = val;
curr.plot{2} = [];

p.proj{proj}.HA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig, h);
updateFields(h_fig, 'thm');

