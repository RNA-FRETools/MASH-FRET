function setExpSetWin(proj,dat2import,h_fig0)
% setExpSetWin(proj,h_fig0)
%
% Open Experiment settings window and update project structure accordingly.
% Store updated project structure in figure's userdata properties.
%
% proj: project structure
% dat2import: data to import from file ('video' or 'trajectories')
% h_fig0: handle to main figure


% display process
setContPan('Opening experiment settings window...','process',h_fig0);

build_figSetExpSetWin(proj,dat2import,h_fig0);

% display success
setContPan('Experiment settings window ready!','success',h_fig0);
