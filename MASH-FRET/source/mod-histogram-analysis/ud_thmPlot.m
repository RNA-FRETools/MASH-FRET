function ud_thmPlot(h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;

h_pan = h.uipanel_HA_histogramAndPlot;
if ~prepPanel(h_pan,h)
    return
end

% collect experiment settings
proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);
exc = p.proj{proj}.excitations;
nChan = p.proj{proj}.nb_channel;
chanExc = p.proj{proj}.chanExc;
perSec = p.proj{proj}.cnt_p_sec;
expT = p.proj{proj}.resampling_time;
prm = p.proj{proj}.HA.prm{tag,tpe};
curr = p.proj{proj}.HA.curr{tag,tpe};

if isempty(prm.plot{2})
    setProp(get(h_pan,'children'),'enable','off');
    return
end

% determine whether histogram is imported from files
fromfile = isfield(p.proj{proj},'histdat') && ...
    ~isempty(p.proj{proj}.histdat);

ovrfl = prm.plot{1}(1,4);
x_bin = curr.plot{1}(1,1);
x_lim = curr.plot{1}(1,2:3);
nExc = numel(exc);
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
if isInt % intensities
    if perSec
        x_bin = x_bin/expT;
        x_lim = x_lim/expT;
    end
end

set([h.edit_thm_xbin h.edit_thm_xlim1 h.edit_thm_xlim2], ...
    'BackgroundColor', [1 1 1]);

set(h.edit_thm_xbin, 'String', num2str(x_bin));
set(h.edit_thm_xlim1, 'String', num2str(x_lim(1)));
set(h.edit_thm_xlim2, 'String', num2str(x_lim(2)));
set(h.checkbox_thm_ovrfl, 'Enable', 'on', 'Value', ovrfl);

if fromfile
     setProp(get(h_pan,'children'),'enable','off');
end

