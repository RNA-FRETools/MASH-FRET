function beadsSelect(h_fig)

% Recover mapped coordinates in global variable and update mapping's tool
% GUI

h = guidata(h_fig);
q = h.map;

nChan = size(q.lim_x,2) - 1;

global pntCoord;
if ~isempty(q.pnt) && size(q.pnt,2)==(2*nChan)
    for i = 1:nChan
        pntCoord{i}(:,1) = q.pnt(:,2*i-1) - q.lim_x(i);
        pntCoord{i}(:,2) = q.pnt(:,2*i);
    end
else
    pntCoord = cell(1,nChan);
end

updatePnts(h_fig);


