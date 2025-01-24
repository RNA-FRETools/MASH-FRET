function p = adjustProjIndexLists(p,xn,mod)
% p = adjustProjIndexLists(p,xn)
%
% Increment project-related index lists with projects having indexes xn.
% Negative project indexes are removed from lists
%
% p: structure containing interface content
% xn: project indexes to add
% mod: {1-by-n} projects' current modules with:
%  mod{x}: 'S', 'VP', 'TP', 'HA', or 'TA' for modules "Simulation", "Video
%  Processing", "Trace Processing", "Histogram Analysis" or "Transisiton
%  Analysis"

excl = false(size(p.sim.curr_plot));
for x = 1:numel(xn)
    
    % handle case where project index is out of list range (can happen when
    % project import failed)
    if abs(xn(x))>numel(p.proj)
        continue
    end

    if xn(x)<0
        excl(-xn(x)) = true;
    else
        if isfield(p.proj{xn(x)},'module') && ...
                ~isempty(p.proj{xn(x)}.module)
            p.curr_mod = [p.curr_mod,p.proj{xn(x)}.module];
        else
            p.curr_mod = [p.curr_mod,mod{x}];
        end
        p.proj{xn(x)}.module = p.curr_mod(end);
        p.sim.curr_plot = [p.sim.curr_plot,1];
        p.sim.curr_pan = [p.sim.curr_pan,0];
        p.movPr.curr_frame = [p.movPr.curr_frame,1];
        p.movPr.curr_plot = [p.movPr.curr_plot,1];
        p.movPr.curr_pan = [p.movPr.curr_pan,0];
        p.ttPr.curr_plot = [p.ttPr.curr_plot,1];
        p.ttPr.curr_mol = [p.ttPr.curr_mol,1];
        p.ttPr.curr_pan = [p.ttPr.curr_pan,0];
        p.thm.curr_tpe = [p.thm.curr_tpe,1];
        p.thm.curr_tag = [p.thm.curr_tag,1];
        p.thm.curr_plot = [p.thm.curr_plot,1];
        p.thm.curr_pan = [p.thm.curr_pan,0];
        p.TDP.curr_type = [p.TDP.curr_type,1];
        p.TDP.curr_tag = [p.TDP.curr_tag,1];
        p.TDP.curr_plot = [p.TDP.curr_plot,1];
        p.TDP.curr_pan = [p.TDP.curr_pan,0];
    end
end

p.curr_mod(excl) = [];
p.sim.curr_plot(excl) = [];
p.movPr.curr_frame(excl) = [];
p.movPr.curr_plot(excl) = [];
p.movPr.curr_pan(excl) = [];
p.ttPr.curr_plot(excl) = [];
p.ttPr.curr_mol(excl) = [];
p.ttPr.curr_pan(excl) = [];
p.thm.curr_tpe(excl) = [];
p.thm.curr_tag(excl) = [];
p.thm.curr_plot(excl) = [];
p.thm.curr_pan(excl) = [];
p.TDP.curr_type(excl) = [];
p.TDP.curr_tag(excl) = [];
p.TDP.curr_plot(excl) = [];
p.TDP.curr_pan(excl) = [];
 

