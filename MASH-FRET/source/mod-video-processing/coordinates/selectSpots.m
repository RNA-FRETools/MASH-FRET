function spots = selectSpots(spots, w, h, prm)
% spots = selectSpots(spots, w, h, prm)
%
% Select coordinates corresponding to the selection criteria (minimum intensity, spot size, spot assymetry, inter-spot distance, distance from image edge, maximum number of spots)
%
% spots: {1-by-nChan} cell array containing spots parameters (x and y coordinates, intensity, spot width and height, assymetry) for each channel
% w: image dimension in the x-direction (in pixels)
% h: image dimension in the y-direction (in pixels)
% prm: processing parameters

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

% collect processing parameters
gaussFit = prm.gen_crd{2}{1}(2);
slctprm = prm.gen_crd{2}{3};

% get channel limits
nChan = size(slctprm,1);
sub_w = floor(w/nChan);
limX = [0 (1:nChan)*sub_w w];
limY = [1 h];

for i = 1:nChan
    minDspot = slctprm(i,6);
    minDedge = slctprm(i,7);

    % check the intensity
    if ~isempty(spots{i})
        minI = slctprm(i,2);
        spots{i} = spots{i}((spots{i}(:,3)>=minI),:);
    end

    if ~isempty(spots{i}) && size(spots{i},2)>3 && gaussFit
        % check the spot WHM
        minw = slctprm(i,3);
        maxw = slctprm(i,4);
        spots{i} = spots{i}((spots{i}(:,5)>minw & spots{i}(:,5)<maxw),:);
        if ~isempty(spots{i})
            spots{i} = spots{i}((spots{i}(:,6)>minw & spots{i}(:,6)<maxw),:);
        end
        
        if ~isempty(spots{i})
            % check the spot assymetry
            assym = slctprm(i,5);
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
        maxN = slctprm(i,1);
        if size(spots{i},1) > maxN
            spots{i} = spots{i}(end-maxN+1:end,:);
        end
    end
end



