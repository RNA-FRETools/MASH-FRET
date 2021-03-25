function popupmenu_expTDPopt_TDPimg_Callback(obj, evd, h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{2}(4) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);


