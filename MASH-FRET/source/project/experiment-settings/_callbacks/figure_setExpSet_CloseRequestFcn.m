function figure_setExpSet_CloseRequestFcn(obj,evd,h_fig,h_fig0,ok)

% reset project structure if process is aborted
if ~ok
    h_fig0.UserData = [];
end
delete(h_fig);