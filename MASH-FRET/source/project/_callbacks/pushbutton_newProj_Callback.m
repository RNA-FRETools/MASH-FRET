function pushbutton_newProj_Callback(obj,evd,h_fig)

% open data selector
act = slctdatdlg(h_fig);
% act = 1; % simulate data
% act = 2; % import video
% act = 3; % import trajectories
if ~any(act==[1,2,3])
    return
end

% generate empty project
proj = createEmptyProj(h_fig);

% initializes project
h0 = guidata(h_fig);
proj_id = numel(h0.param.proj)+1;
switch act
    case 1
        proj = setProjDef_sim(proj,h0.param);
        h = h0;
        mod = 'S';
        
    case 2
        % ask user for video file and import data
        proj = setProjDef_vid(proj,h0.param,h_fig); % /!\ guidata is modified here
        if isempty(proj)
            guidata(h_fig,h0); % reset modif made to guidata
            return
        end
        h = guidata(h_fig);
        mod = 'VP';
        
    case 3
        % ask user for trajectory files and import data
        proj = setProjDef_traj(proj,h_fig); % /!\ guidata is modified here
        if isempty(proj)
            guidata(h_fig,h0); % reset modif made to guidata
            return
        end
        h = guidata(h_fig);
        mod = 'TP';
end

% add project to list and initialize list indexes
p = h.param;
p.proj = [p.proj,proj];
p.curr_proj = proj_id;
p = adjustProjIndexLists(p,proj_id,{mod});

% set processing parameters
p = importSim(p,proj_id);
p = importVP(p,proj_id);
p = importTP(p,proj_id);
p = importHA(p,proj_id);
p = importTA(p,proj_id);

% update project list
p = ud_projLst(p, h.listbox_proj);

% save modifications
h.param = p;
guidata(h_fig,h);

% update project-dependant TP interface
ud_TTprojPrm(h_fig);

% make root folder current directory
cd(p.proj{p.curr_proj}.folderRoot);

% switch to proper module
switchPan(eval(['h.togglebutton_',p.curr_mod{p.curr_proj}]),[],h_fig);

% bring project's current plot front
bringPlotTabFront([p.sim.curr_plot(p.curr_proj),...
    p.movPr.curr_plot(p.curr_proj),p.ttPr.curr_plot(p.curr_proj),...
    p.thm.curr_plot(p.curr_proj),p.TDP.curr_plot(p.curr_proj)],h_fig);

% refresh interface
updateFields(h_fig);

% display success
setContPan(['Project "',p.proj{p.curr_proj}.exp_parameters{1,2},'" ready!'],...
    'success',h_fig);
