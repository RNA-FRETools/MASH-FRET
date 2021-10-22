function ud_EScalc(h_fig,h_fig2)
h = guidata(h_fig);
q = guidata(h_fig2);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
prev_fact = p.proj{proj}.TP.curr{mol}{6}{1};

curr = q.prm{2};
fret = p.proj{proj}.TP.fix{3}(8);
p.proj{proj}.ES = q.prm{4}; % modify temporary ES field in project

[p,ES,gamma,beta,ok,str] = gammaCorr_ES(fret,p,curr,prev_fact,h_fig);

q.prm{4}{fret} = ES;
if numel(ES)==1 && isnan(ES)
    q.prm{5} = NaN;
end
guidata(h_fig2,q);

if ~ok
    setContPan(str,'warning',h_fig);
    return
end

% save results
q.prm{1} = [round(gamma,2);round(beta,2)];
guidata(h_fig2,q);

h.param = p;
guidata(h_fig,h);


