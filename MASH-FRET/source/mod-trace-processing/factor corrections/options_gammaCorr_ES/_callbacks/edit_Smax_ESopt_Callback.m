function edit_Smax_ESopt_Callback(obj,evd,h_fig,h_fig2)

q = guidata(h_fig2);
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
fret = p.proj{proj}.TP.fix{3}(8);

val = str2double(get(obj,'string'));
valmin = q.prm{2}(fret,5);
if ~(numel(val)==1 && ~isnan(val) && val>valmin)
    set(obj,'backgroundcolor',[1,0.5,0.5]);
    setContPan(cat(2,'(1/S)-axis upper limit must be > ',num2str(valmin)),...
        'error',h_fig);
    return
end
if val==q.prm{2}(fret,6)
    return
end

q.prm{2}(fret,6) = val;
q.prm{4}{fret} = []; % reset ES
q.prm{5} = []; % reset corrected ES
guidata(h_fig2,q);

ud_ESlinRegOpt(h_fig,h_fig2)


