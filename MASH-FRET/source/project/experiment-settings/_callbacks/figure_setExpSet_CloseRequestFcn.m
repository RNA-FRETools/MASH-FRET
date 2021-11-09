function figure_setExpSet_CloseRequestFcn(obj,evd,h_fig,h_fig0,ok)

% reset project structure if process is aborted
if ~ok
    h_fig0.UserData = [];
else
    h0 = guidata(h_fig0);
    h0.param.es = setExpSetFromProj(h0.param.es,h_fig0.UserData);
    guidata(h_fig0,h0);
end
delete(h_fig);