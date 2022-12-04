function ud_setExpSet_tabCalc(h_fig)

% retrieve interface content
h = guidata(h_fig);

if ~(isfield(h,'tab_calc') && ishandle(h.tab_calc))
    return
end

% retrieve project parameters
proj = h_fig.UserData;

% update emitter popup lists
str_pop = cell(1,proj.nb_channel);
for c = 1:proj.nb_channel
    str_pop{c} = proj.labels{c};
end
slct_don = get(h.popup_don,'value');
slct_acc = get(h.popup_acc,'value');
if slct_don>proj.nb_channel
    slct_don = proj.nb_channel;
end
if slct_acc>proj.nb_channel
    slct_acc = proj.nb_channel;
end
set(h.popup_don,'string',str_pop,'value',slct_don);
set(h.popup_acc,'string',str_pop,'value',slct_acc);

% update FRET calculations list
nFRET = size(proj.FRET,1);
if nFRET>0
    str_lst = cell(1,nFRET);
    for fret = 1:nFRET
        str_lst{fret} = ['FRET from ',proj.labels{proj.FRET(fret,1)},' to ',...
            proj.labels{proj.FRET(fret,2)}];
    end
    slct = get(h.list_FRET,'value');
    if slct>nFRET
        slct = nFRET;
    end
else
    str_lst = {''};
    slct = 1;
end
set(h.list_FRET,'string',str_lst,'value',slct);

if nFRET>0
    % update FRET pair list
    str_pop = cell(1,nFRET);
    for fret = 1:nFRET
        str_pop{fret} = [proj.labels{proj.FRET(fret,1)},'-',...
            proj.labels{proj.FRET(fret,2)}];
    end
    slct = get(h.popup_S,'value');
    if slct>nFRET
        slct = nFRET;
    end
    set(h.popup_S,'enable','on','string',str_pop,'value',slct);

    % update S calculations list
    nS = size(proj.S,1);
    if nS>0
        str_lst = cell(1,nS);
        for s = 1:nS
            str_lst{s} = ['Stoichiometry of ',proj.labels{proj.S(s,1)},'-',...
                proj.labels{proj.S(s,2)}];
        end
        slct = get(h.list_S,'value');
        if slct>nS
            slct = nS;
        end
    else
        str_lst = {''};
        slct = 1;
    end
    set(h.list_S,'enable','on','string',str_lst,'value',slct);
    
    % update labelling text
    set([h.text_stoich,h.text_pair],'enable','on');
    
    % update management buttons
    set([h.push_addS,h.push_remS],'enable','on');
    
else
    set([h.text_stoich,h.text_pair,h.popup_S,h.list_S,h.push_addS,...
        h.push_remS],'enable','off');
    set(h.popup_S,'string',{''},'value',1);
end
