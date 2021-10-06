function proj = setExpSetWin(proj,h_fig0)
% proj = setExpSetWin(proj,h_fig0)
%
% Open Experiment settings window and update project structure accordingly.
% Returns updated project structure upon completion and an empty structure 
% upon abortion.
%
% proj: project structure
% h_fig0: handle to main figure

h_fig = build_figSetExpSetWin(proj,h_fig0);
uiwait(h_fig);

% recover updated project's structure
proj = h_fig0.UserData;
h_fig0.UserData = [];
