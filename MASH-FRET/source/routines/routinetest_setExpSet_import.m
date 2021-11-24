function routinetest_setExpSet_import(h_fig0,p,prefix)
% routinetest_setExpSet_import(h_fig0,p,prefix)
%
% Set tab "Import" of experiment settings to proper values 
%
% h_fig0: handle to main figure
% p: structure containing default as set by getDefault_VP
% prefix: string to add at the beginning of each action string (usually a apecific indent)

h0 = guidata(h_fig0);
h_fig = h0.figure_setExpSet;
h = guidata(h_fig);

prm = p.es{p.nChan,p.nL}.imp;

% set video file
if isfield(prm,'vfile') && ~isempty(prm.vfile)
    push_setExpSet_impFile({p.annexpth,prm.vfile},[],h_fig,h_fig0);
end

% set trajectory files
if isfield(prm,'tfiles') && ~isempty(prm.tfiles)
    push_setExpSet_impTrajFiles({[p.annexpth,filesep,prm.tdir],prm.tfiles},...
        [],h_fig,h_fig0);
end

% set coordinates file
if isfield(prm,'coordfile') && ~isempty(prm.coordfile)
    prm.coordopt = {[(1:2:2*p.nChan)',(2:2:2*p.nChan)'],1};
    set_VP_impIntgrOpt(prm.coordopt,h.push_impCoordOpt,h_fig0);
    push_setExpSet_impCoordFile({p.annexpth,prm.coordfile},[],h_fig,h_fig0);
end

% set gamma factor file
if isfield(prm,'gammafile') && ~isempty(prm.gammafile)
    push_setExpSet_impGammaFile({p.annexpth,prm.gammafile},[],h_fig,...
        h_fig0);
end

% set beta factor file
if isfield(prm,'betafile') && ~isempty(prm.betafile)
    push_setExpSet_impBetaFile({p.annexpth,prm.betafile},[],h_fig,...
        h_fig0);
end



