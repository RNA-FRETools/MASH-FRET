function openItgFileOpt(obj, evd, h_fig)
% Open a window to modify file options for export of raw traces
% "obj" >> handle of pushbutton from which the function has been called
% "evd" >> eventdata structure of the pushbutton from which the function
%          has been called (usually empty)
% "h" >> main data structure stored in figure_MASH's handle

% update 4.2.2019 by MH: created function from scratch

h = guidata(h_fig);
p = h.param;
intsm = p.proj{p.curr_proj}.intensities;

if isempty(intsm)
    setContPan(['No single molecule intensity-time trace detected. Please',...
        ' create traces first by pressing "Create".'],'error',h_fig);
    return
end

buildItgFileOpt(h_fig);
