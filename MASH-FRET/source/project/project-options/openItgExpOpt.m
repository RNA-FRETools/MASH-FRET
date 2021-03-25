function openItgExpOpt(obj, evd, h_fig)
% openItgExpOpt(obj, [], h_fig)
%
% Open a window to modify project parameters
%
% obj: handle to pushbutton from which the function has been called
% h_fig: handle to main figure

% Last update by MH, 3.4.2019: (1) Add project's labels to default labels (FRET and S popupmenus were updated with project's labels and channel popupmenu with defaults that are different when importing ASCII traces) (2) improve default color coding of FRET and S by taking into account the color of last added FRET or S (3) Warn the user and review FRET and Stoichiometry when changing an emitter-specific illumination to "none" (4) review ud_fretPanel, create ud_sPanel and use both to make robust updates of FRET and stoichiometry panels and manage absence of FRET or stoichiometry panels (5) avoid exporting empty parameters with non-zero dimensions, correct typos and remove caps-lock in message boxes 
% update by MH, 4.2.2019: (1) remove "file options" panel (displaced in an other option window created by function openItgExpOpt.m, called by control pushbutton_TTgen_FileOpt)

h = guidata(h_fig);
switch obj
    case h.pushbutton_chanOpt
        p{1} = h.param.movPr.itg_expMolPrm;
        p{2} = [];
        p{3} = h.param.movPr.itg_expFRET;
        p{4} = h.param.movPr.itg_expS;
        p{5} = h.param.movPr.itg_clr;
        p{6} = h.param.movPr.chanExc;
        p{7}{1} = h.param.movPr.labels_def;
        p{7}{2} = h.param.movPr.labels;
        nExc = h.param.movPr.itg_nLasers;
        nChan = h.param.movPr.nChan;
        
    case h.pushbutton_editProj
        currProj = get(h.listbox_proj, 'Value');
        p{1} = h.param.ttPr.proj{currProj}.exp_parameters;
        p{2} = [];
        p{3} = h.param.ttPr.proj{currProj}.FRET;
        p{4} = h.param.ttPr.proj{currProj}.S;
        p{5} = h.param.ttPr.proj{currProj}.colours;
        p{6} = h.param.ttPr.proj{currProj}.chanExc;
        p{7}{1} = h.param.movPr.labels_def;
        p{7}{2} = h.param.ttPr.proj{currProj}.labels;
        nExc = h.param.ttPr.proj{currProj}.nb_excitations;
        nChan = h.param.ttPr.proj{currProj}.nb_channel;
end

% added by MH, 3.4.2019
% adjust default labels with project labels if any and different:
nLabels = numel(p{7}{1});
isincluded = false(1,numel(p{7}{2}));
for i = 1:numel(p{7}{2})
    for j = 1:nLabels
        if strcmp(p{7}{2}(i),p{7}{1}(j))
            isincluded(i) = true;
        end
    end
    if ~isincluded(i)
        p{7}{1} = [p{7}{1} p{7}{2}(i)];
    end
end

buildWinOpt(p, nExc, nChan, obj, h_fig);

