function pushbutton_expTDPopt_next_Callback(obj, evd, h_fig)
% pushbutton_expTDPopt_next_Callback([],[],h_fig)
% pushbutton_expTDPopt_next_Callback(file_out,[],h_fig)
%
% h_fig: handle to main figure
% file_out: {1-by-2} destination folder and file name

h = guidata(h_fig);
h_fig_opt = h.expTDPopt.figure_expTDPopt;
proj = h.param.TDP.curr_proj;
q = guidata(h_fig_opt);
h.param.TDP.proj{proj}.exp = q;
guidata(h_fig, h);

close(h_fig_opt);

if iscell(obj)
    file_out = obj;
    saveTDP(h_fig,file_out);
else
    saveTDP(h_fig);
end