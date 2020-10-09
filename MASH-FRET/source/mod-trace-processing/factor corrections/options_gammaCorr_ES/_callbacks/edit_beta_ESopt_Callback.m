function edit_beta_ESopt_Callback(obj,evd,h_fig2)

q = guidata(h_fig2);
beta = q.prm{1}(2,1);

set(obj,'string',num2str(beta));


