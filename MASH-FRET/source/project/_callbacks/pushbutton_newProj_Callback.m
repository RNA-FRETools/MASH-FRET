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
        proj = setProjDef_sim(proj,h0.param.sim);
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
        mod = 'TP';
end

% add project to list and initialize list indexes
p = h.param;
p.proj = [p.proj,proj];
p.curr_mod = [p.curr_mod,mod];
p.sim.curr_plot = [p.sim.curr_plot,1];
p.movPr.curr_frame = [p.movPr.curr_frame,1];
p.movPr.curr_plot = [p.movPr.curr_plot,1];
p.ttPr.curr_plot = [p.ttPr.curr_plot,1];
p.ttPr.curr_mol = [p.ttPr.curr_mol,1];
p.thm.curr_tpe = [p.thm.curr_tpe,1];
p.thm.curr_tag = [p.thm.curr_tag,1];
p.thm.curr_plot = [p.thm.curr_plot,1];
p.TDP.curr_type = [p.TDP.curr_type,1];
p.TDP.curr_tag = [p.TDP.curr_tag,1];
p.TDP.curr_plot = [p.TDP.curr_plot,1];

p.curr_proj = proj_id;

% update project list
p = ud_projLst(p, h.listbox_proj);

% save modifications
h.param = p;
guidata(h_fig,h);

% switch to proper module
switchPan(eval(['h.togglebutton_',p.curr_mod{p.curr_proj}]),[],h_fig);

updateFields(h_fig);
