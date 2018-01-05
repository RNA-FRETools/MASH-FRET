function new_coord = recenterSpot(img, raw_coord, aDim, res)

pixMax = 3;
coord = raw_coord;
new_coord = raw_coord;
extr = floor(aDim/2);

i_px = 1;
while i_px <= pixMax+1
    surroundPix = [];
    l = 1;
    for j = -1:1
        for k = -1:1
            if ~(j == 0 && i_px == 0) && ...
                ceil(coord(2))+j-extr > 0 && ...
                ceil(coord(2))+j+extr < res.y(2) && ...
                ceil(coord(1))+k-extr > 0 && ...
                ceil(coord(1))+k+extr < res.x(2)
                coord = ceil(coord);
                surroundPix(l,1) = img(coord(2)+j, coord(1)+k);
                surroundPix(l,2) = coord(2)+j;
                surroundPix(l,3) = coord(1)+k;
                l = l + 1;
            end
        end
    end
    if isempty(surroundPix)
        return;
    end
    [pixSort, ind] = sort(surroundPix(:, 1), 1, 'descend');
    if pixSort(1,1) > img(coord(2),coord(1))
        if i_px == pixMax + 1;
            new_coord = raw_coord;
            return;
        else
            coord(2) = surroundPix(ind(1,1),2)-0.5;
            coord(1) = surroundPix(ind(1,1),3)-0.5;
            new_coord = coord;
        end
        i_px = i_px + 1;
    else
        return;
    end
end


