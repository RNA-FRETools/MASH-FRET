function edit_gamma_ESopt_Callback(obj,evd,h_fig2)

q = guidata(h_fig2);
gamma = q.prm{1}(1,1);

set(obj,'string',num2str(gamma));


