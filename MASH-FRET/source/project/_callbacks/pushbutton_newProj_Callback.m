function pushbutton_newProj_Callback(obj,evd,h_fig)
% pushbutton_newProj_Callback([],[],h_fig)
% pushbutton_newProj_Callback([],act,h_fig)
%
% h_but: handle to "New project" pushbutton
% act: 1 (simulation), 2 (import video), 3 (import trajectories), 4 (import histogram)
% h_fig: handle to main figure

% open data selector
if isnumeric(evd) % call from test routine
    act = slctdatdlg(h_fig,evd);
else
    act = slctdatdlg(h_fig);
end
if ~any(act==(1:4))
    return
end

% generate empty project
proj = createEmptyProj(h_fig);

% initializes project
h0 = guidata(h_fig);
switch act
    case 1
        % set default smimulation project
        proj = setProjDef_sim(proj,h0.param);
        
        % ask user for experiment settings
        setExpSetWin(proj,'sim',h_fig);
        
    case 2
        % set default VP project
        proj = setProjDef_vid(proj,h0.param);
        
        % ask user for experiment settings, import video
        setExpSetWin(proj,'video',h_fig); % /!\ guidata is modified here

    case 3
        % ask user for trajectory files and import data
        proj = setProjDef_traj(proj,h_fig); 

        % ask user for experiment settings, import trajectories
        setExpSetWin(proj,'trajectories',h_fig); % /!\ guidata is modified here

    case 4
        % ask user for histogram files and import data
        proj = setProjDef_hist(proj,h0.param); 

        % ask user for experiment settings, import trajectories
        setExpSetWin(proj,'histogram',h_fig);
end

