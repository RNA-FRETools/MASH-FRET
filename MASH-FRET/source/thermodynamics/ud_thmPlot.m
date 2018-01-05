function ud_thmPlot(h_fig)

h = guidata(h_fig);
p = h.param.thm;
proj = p.curr_proj;
tpe = p.curr_tpe(proj);
prm = p.proj{proj}.prm{tpe};
labels = p.proj{proj}.labels;
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
exc = p.proj{proj}.excitations;
nExc = numel(exc);
nChan = p.proj{proj}.nb_channel;
nFRET = size(FRET,1);
nS = size(S,1);
perSec = p.proj{proj}.cnt_p_sec;
perPix = p.proj{proj}.cnt_p_pix;
expT = p.proj{proj}.frame_rate;
nPix = p.proj{proj}.pix_intgr(2);

x_bin = prm.plot{1}(1,1);
x_lim = prm.plot{1}(1,2:3);
isInt = tpe <= 2*nChan*nExc;
if isInt % intensities
    if perSec
        x_bin = x_bin/expT;
        x_lim = x_lim/expT;
    end
    if perPix
        x_bin = x_bin/nPix;
        x_lim = x_lim/nPix;
    end
end

ovrfl = prm.plot{1}(1,4);
P = prm.plot{2};
thm_start = prm.thm_start;
thm_res = prm.thm_res;
boba = thm_start{1}(2);
w = thm_start{1}(5);

%% set fields to parameter values
setProp(get(h.uipanel_thm_plot, 'Children'), 'Enable', 'on');

%% build data type list
str_pop = {};
for l = 1:nExc
    for c = 1:nChan
        str_pop = [str_pop [labels{c} ' at ' num2str(exc(l)) 'nm']];
    end
end
for l = 1:nExc
    for c = 1:nChan
        str_pop = [str_pop ['discr. ' labels{c} ' at ' num2str(exc(l)) 'nm']];
    end
end
for n = 1:nFRET
    str_pop = [str_pop ['FRET ' labels{FRET(n,1)} '>' labels{FRET(n,2)}]];
end
for n = 1:nFRET
    str_pop = [str_pop ['discr. FRET ' labels{FRET(n,1)} '>' labels{FRET(n,2)}]];
end
for n = 1:nS
    str_pop = [str_pop ['S ' labels{S(n)}]];
end
for n = 1:nS
    str_pop = [str_pop ['discr. S ' labels{S(n)}]];
end
set(h.popupmenu_thm_tpe, 'String', str_pop, 'Value', tpe);

set([h.edit_thm_xbin h.edit_thm_xlim1 h.edit_thm_xlim2], ...
    'BackgroundColor', [1 1 1]);

set(h.edit_thm_xbin, 'String', num2str(x_bin));
set(h.edit_thm_xlim1, 'String', num2str(x_lim(1)));
set(h.edit_thm_xlim2, 'String', num2str(x_lim(2)));
set(h.checkbox_thm_ovrfl, 'Enable', 'on', 'Value', ovrfl);

%% if not calculated yet, build histograms
if isempty(P)
    [P N] = getHist('all', w, ovrfl, h_fig);
    if isempty(P)
        return;
    end
    prm.plot{2} = P;
    prm.plot{3} = N;
    p.proj{proj}.prm{tpe} = prm;
end

if isInt
    intUnits{1,1} = perSec;
    intUnits{1,2} = expT;
    intUnits{2,1} = perPix;
    intUnits{2,2} = nPix;
    % restore original units
    if perSec
        x_lim = x_lim*expT;
    end
    if perPix
        x_lim = x_lim*nPix;
    end
else
    intUnits = [];
end

%% plot histograms and fit if exists
plotHist([h.axes_hist1 h.axes_hist2], P, x_lim, thm_start, thm_res, ...
    p.colList, boba, intUnits, h_fig);


%% store modifications
h.param.thm = p;
guidata(h_fig, h);

