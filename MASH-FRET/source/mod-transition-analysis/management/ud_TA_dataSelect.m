function ud_TA_dataSelect(h_fig)
% ud_TA_dataSelect(h_fig)
%
% Set properties of data selection uicontrols to proper values
%
% h_fig: handle to main figure

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

% collect experiment settings
proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
labels = p.proj{proj}.labels;
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
exc = p.proj{proj}.excitations;
nChan = p.proj{proj}.nb_channel;
tagNames = p.proj{proj}.molTagNames;
colorlist = p.proj{proj}.molTagClr;

% get number of total intensities
nExc = numel(exc);
nFRET = size(FRET,1);
nS = size(S,1);
nTag = numel(tagNames);

% build data type list
str_pop = {};
for l = 1:nExc
    for c = 1:nChan
        str_pop = cat(2,str_pop,cat(2,labels{c},' at ',num2str(exc(l)),...
            'nm'));
    end
end
for n = 1:nFRET
    str_pop = cat(2,str_pop,cat(2,'FRET ',labels{FRET(n,1)},'>',...
        labels{FRET(n,2)}));
end
for n = 1:nS
    str_pop = cat(2,str_pop,cat(2,'S ',labels{S(n,1)},'>',labels{S(n,2)}));
end
set(h.popupmenu_TDPdataType,'value',tpe,'string',str_pop);

% build tag list
str_pop = getStrPopTags(tagNames,colorlist);
if nTag>1
    str_pop = cat(2,'all molecules',str_pop);
end
set(h.popupmenu_TDPtag,'string',str_pop,'value',tag);
