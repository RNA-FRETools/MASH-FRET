function pushbutton_editParam_Callback(obj, evd, h_fig)

% Last update: by MH, 3.4.2019
% >> manage error that occurs after changing FRET and stoichiometry 
%    calculations in project options: adapt fix value of bottom trace plot 
%    popupmenu to popupmenu's string size (last possible option: "all" or 
%    "all FRET" etc.)

h = guidata(h_fig);
if ~isempty(h.param.ttPr.proj)
    
    setContPan('Edit project parameters...','process',h_fig);
    
    p = h.param.ttPr;
    proj = p.curr_proj;
    q{1} = p.proj{proj}.exp_parameters;
    q{2} = p.proj{proj}.FRET;
    q{3} = p.proj{proj}.S;
    
    openItgExpOpt(obj, evd, h_fig);
    
    h = guidata(h_fig);
    uiwait(h.figure_itgExpOpt);
    
    h = guidata(h_fig);
    p = h.param.ttPr;
    r{1} = p.proj{proj}.exp_parameters;
    r{2} = p.proj{proj}.FRET;
    r{3} = p.proj{proj}.S;

    if ~isequal(r,q)
        % added by MH, 3.4.2019
        labels = p.proj{proj}.labels;
        clr = p.proj{proj}.colours;
        exc = p.proj{proj}.excitations;
        
        nFRET = size(r{2},1);
        nMol = numel(h.param.ttPr.proj{proj}.coord_incl);
        nS = size(r{3},1);
        if size(p.proj{proj}.FRET_DTA,2) < nFRET*nMol
            p.proj{proj}.FRET_DTA = [p.proj{proj}.FRET_DTA ...
                nan([size(p.proj{proj}.FRET_DTA,1) ...
                (nFRET*nMol-size(p.proj{proj}.FRET_DTA,2))])];
        elseif size(p.proj{proj}.FRET_DTA,2) < nFRET*nMol
            p.proj{proj}.FRET_DTA = p.proj{proj}.FRET_DTA(1:nMol);
        end
        if size(p.proj{proj}.S_DTA,2) < nS*nMol
            p.proj{proj}.S_DTA = [p.proj{proj}.S_DTA ...
                nan([size(p.proj{proj}.S_DTA,1) ...
                (nS*nMol-size(p.proj{proj}.S_DTA,2))])];
        elseif size(p.proj{proj}.S_DTA,2) < nS*nMol
            p.proj{proj}.S_DTA = p.proj{proj}.S_DTA(1:nMol);
        end
        
        p.defProjPrm = setDefPrm_traces(p, p.curr_proj);
        p.proj{proj}.def.mol = adjustVal(p.proj{proj}.def.mol, ...
            p.defProjPrm.mol);
        p.proj{proj}.fix = adjustVal(p.proj{proj}.fix, ...
            p.defProjPrm.general);
        
        % added by MH, 3.4.2019
        if (nFRET+nS) > 0
            str_bot = getStrPop('plot_botChan',{r{2} r{3} exc clr labels});
            p.proj{proj}.fix{2}(3) = numel(str_bot);
        end
        
        p.proj{proj}.exp = setExpOpt(p.proj{proj}.exp, p.proj{proj});
        
        nMol = numel(p.proj{proj}.coord_incl);
        for n = 1:nMol
            if n > size(p.proj{proj}.prm,2)
                p.proj{proj}.prm{n} = {};
            end
            p.proj{proj}.curr{n} = adjustVal(p.proj{proj}.prm{n}, ...
                p.proj{proj}.def.mol);
        end
        p.proj{proj}.prm = p.proj{proj}.prm(1:nMol);

        p = ud_projLst(p, h.listbox_traceSet);
        h.param.ttPr = p;
        guidata(h_fig, h);
        
        ud_TTprojPrm(h_fig);
    end
    
    updateFields(h_fig,'ttPr');
    
    if ~isequal(r,q)
        setContPan('Project parameters have been successfully modified.',...
            'success',h_fig);
    else
        updateActPan('No project parameters was modified.',h_fig);
    end
end