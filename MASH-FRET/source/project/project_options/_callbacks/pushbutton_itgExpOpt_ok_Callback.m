function pushbutton_itgExpOpt_ok_Callback(obj, evd, but_obj, h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);

% added by MH, 3.4.2019
% avoid empty variables with non-zero dimensions
for i = 1:numel(p)
    if numel(p{i})==0
        p{i} = [];
    end
end

switch but_obj
    case h.pushbutton_chanOpt
        h.param.movPr.itg_expMolPrm = p{1};
        h.param.movPr.itg_expFRET = p{3};
        h.param.movPr.itg_expS = p{4};
        h.param.movPr.itg_clr = p{5};
        h.param.movPr.chanExc = p{6};
        h.param.movPr.labels = p{7}{2};
        
    case h.pushbutton_editParam
        currProj = get(h.listbox_traceSet, 'Value');
        h.param.ttPr.proj{currProj}.exp_parameters = p{1};
        h.param.ttPr.proj{currProj}.FRET = p{3};
        h.param.ttPr.proj{currProj}.S = p{4};
        h.param.ttPr.proj{currProj}.colours = p{5};
        h.param.ttPr.proj{currProj}.chanExc = p{6};
        h.param.ttPr.proj{currProj}.labels = p{7}{2};
end
h.param.movPr.labels_def = p{7}{1};
guidata(h_fig, h);


close(h.figure_itgExpOpt);