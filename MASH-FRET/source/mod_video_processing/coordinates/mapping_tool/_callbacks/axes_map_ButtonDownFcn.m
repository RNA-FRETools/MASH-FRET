function axes_map_ButtonDownFcn(obj, evd, h_fig, chan)
% axes_ButtonDownFcn([],[],h_fig,chan)
% axes_ButtonDownFcn(pnt,[],h_fig,chan)
%
% h_fig: handle to main figure
% chan: channel where point coordinates were taken from
% pnt: point coordinates
%
% axes_ButtonDownFcn can be called from the mapping tool's GUI or from a test routine.
% When called from MASH-FRET's GUI, coordinates are selected with the mouse. 
% When called from a test routine, coordinates are taken from the corresponding input argument.

global pntCoord;
h = guidata(h_fig);
q = h.map;

if ~iscell(obj)
    newPnt = get(q.axes_top(chan), 'CurrentPoint');
    disp(newPnt);
    newPnt = fix(newPnt(1,1:2))+0.5;
    disp(newPnt);
else
    newPnt = obj{1}; % from routine test
end

n = size(pntCoord{chan},1);
n_tot = 0;
for i = 1:size(pntCoord,2)
    n_tot = n_tot + size(pntCoord{i},1);
end
pntCoord{chan}(n+1,1) = newPnt(1);
pntCoord{chan}(n+1,2) = newPnt(2);
pntCoord{chan}(n+1,3) = n_tot + 1;

updatePnts(h_fig);
