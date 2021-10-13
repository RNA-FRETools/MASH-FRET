function p = adjustProjIndexLists(p,n,mod)
% p = adjustProjIndexLists(p,n)
%
% Increment project-related index lists by n projects.
% If n is negative, the lists are decremented
%
% p: structure containing interface content
% n: number of increments
% mod: {1-by-n} projects' current modules with:
%  mod{x}: 'S', 'VP', 'TP', 'HA', or 'TA' for modules "Simulation", "Video
%  Processing", "Trace Processing", "Histogram Analysis" or "Transisiton
%  Analysis"

for x = 1:n
    p.curr_mod = [p.curr_mod,mod{x}];
    p.sim.curr_plot = [p.sim.curr_plot,1];
    p.movPr.curr_frame = [p.movPr.curr_frame,1];
    p.movPr.curr_plot = [p.movPr.curr_plot,1];
    p.ttPr.curr_plot = [p.ttPr.curr_plot,1];
    p.ttPr.curr_mol = [p.ttPr.curr_mol,1];
    p.thm.curr_tpe = [p.thm.curr_tpe,1];
    p.thm.curr_tag = [p.thm.curr_tag,1];
    p.thm.curr_plot = [p.thm.curr_plot,1];
    p.TDP.curr_type = [p.TDP.curr_type,1];
    p.TDP.curr_tag = [p.TDP.curr_tag,1];
    p.TDP.curr_plot = [p.TDP.curr_plot,1];
end
 

