function ud_trSetTbl(h_fig)

%% Last update by MH, 24.4.2019
% >> adapt code to new functionalities that allow adding and removing 
%    multiple molecule tags
%
% update: 29.3.2019 by MH
% >> adapt reorganization of cross-talk coefficients to new parameter 
%    structure (see project/setDefPrm_traces.m)
%%

h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    projPrm = p.proj{proj};
    mol = p.curr_mol(proj);
    nC = projPrm.nb_channel;
    chanExc = projPrm.chanExc;
    exc = projPrm.excitations;

    p.defProjPrm.mol = p.proj{proj}.curr{mol};
    p.defProjPrm.general{4} = p.proj{proj}.fix{4};

    % modified by MH, 13.1.2020
%     mol_prev = p.defProjPrm.mol{5};
    de_bywl = p.defProjPrm.general{4}{2};
    
    if size(de_bywl,1)>0
        % reorder direct excitation coefficients according to laser wavelength
        % (in case project parameters were changed)
        for c = 1:nC
            if sum(exc==chanExc(c)) % emitter-specific illumination defined and 
                exc_but_c = exc(exc~=chanExc(c));
                [o,id] = sort(exc_but_c,'ascend'); % chronological index sorted as wl

                % modified by MH, 13.1.2020
    %             p.defProjPrm.mol{5}{2}(:,c) = mol_prev{2}(id,c);
                p.defProjPrm.general{4}{2}(:,c) = de_bywl(id,c);
            end
        end
    end
    
    p.defProjPrm.general = p.proj{proj}.fix;
    p.defProjPrm.exp = p.proj{proj}.exp;
    h.param.ttPr = p;
    guidata(h_fig, h);
    
    incl = p.proj{proj}.coord_incl;
    molTag = p.proj{proj}.molTag;
    tagNames = p.proj{proj}.molTagNames;
    nTag = size(tagNames,2);
    colorlist = p.proj{proj}.molTagClr;
    
    currMol = p.curr_mol(proj);
    
    % update molecule select checkbox
    set(h.checkbox_TP_selectMol,'string',cat(2,'include (',...
        num2str(sum(incl)),' included)'),'value',incl(currMol));
    
    % update default tag list
    addOn = get(h.pushbutton_TP_addTag,'value');
    if addOn
        str_lst = getStrPopTags(tagNames,colorlist);
        set(h.lisbox_TP_defaultTags,'visible','on','string',str_lst);
        if numel(str_lst)==1 && strcmp(str_lst{1},'no default tag')
            set(h.lisbox_TP_defaultTags,'value',1);
        else
            currTag = get(h.lisbox_TP_defaultTags,'value');
            currTop = get(h.lisbox_TP_defaultTags,'listboxtop');
            if currTag>nTag
                currTag = nTag;
            end
            set(h.lisbox_TP_defaultTags,'value',currTag);
            if currTop<=nTag
                set(h.lisbox_TP_defaultTags,'listboxtop',currTop);
            else
                set(h.lisbox_TP_defaultTags,'listboxtop',1);
            end
        end
    else
        set(h.lisbox_TP_defaultTags,'visible','off');
    end

    % update molecule tag popupmenu
    set(h.popupmenu_TP_molLabel,'enable','on');
    str_pop = {};
    for t = 1:nTag
        if molTag(currMol,t)
            if sum(double((hex2rgb(colorlist{t})/255)>0.5))==3
                fntClr = 'black';
            else
                fntClr = 'white';
            end
            str_pop = [str_pop,cat(2,'<html><body  bgcolor="', ...
                colorlist{t},'"><font color=',fntClr,'>',tagNames{t}, ...
                '</font></body></html>')];
        end
    end
    if isempty(str_pop)
        set(h.popupmenu_TP_molLabel,'string',{'no tag'},'value',1);
    else
        currTag = get(h.popupmenu_TP_molLabel,'Value');
        if currTag>sum(molTag(currMol,:))
            currTag = sum(molTag(currMol,:));
        end
        set(h.popupmenu_TP_molLabel,'string',str_pop,'value',currTag);
    end
    
end
 
ud_lstMolStr(p, h.listbox_molNb);

