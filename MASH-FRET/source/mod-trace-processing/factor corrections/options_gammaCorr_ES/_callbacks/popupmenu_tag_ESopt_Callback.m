function popupmenu_tag_ESopt_Callback(obj,evd,h_fig,h_fig2)

val = get(obj,'value');

q = guidata(h_fig2);
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
fret = p.proj{proj}.TP.fix{3}(8);

if val==q.prm{2}(fret,1)
    return
end

q.prm{2}(fret,1) = val;
q.prm{4}{fret} = []; % reset ES
q.prm{5} = []; % reset corrected ES
guidata(h_fig2,q);

ud_ESlinRegOpt(h_fig,h_fig2)


