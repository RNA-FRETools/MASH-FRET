function popupmenu_data_pbGamma_Callback(obj, ~, h_fig, h_fig2)

q = guidata(h_fig2);
q.prm{2}(1) = get(obj, 'Value');
guidata(h_fig2,q);

ud_pbGamma(h_fig,h_fig2)


