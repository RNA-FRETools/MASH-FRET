function ok = exclude_doublecoord(tol, coord)
% Return a boolean vector regarding weather the input coordinates are
% doublons
% "coord" >> [n-by-2*m] array, contains the (x,y) coordinates in the m
% channels
% "tol" >> minimum spot-spot distance
% "ok" >> [n-by-1] boolean vector, listing 0 for double coordinates.

% Last update: 10th of February 2014 by Mélodie C.A.S Hadzic

[N,~] = size(coord);
ok = true(N,1);
id = (1:N)';

for j = 1:size(coord,1)-1
    if ~ok(j,1)
        continue
    end
    isdbl = id~=j & abs(coord(j,1:2:end)-coord(:,1:2:end))<tol & ...
        abs(coord(j,2:2:end)-coord(:,2:2:end))<tol;
    if any(isdbl)
        ok(j,1) = false;
        ok(isdbl',1) = false;
    end
%     for i = j+1:size(coord,1)
%         if sum((abs(coord(j,1:2:end)-coord(i,1:2:end))<tol)) && ...
%                 sum((abs(coord(j,2:2:end)-coord(i,2:2:end))<tol))
%             ok(i,1) = false;
%             ok(j,1) = true;
%         end
%     end
end