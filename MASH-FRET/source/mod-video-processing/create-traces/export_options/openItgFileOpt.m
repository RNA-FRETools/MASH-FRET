function openItgFileOpt(obj, evd, h_fig)
% Open a window to modify file options for export of raw traces
% "obj" >> handle of pushbutton from which the function has been called
% "evd" >> eventdata structure of the pushbutton from which the function
%          has been called (usually empty)
% "h" >> main data structure stored in figure_MASH's handle

% update 4.2.2019 by MH: created function from scratch

h = guidata(h_fig);
p = h.param;
coordsm = p.proj{p.curr_proj}.VP.curr.gen_int{2}{1};

if isempty(coordsm)
    setContPan(['No single molecule coordinates detected. Please ',...
        'transform spots coordinates or import single molecule ',...
        'coordinates.'],'error',h_fig);
    return
end

buildItgFileOpt(h_fig);
