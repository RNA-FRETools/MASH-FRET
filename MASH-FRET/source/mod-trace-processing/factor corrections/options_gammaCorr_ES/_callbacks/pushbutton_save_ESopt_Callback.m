function pushbutton_save_ESopt_Callback(obj,evd,h_fig,h_fig2)

h = guidata(h_fig);
q = guidata(h_fig2);

p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
fret = p.proj{proj}.TP.fix{3}(8);
method = p.proj{proj}.TP.curr{mol}{6}{2}(1);
N = size(p.proj{proj}.TP.prm,2);

% set options and gamma factors to all molecules using the same method
for n = 1:N
    if p.proj{proj}.TP.curr{n}{6}{2}(1)==method
        p.proj{proj}.TP.curr{n}{6}{1}(:,fret) = q.prm{1}; % gamma amd beta factors
        p.proj{proj}.TP.curr{n}{6}{4} = q.prm{2}; % method parameters
    end
end
p.proj{proj}.ES = q.prm{4};

% save results
h.param = p;
guidata(h_fig,h);

close(h_fig2);

ud_factors(h_fig);


