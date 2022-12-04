function ok = openItgFileOpt(obj, evd, h_fig)
% ok = openItgFileOpt([],[],h_fig)
%
% Open a window to modify file options for export of raw traces
%
% h_fig: handle to main figure

% update 4.2.2019 by MH: created function from scratch

% default
ok = 0;

h = guidata(h_fig);
p = h.param;
intsm = p.proj{p.curr_proj}.intensities;

if isempty(intsm)
    setContPan(['No single molecule intensity-time trace detected. Please',...
        ' create traces first by pressing "CALCULATE TRACES".'],'error',...
        h_fig);
    return
end

buildItgFileOpt(h_fig);

% return success
ok = 1;
