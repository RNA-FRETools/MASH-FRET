function checkbox_expTDPopt_mdlSlct_Callback(obj,evd,h_fig)
h = guidata(h_fig);
prm = guidata(h.expTDPopt.figure_expTDPopt);
prm{4}(1) = get(obj, 'Value');
guidata(h.expTDPopt.figure_expTDPopt,prm);
ud_expTDPopt(h_fig);