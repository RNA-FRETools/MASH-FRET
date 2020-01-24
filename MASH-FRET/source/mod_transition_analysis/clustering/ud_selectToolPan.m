function ud_selectToolPan(h_fig)

h = guidata(h_fig);

h_tb = [h.tooglebutton_TDPselectSquare,h.tooglebutton_TDPselectElStr,...
    h.tooglebutton_TDPselectElDiag];
tool = get(h.tooglebutton_TDPmanStart,'userdata');
set(h_tb((1:size(h_tb,2))~=tool),'value',0);
if tool>0
    set(h_tb(tool),'value',1);
    set(h.text_TA_tdpCoord,'enable','on');
else
    set(h.text_TA_tdpCoord,'enable','off');
end