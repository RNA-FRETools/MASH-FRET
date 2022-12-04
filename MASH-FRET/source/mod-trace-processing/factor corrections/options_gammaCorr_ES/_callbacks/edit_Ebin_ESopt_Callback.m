function edit_Ebin_ESopt_Callback(obj,evd,h_fig,h_fig2)

val = str2double(get(obj,'string'));
if ~(numel(val)==1 && ~isnan(val) && val>0)
    set(obj,'backgroundcolor',[1,0.5,0.5]);
    setContPan('Number of E intervals must be > 0 ','error',h_fig);
    return
end

q = guidata(h_fig2);
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
fret = p.proj{proj}.TP.fix{3}(8);

if val==q.prm{2}(fret,4)
    return
end

q.prm{2}(fret,4) = val;
q.prm{4}{fret} = []; % reset ES
q.prm{5} = []; % reset corrected ES
guidata(h_fig2,q);

ud_ESlinRegOpt(h_fig,h_fig2)


