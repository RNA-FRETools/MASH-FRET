function ok = select_spots_distance(coord, tol)
% Return a boolean vector regarding weather the input coordinates are too
% close from each other or not
% "coord" >> [n-by-2] array, contains the raw spots coordinates
% "tol" >> minimum inter-spot distance
% "ok" >> [n-by-1] boolean vector, listing 0 for out-of-range coordinates.

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

[n o] = size(coord);
ok = true(n,1);

for i = 1:n
    [r,c,v] = find(coord(i+1:n,2) < (sqrt((tol^2) - (coord(i+1:n,1) - ...
        coord(i,1)).^2) + coord(i,2)) & ...
        coord(i+1:n,2) > (-sqrt((tol^2) - (coord(i+1:n,1) - ...
        coord(i,1)).^2) + coord(i,2)));
    if ~isempty(r)
        ok(r',1) = false;
        ok(i,1) = false;
    end
end