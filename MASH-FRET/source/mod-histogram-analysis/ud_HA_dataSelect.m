function ud_HA_dataSelect(h_fig)
% ud_HA_dataSelect(h_fig)
%
% Set properties of data selection uicontrols to proper values
%
% h_fig: handle to main figure

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
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
tagNames = p.proj{proj}.molTagNames;
colorlist = p.proj{proj}.molTagClr;

% get number of total intensities
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
