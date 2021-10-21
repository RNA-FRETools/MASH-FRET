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
labels = p.proj{proj}.labels;
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
exc = p.proj{proj}.excitations;
nChan = p.proj{proj}.nb_channel;
chanExc = p.proj{proj}.chanExc;
perSec = p.proj{proj}.cnt_p_sec;
perPix = p.proj{proj}.cnt_p_pix;
expT = p.proj{proj}.frame_rate;
nPix = p.proj{proj}.pix_intgr(2);
tagNames = p.proj{proj}.molTagNames;
colorlist = p.proj{proj}.molTagClr;
prm = p.proj{proj}.HA.prm{tag,tpe};
curr = p.proj{proj}.HA.curr{tag,tpe};

if isempty(prm.plot{2})
    setProp(get(h_pan,'children'),'enable','off');
    set([h.text_thm_data,h.popupmenu_thm_tpe,h.text_thm_tag,...
        h.popupmenu_thm_tag],'enable','on');
    return
end

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
    if perPix
        x_bin = x_bin/nPix;
        x_lim = x_lim/nPix;
    end
end

% build data type list
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
for em = em0
    exc0 = chanExc(em);
    str_pop = [str_pop ['total ' labels{em} ' at ' num2str(exc0) 'nm']];
end
for em = em0
    exc0 = chanExc(em);
    str_pop = [str_pop ['discr. total ' labels{em} ' at ' num2str(exc0) ...
        'nm']];
end
nFRET = size(FRET,1);
for n = 1:nFRET
    str_pop = [str_pop ['FRET ' labels{FRET(n,1)} '>' labels{FRET(n,2)}]];
end
for n = 1:nFRET
    str_pop = [str_pop ['discr. FRET ' labels{FRET(n,1)} '>' labels{FRET(n,2)}]];
end
nS = size(S,1);
for n = 1:nS
    str_pop = [str_pop ['S ' labels{S(n,1)} '>' labels{S(n,2)}]];
end
for n = 1:nS
    str_pop = [str_pop ['discr. S ' labels{S(n,1)} '>' labels{S(n,2)}]];
end
set(h.popupmenu_thm_tpe, 'String', str_pop, 'Value', tpe);

% build tag list
str_pop = getStrPopTags(tagNames,colorlist);
if ~strcmp(str_pop{1},'no default tag')
    str_pop = cat(2,'all molecules',str_pop);
end
set(h.popupmenu_thm_tag, 'String', str_pop, 'Value', tag);

set([h.edit_thm_xbin h.edit_thm_xlim1 h.edit_thm_xlim2], ...
    'BackgroundColor', [1 1 1]);

set(h.edit_thm_xbin, 'String', num2str(x_bin));
set(h.edit_thm_xlim1, 'String', num2str(x_lim(1)));
set(h.edit_thm_xlim2, 'String', num2str(x_lim(2)));
set(h.checkbox_thm_ovrfl, 'Enable', 'on', 'Value', ovrfl);

