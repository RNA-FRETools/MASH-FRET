function slctSpots = selectSpots(spots, h_fig)
% Select coordinates corresponding to the selection criteria (minimum
% intensity, spot size, spot assymetry, inter-spot distance, distance from
% image edge, maximum number of spots)
% "spots" >> {1-by-n} cell array, contains the raw spots parameters (x and
% y coordinates, intensity, spot width and height, assymetry) for each of 
% the n channels
% "h_fig" >> figure_MASH handle
% "slctSpots" >> {1-by-n} cell array, contains selected spots parameters
% for each of the n channel.

% Requires external functions: select_spots_distfromedge, 
%                              select_spots_distance 
% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

h = guidata(h_fig);
p = h.param.movPr;

gaussFit = p.SF_gaussFit;
nChan = p.nChan;
sub_w = floor(h.movie.pixelX/p.nChan);
lim = [0 (1:nChan)*sub_w h.movie.pixelX];
limY = [1 h.movie.pixelY];
slctSpots = cell(1,nChan);

for i = 1:nChan
    minDspot = p.SF_minDspot(i);
    minDedge = p.SF_minDedge(i);

    % check the intensity
    if ~isempty(spots{1,i})
        minI = p.SF_minI(i);
        slctSpots{1,i} = spots{1,i}((spots{1,i}(:,3) >= minI), :);
    end

    if ~isempty(slctSpots{1,i}) && size(slctSpots{1,i},2) > 3 && gaussFit
        % check the spot WHM
        minHW = p.SF_minHWHM(i);
        maxHW = p.SF_maxHWHM(i);
        slctSpots{1,i} = slctSpots{1,i}((slctSpots{1,i}(:,5) > minHW & ...
            slctSpots{1,i}(:,5) < maxHW), :);
        if ~isempty(slctSpots{1,i})
            slctSpots{1,i} = slctSpots{1,i}((slctSpots{1,i}(:,6) > ...
                minHW & slctSpots{1,i}(:,6) < maxHW), :);
        end
        
        if ~isempty(slctSpots{1,i})
            % check the spot assymetry
            assym = p.SF_maxAssy(i);
            slctSpots{1,i} = slctSpots{1,i}((slctSpots{1,i}(:,4) <= ...
                assym/100), :);
        end
        
        if ~isempty(slctSpots{1,i})
            % check the z-offset
            zmin = 0;
            slctSpots{1,i} = slctSpots{1,i}((slctSpots{1,i}(:,8)>=zmin),:);
        end
    end

    % check the distance spot-edges
    if ~isempty(slctSpots{1,i})
        ok = select_spots_distfromedge(slctSpots{1,i}(:,1:2), minDedge, ...
            [lim(i)+1 lim(i+1); limY]);
        slctSpots{1,i} = slctSpots{1,i}(ok,:);
    end
    
    % check the distance spot-spot
    if ~isempty(slctSpots{1,i})
        ok = select_spots_distance(slctSpots{1,i}(:,1:2), minDspot);
        slctSpots{1,i} = slctSpots{1,i}(ok,:);
    end
    
    % check the number of spots
    if ~isempty(slctSpots{1,i})
        slctSpots{1,i} = sortrows(slctSpots{1,i},3);
        maxN = p.SF_maxN(i);
        if size(slctSpots{1,i},1) > maxN
            slctSpots{1,i} = slctSpots{1,i}(end-maxN+1:end,:);
        end
    end
end



