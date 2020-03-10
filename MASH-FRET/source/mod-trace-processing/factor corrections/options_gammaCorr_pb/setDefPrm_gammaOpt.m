function setDefPrm_gammaOpt(h_fig,h_fig2)

q = guidata(h_fig2);
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);
fret = p.proj{proj}.fix{3}(8);

q.prm = cell(1,2);
q.prm{1} = NaN; % gamma
q.prm{2} = p.proj{proj}.curr{mol}{6}{3}(fret,:);
q.prm{3} = []; % state sequences

guidata(h_fig2,q);


