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

    % cancelled by MH, 29.3.2019
%     % reorder the cross talk coefficients as the wavelength
%     [o,id] = sort(p.proj{proj}.excitations,'ascend'); % chronological index sorted as wl

    mol_prev = p.defProjPrm.mol{5};
    
    % modified by MH, 29.3.2019
%     for c = 1:nC
%         p.defProjPrm.mol{5}{1}(:,c) = mol_prev{1}(id,c);
%         p.defProjPrm.mol{5}{2}(:,c) = mol_prev{2}(id,c);
%     end
    for c = 1:nC
        if sum(exc==chanExc(c)) % emitter-specific illumination defined and 
                                % present in used ALEX scheme (DE 
                                % calculation possible)           
            % reorder the direct excitation coefficients according to laser
            % wavelength
            exc_but_c = exc(exc~=chanExc(c));
            [o,id] = sort(exc_but_c,'ascend'); % chronological index sorted as wl
            p.defProjPrm.mol{5}{2}(:,c) = mol_prev{2}(id,c);
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
        str_lst = cell(1,length(tagNames));
        for t = 1:nTag
            if sum(double((hex2rgb(colorlist{t})/255)>0.5))==3
                fntClr = 'black';
            else
                fntClr = 'white';
            end
            str_lst{t} = ['<html><body  bgcolor="' colorlist{t} '">' ...
                '<font color=',fntClr,'>' tagNames{t} ...
                '</font></body></html>'];
        end
        if isempty(str_lst)
            set(h.lisbox_TP_defaultTags,'visible','on','value',1,...
                'string',{'no default tag'});
        else
            currTag = get(h.lisbox_TP_defaultTags,'value');
            currTop = get(h.lisbox_TP_defaultTags,'listboxtop');
            if currTag>nTag
                currTag = nTag;
            end
            set(h.lisbox_TP_defaultTags,'visible','on','value',currTag,...
                'string',str_lst);
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

