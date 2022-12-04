function beadsSelect(h_fig)

% Recover mapped coordinates in global variable and update mapping's tool
% GUI

h = guidata(h_fig);
q = h.map;

if ~isempty(q.lim_x)
    nChan = size(q.lim_x,2) - 1;
else
    nChan = numel(q.refimgfile);
end

global pntCoord;
if ~isempty(q.pnt) && size(q.pnt,2)==(2*nChan)
    for i = 1:nChan
        if ~isempty(q.lim_x)
            pntCoord{i}(:,1) = q.pnt(:,2*i-1) - q.lim_x(i);
        else
            pntCoord{i}(:,1) = q.pnt(:,2*i-1);
        end
        pntCoord{i}(:,2) = q.pnt(:,2*i);
    end
else
    pntCoord = cell(1,nChan);
end

updatePnts(h_fig);


