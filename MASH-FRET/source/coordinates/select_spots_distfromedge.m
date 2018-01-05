function ok = select_spots_distfromedge(coord, tol, lim)    
% Return a boolean vector regarding weather the input coordinates are too
% close from the image edge
% "coord" >> [n-by-2] array, contains the raw spots coordinates
% "tol" >> minimum image edge-spot distance
% "lim" >> [2-by-2] matrix, contains x (1st row) and y (2nd row) image
% edges
% "ok" >> [n-by-1] boolean vector, listing 0 for out-of-range coordinates.

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

[n,o] = size(coord);
ok = true(n,1);

for i = 1:n                
    if ((coord(i,1) - tol) <= lim(1,1) || ...
        (coord(i,1) + tol) >= lim(1,2) || ...
        (coord(i,2) - tol) <= lim(2,1) || ...
        (coord(i,2) + tol >= lim(2,2)))
        ok(i,1) = false;
    end
end