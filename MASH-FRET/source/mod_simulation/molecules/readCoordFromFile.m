function coord = readCoordFromFile(fullfilename)
% Read molecule coordinates from an ASCII file and return the [N-by-2 or 4] coordinates matrix upon success or and empty arry upon failure.
% 
% fullfilename: the full path to source file
% coord: coordinates matrix

% created by MH, 17.12.2019

coord = [];

try
    fDat = importdata(fullfilename, '\n');
catch err
    disp(err.message);
    return
end

for i = 1:size(fDat,1)
    l = str2num(fDat{i,1});
    if ~isempty(l)
        coord(size(coord,1)+1,:) = l;
    end
end

if ~(size(coord, 2) == 4 || size(coord, 2) == 2)
    coord = [];
    return
end
