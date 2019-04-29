function p = impSimCoord(fname, pname, p, h_fig)
% Requires external functions: setContPan

% Last update: 22nd of May 2014 by Mélodie C.A.S. Hadzic

coord = [];

h = guidata(h_fig);

fDat = importdata([pname fname], '\n');

for i = 1:size(fDat,1)
    l = str2num(fDat{i,1});
    if ~isempty(l)
        coord(size(coord,1)+1,:) = l;
    end
end
if ~(size(coord, 2) == 4 || size(coord, 2) == 2)
    setContPan('Unable to import coordinates.', 'error', ...
        h.figure_MASH);
    p.coord = [];
    p.coordFile = [];
    p.genCoord = 1;
    return;
end

x1 = []; y1 = []; x2 = []; y2 = [];
res_x = h.param.sim.movDim(1);
for col = 1:2:size(coord,2) % x-coordinates
    x1 = [x1; coord(coord(:,col) < round(res_x/2),col)];
    y1 = [y1; coord(coord(:,col) < round(res_x/2),col+1)];
    x2 = [x2; coord(coord(:,col) >= round(res_x/2),col)];
    y2 = [y2; coord(coord(:,col) >= round(res_x/2),col+1)];
end

if isempty(x1) && isempty(x2)
    setContPan('Unable to import coordinates.', 'error', ...
        h.figure_MASH);
    p.coord = [];
    p.coordFile = [];
    p.genCoord = 1;
    return;

elseif isempty(x2) && ~isempty(x1)
    setContPan(['Coordinates in right channel automatically ' ...
        'calculated.'], 'warning', h.figure_MASH);
    x2 = x1+round(res_x/2);
    y2 = y1;

elseif isempty(x1) && ~isempty(x2)
    setContPan(['Coordinates in left channel automatically ' ...
        'calculated.'], 'warning', h.figure_MASH);
    x1 = x2-round(res_x/2);
    y1 = y2;
else
    minN = min([numel(x1) numel(x2)]);
    x1 = x1(1:minN,1); y1 = y1(1:minN,1);
    x2 = x2(1:minN,1); y2 = y2(1:minN,1);
    setContPan({['Coordinates successfully imported from file: ' ...
        fname 'from folder: ' pname]}, 'success', h.figure_MASH);
end
coord = [x1 y1 x2 y2];

p.coord = coord;
p.molNb = size(coord,1);
p.coordFile = [pname fname];
p.genCoord = 0;

