function pushbutton_editProj_Callback(obj,evd,h_fig)

% retrieve interface content
h = guidata(h_fig);
p = h.param;

% retrieve project content
proj = p.proj{p.curr_proj};

% ask user for experiment settings
if ~isempty(proj.sim)
    proj_new = setExpSetWin(proj,'sim',h_fig);
else
    proj_new = setExpSetWin(proj,'',h_fig);
end
if ~(~isempty(proj_new) && ~isequal(proj,proj_new))
    return
end
p.proj{p.curr_proj} = proj_new;

% retrieve new project parameters
labels = proj_new.labels;
clr = proj_new.colours;
exc = proj_new.excitations;
nFRET = size(proj_new.FRET,1);
nMol = numel(proj_new.coord_incl);
nS = size(proj_new.S,1);
L = size(proj_new.bool_intensities,1);

% re-adjust size of array containing state sequences
if size(proj_new.FRET_DTA,2)<nFRET*nMol
    proj_new.FRET_DTA = [proj_new.FRET_DTA ...
        nan([L (nFRET*nMol-size(proj_new.FRET_DTA,2))])];
elseif size(proj_new.FRET_DTA,2) > nFRET*nMol
    proj_new.FRET_DTA = proj_new.FRET_DTA(1:nFRET*nMol);
end
if size(proj_new.S_DTA,2)<nS*nMol
    proj_new.S_DTA = [proj_new.S_DTA ...
        nan([L (nS*nMol-size(proj_new.S_DTA,2))])];
elseif size(proj_new.S_DTA,2) > nS*nMol
    proj_new.S_DTA = proj_new.S_DTA(1:nS*nMol);
end

% reset ES histograms
if ~isequal(proj.FRET,proj_new.FRET) || ~isequal(proj.S,proj_new.S)
    if nFRET>0
        proj_new.ES = cell(1,nFRET);
    else
        proj_new.ES = {};
    end
end

if isModuleOn(p,'TP')
    % resize default TP parameters
    p.ttPr.defProjPrm = setDefPrm_traces(p, p.curr_proj);
    proj_new.TP.def.mol = adjustVal(proj_new.TP.def.mol, ...
        p.ttPr.defProjPrm.mol);
    
    % resize general TP parameters
    proj_new.TP.fix = adjustVal(proj_new.TP.fix, ...
        p.ttPr.defProjPrm.general);

    % adjust selection in the list of bottom traces in "Plot" panel
    if (nFRET+nS)>0
        str_bot = getStrPop('plot_botChan',{proj_new.FRET,...
            proj_new.S,exc,clr,labels});
        proj_new.TP.fix{2}(3) = numel(str_bot);
    end
    
    % resize TP's export options
    proj_new.TP.exp = setExpOpt(proj_new.TP.exp,proj_new);
    
    % resize TP's processing parameters
    for n = 1:nMol
%         if n>size(proj_new.TP.prm,2)
%             proj_new.TP.prm{n} = {};
%         end
        proj_new.TP.curr{n} = adjustVal(proj_new.TP.prm{n}, ...
            proj_new.TP.def.mol);
    end
%     proj_new.TP.prm = proj_new.TP.prm(1:nMol);
end

% update project list
p = ud_projLst(p, h.listbox_proj);

% save modifications
h.param = p;
guidata(h_fig, h);

% update TP interface according to new parameters
ud_TTprojPrm(h_fig);

% display success
setContPan('Experiment settings successfully modified!','success',h_fig);
