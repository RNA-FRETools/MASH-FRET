% compute the gamma factor; added by FS, 26.4.2018
function pushbutton_computeGamma_Callback(~, ~, h_fig, h_fig2)

h = guidata(h_fig);
q = guidata(h_fig2);

p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
fret = p.proj{proj}.TP.fix{3}(8);

p.proj{proj}.TP.curr{mol}{6}{1}(1,fret) = q.prm{1}; % gamma factor
p.proj{proj}.TP.curr{mol}{6}{3}(fret,:) = q.prm{2}; % method parameters

% save results
h.param = p;
guidata(h_fig,h);

close(h_fig2);

ud_factors(h_fig);


