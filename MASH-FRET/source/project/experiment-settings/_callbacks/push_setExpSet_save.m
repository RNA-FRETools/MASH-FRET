function push_setExpSet_save(obj,evd,h_fig,h_fig0)

% recover project settings from options window
proj = h_fig.UserData;

% determine data to import
h = guidata(h_fig);
imptraj = isfield(h,'text_impTrajFiles') && ishandle(h.text_impTrajFiles);

% read data from trajectory file
if imptraj
    setContPan('Read trajectories from files...','process',h_fig0);
    proj = h_fig.UserData;
    [proj,ok] = loadProj(proj.traj_files{1},proj.traj_files{2},proj,...
        h_fig0);
    if ~ok
        return
    end
end

h_fig0.UserData = proj;

% close options window
figure_setExpSet_CloseRequestFcn([],[],h_fig,h_fig0,1);