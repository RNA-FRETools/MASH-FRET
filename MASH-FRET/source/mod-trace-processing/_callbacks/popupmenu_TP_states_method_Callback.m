function popupmenu_TP_states_method_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
meth = get(obj, 'Value');

if meth==3 % 2D-vbFRET discretize bottom traces only
    p.proj{proj}.TP.curr{mol}{4}{1}(1) = meth;
    h.param = p;
    guidata(h_fig, h);
    
    set(h.popupmenu_TP_states_applyTo,'value',1);
    popupmenu_TP_states_applyTo_Callback(h.popupmenu_TP_states_applyTo,...
        [],h_fig)
    
elseif meth==7 % Imported
    if ~(isfield(p.proj{proj},'FRET_DTA_import') && ...
            ~isempty(p.proj{proj}.FRET_DTA_import))
        setContPan(['"Imported" method can not be used for this project: ',...
            'no imported FRET state sequences were found.'],'warning',...
            h_fig);
    else
        p.proj{proj}.TP.curr{mol}{4}{1}(1) = meth;
        h.param = p;
        guidata(h_fig, h);
        
        set(h.popupmenu_TP_states_applyTo,'value',1);
        popupmenu_TP_states_applyTo_Callback(h.popupmenu_TP_states_applyTo,...
            [],h_fig)
    end
end

ud_DTA(h_fig);
