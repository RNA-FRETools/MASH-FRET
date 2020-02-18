function pushbutton_itgExpOpt_ok_Callback(obj, evd, but_obj, h_fig)
h = guidata(h_fig);
opt = guidata(h.figure_itgExpOpt);

% added by MH, 3.4.2019
% avoid empty variables with non-zero dimensions
for i = 1:numel(opt)
    if numel(opt{i})==0
        opt{i} = [];
    end
end

h.param.movPr.labels_def = opt{7}{1};

switch but_obj
    case h.pushbutton_chanOpt
        h.param.movPr.itg_expMolPrm = opt{1};
        h.param.movPr.itg_expFRET = opt{3};
        h.param.movPr.itg_expS = opt{4};
        h.param.movPr.itg_clr = opt{5};
        h.param.movPr.chanExc = opt{6};
        h.param.movPr.labels = opt{7}{2};
        guidata(h_fig, h);
        
    case h.pushbutton_editParam
        p = h.param.ttPr;
        proj = p.curr_proj;
        q{1} = p.proj{proj}.exp_parameters;
        q{2} = p.proj{proj}.FRET;
        q{3} = p.proj{proj}.S;
        r{1} = opt{1};
        r{2} = opt{3};
        r{3} = opt{4};
        
        p.proj{proj}.exp_parameters = opt{1};
        p.proj{proj}.FRET = opt{3};
        p.proj{proj}.S = opt{4};
        p.proj{proj}.colours = opt{5};
        p.proj{proj}.chanExc = opt{6};
        p.proj{proj}.labels = opt{7}{2};

        if isequal(r,q)
            h.param.ttPr = p;
            guidata(h_fig, h);
        else
            % added by MH, 3.4.2019
            labels = p.proj{proj}.labels;
            clr = p.proj{proj}.colours;
            exc = p.proj{proj}.excitations;

            nFRET = size(r{2},1);
            nMol = numel(p.proj{proj}.coord_incl);
            nS = size(r{3},1);
            L = size(p.proj{proj}.bool_intensities,1);

            % re-adjust size of array containing state sequences
            if size(p.proj{proj}.FRET_DTA,2) < nFRET*nMol
                p.proj{proj}.FRET_DTA = [p.proj{proj}.FRET_DTA ...
                    nan([L (nFRET*nMol-size(p.proj{proj}.FRET_DTA,2))])];
            elseif size(p.proj{proj}.FRET_DTA,2) > nFRET*nMol
                p.proj{proj}.FRET_DTA = p.proj{proj}.FRET_DTA(1:nFRET*nMol);
            end
            if size(p.proj{proj}.S_DTA,2) < nS*nMol
                p.proj{proj}.S_DTA = [p.proj{proj}.S_DTA ...
                    nan([L (nS*nMol-size(p.proj{proj}.S_DTA,2))])];
            elseif size(p.proj{proj}.S_DTA,2) > nS*nMol
                p.proj{proj}.S_DTA = p.proj{proj}.S_DTA(1:nS*nMol);
            end

            % reset ES histograms
            if ~isequal(r{2},q{2}) || ~isequal(r{3},q{3})
                if nFRET>0
                    p.proj{proj}.ES = cell(1,nFRET);
                else
                    p.proj{proj}.ES = {};
                end
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

            setContPan('Project parameters have been successfully modified.',...
                'success',h_fig);
        end
        
        updateFields(h_fig,'ttPr');
end

close(h.figure_itgExpOpt);
