function radio_setExpSet_impFile(obj,evd,h_fig)

h = guidata(h_fig);
proj = h_fig.UserData;

if obj==h.radio_impFileMulti
    h.radio_impFileSingle.Value = ~h.radio_impFileMulti.Value;
    proj = updateProjVideoParam(proj,h.radio_impFileMulti.Value);
else
    h.radio_impFileMulti.Value = ~h.radio_impFileSingle.Value;
    proj = updateProjVideoParam(proj,h.radio_impFileMulti.Value);
end

h_fig.UserData = proj;

ud_setExpSet_tabImp(h_fig);
ud_setExpSet_tabChan(h_fig);
ud_expSet_chanPlot(h_fig);