function spots = selectSpots(spots, w, h, p)
% spots = selectSpots(spots, w, h, p)
%
% Select coordinates corresponding to the selection criteria (minimum intensity, spot size, spot assymetry, inter-spot distance, distance from image edge, maximum number of spots)
%
% spots: {1-by-nChan} cell array containing spots parameters (x and y coordinates, intensity, spot width and height, assymetry) for each channel
% w: image dimension in the x-direction (in pixels)
% h: image dimension in the y-direction (in pixels)
% h_fig: handle to main figure

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

% collect processing parameters
gaussFit = p.SF_gaussFit;
nChan = p.nChan;

% get channel limits
sub_w = floor(w/p.nChan);
limX = [0 (1:nChan)*sub_w w];
limY = [1 h];

for i = 1:nChan
    minDspot = p.SF_minDspot(i);
    minDedge = p.SF_minDedge(i);

    % check the intensity
    if ~isempty(spots{i})
        minI = p.SF_minI(i);
        spots{i} = spots{i}((spots{i}(:,3)>=minI),:);
    end

    if ~isempty(spots{i}) && size(spots{i},2)>3 && gaussFit
        % check the spot WHM
        minw = p.SF_minHWHM(i);
        maxw = p.SF_maxHWHM(i);
        spots{i} = spots{i}((spots{i}(:,5)>minw & spots{i}(:,5)<maxw),:);
        if ~isempty(spots{i})
            spots{i} = spots{i}((spots{i}(:,6)>minw & spots{i}(:,6)<maxw),:);
        end
        
        if ~isempty(spots{i})
            % check the spot assymetry
            assym = p.SF_maxAssy(i);
            spots{i} = spots{i}((spots{i}(:,4)<=(assym/100)),:);
        end
        
        if ~isempty(spots{i})
            % check the z-offset
            zmin = 0;
            spots{i} = spots{i}((spots{i}(:,8)>=zmin),:);
        end
    end

    % check the distance spot-edges
    if ~isempty(spots{i})
        ok = select_spots_distfromedge(spots{i}(:,1:2), minDedge, ...
            [limX(i)+1 limX(i+1); limY]);
        spots{i} = spots{i}(ok,:);
    end
    
    % check the distance spot-spot
    if ~isempty(spots{i})
        ok = select_spots_distance(spots{i}(:,1:2), minDspot);
        spots{i} = spots{i}(ok,:);
    end
    
    % check the number of spots
    if ~isempty(spots{i})
        spots{i} = sortrows(spots{i},3);
        maxN = p.SF_maxN(i);
        if size(spots{i},1) > maxN
            spots{i} = spots{i}(end-maxN+1:end,:);
        end
    end
end



