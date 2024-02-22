function update_HA_plots(h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~isModuleOn(p,'HA')
    cla(h.axes_hist1); cla(h.axes_hist2); cla(h.axes_thm_BIC);
    set([h.axes_hist1,h.axes_hist2,h.axes_thm_BIC], 'Visible','off');
    return
end

% collect experiment settings
proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);
colList = p.thm.colList;
exc = p.proj{proj}.excitations;
nChan = p.proj{proj}.nb_channel;
chanExc = p.proj{proj}.chanExc;
perSec = p.proj{proj}.cnt_p_sec;
expT = p.proj{proj}.resampling_time;
prm = p.proj{proj}.HA.prm{tag,tpe};
curr = p.proj{proj}.HA.curr{tag,tpe};

if isfield(prm,'thm_start')
    thm_start = prm.thm_start;
else
    thm_start = curr.thm_start;
end
boba = thm_start{1}(2);

if isfield(prm,'thm_res')
    thm_res = prm.thm_res;
else
    thm_res = curr.thm_res;
end

if isfield(prm,'plot')
    P = prm.plot{2};
    x_lim = prm.plot{1}(1,2:3);
else
    P = curr.plot{2};
    x_lim = curr.plot{1}(1,2:3);
end

nExc = numel(exc);
em0 = find(chanExc~=0);
nDE = numel(em0);
isInt = tpe <= (2*nChan*nExc + 2*nDE);
if isInt
    intUnits{1,1} = perSec;
    intUnits{1,2} = expT;
else
    intUnits = [];
end

% plot histograms and fit if exists
plotHist([h.axes_hist1,h.axes_hist2,h.axes_thm_BIC], P, x_lim, ...
    thm_start, thm_res, colList, boba, intUnits, h_fig);
