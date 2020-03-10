function setDefPrm_ESlinRegOpt(h_fig,h_fig2)

h = guidata(h_fig);
q = guidata(h_fig2);

p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);
curr = p.proj{proj}.curr{mol}{6};

q.prm = cell(1,5);
q.prm{1} = ones(2,1); % gamma and beta factors
q.prm{2} = curr{4}; % processing parameters
q.prm{3} = false; % show corrected ES
q.prm{4} = p.proj{proj}.ES; % ES histograms
q.prm{5} = []; % corrected ES histogram

guidata(h_fig2,q);


