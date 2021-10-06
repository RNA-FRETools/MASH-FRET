function ud_trSetTbl(h_fig)

% update 24.4.2019 by MH: adapt code to new functionalities that allow adding and removing multiple molecule tags
% update: 29.3.2019 by MH: adapt reorganization of cross-talk coefficients to new parameter structure (see project/setDefPrm_traces.m)

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_TP_sampleManagement,h)
    set(h.listbox_molNb,'String',{},'Value',0,'Listboxtop',0);
    return
end

% collect experiment settings
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nC = p.proj{proj}.nb_channel;
chanExc = p.proj{proj}.chanExc;
exc = p.proj{proj}.excitations;
incl = p.proj{proj}.coord_incl;
molTag = p.proj{proj}.molTag;
tagNames = p.proj{proj}.molTagNames;
nTag = size(tagNames,2);
colorlist = p.proj{proj}.molTagClr;

% save current molecule's parameters and cross talks as default
p.ttPr.defProjPrm.mol = p.proj{proj}.TP.curr{mol};
p.ttPr.defProjPrm.general = p.proj{proj}.TP.fix;
p.ttPr.defProjPrm.exp = p.proj{proj}.TP.exp;
p.ttPr.defProjPrm.general{4} = p.proj{proj}.TP.fix{4};
de_bywl = p.ttPr.defProjPrm.general{4}{2};
if size(de_bywl,1)>0
    % reorder DE coefficients chromatically
    for c = 1:nC
        if sum(exc==chanExc(c)) 
            exc_but_c = exc(exc~=chanExc(c));
            [o,id] = sort(exc_but_c,'ascend');

            p.ttPr.defProjPrm.general{4}{2}(:,c) = de_bywl(id,c);
        end
    end
end
h.param.ttPr = p.ttPr;
guidata(h_fig, h);

% update molecule select checkbox
set(h.checkbox_TP_selectMol,'string',cat(2,'include (',num2str(sum(incl)),...
    ' included)'),'value',incl(mol));

% update default tag list
addOn = get(h.togglebutton_TP_addTag,'value');
if addOn
    str_lst = getStrPopTags(tagNames,colorlist);
    set(h.listbox_TP_defaultTags,'visible','on','string',str_lst);
    if numel(str_lst)==1 && strcmp(str_lst{1},'no default tag')
        set(h.listbox_TP_defaultTags,'value',1);
    else
        currTag = get(h.listbox_TP_defaultTags,'value');
        currTop = get(h.listbox_TP_defaultTags,'listboxtop');
        if currTag>nTag
            currTag = nTag;
        end
        set(h.listbox_TP_defaultTags,'value',currTag);
        if currTop<=nTag
            set(h.listbox_TP_defaultTags,'listboxtop',currTop);
        else
            set(h.listbox_TP_defaultTags,'listboxtop',1);
        end
    end
else
    set(h.listbox_TP_defaultTags,'visible','off');
end

% update molecule tag popupmenu
set(h.popupmenu_TP_molLabel,'enable','on');
str_pop = {};
for t = 1:nTag
    if molTag(mol,t)
        if sum(double((hex2rgb(colorlist{t})/255)>0.5))==3
            fntClr = 'black';
        else
            fntClr = 'white';
        end
        str_pop = [str_pop,cat(2,'<html><body  bgcolor="',colorlist{t},...
            '"><font color=',fntClr,'>',tagNames{t},...
            '</font></body></html>')];
    end
end
if isempty(str_pop)
    set(h.popupmenu_TP_molLabel,'string',{'no tag'},'value',1);
else
    currTag = get(h.popupmenu_TP_molLabel,'Value');
    if currTag>sum(molTag(mol,:))
        currTag = sum(molTag(mol,:));
    end
    set(h.popupmenu_TP_molLabel,'string',str_pop,'value',currTag);
end

ud_lstMolStr(p, h.listbox_molNb);

