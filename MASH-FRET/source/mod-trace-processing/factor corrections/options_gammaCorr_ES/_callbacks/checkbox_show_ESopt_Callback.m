function checkbox_show_ESopt_Callback(obj,evd,h_fig,h_fig2)

val = get(obj,'value');

q = guidata(h_fig2);
q.prm{3} = val;
guidata(h_fig2,q);

ud_ESlinRegOpt(h_fig,h_fig2)


