function figure_setExpSet_CloseRequestFcn(obj,evd,h_fig,h_fig0,h0,ok)

% save experiment settings as default
if ok
    h0 = guidata(h_fig0);
    h0.param.es = setExpSetFromProj(h0.param.es,h_fig.UserData);
end
h0 = rmfield(h0,'figure_setExpSet');
guidata(h_fig0,h0);

delete(h_fig);