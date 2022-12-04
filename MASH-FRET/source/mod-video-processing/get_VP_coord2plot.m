function coord = get_VP_coord2plot(prm,nChan,chan)
% coord = get_VP_coord2plot(prm,nChan,chan)
%
% Determines and returns coordinates to plot on video image
%
% prm: currently apllied project's VP parameters
% nChan: number of channels
% chan: channel to plot on for single-channel videos, or 0 for multi-channel video
% coord: coordinates to plot

% collect processing parameters
toplot = prm.plot{1}(2);
coord2tr = prm.res_crd{1};
coordref = prm.res_crd{3};
coordsm = prm.res_crd{4};

% determine video type
multichanvid = chan==0;

% get spots coordinates
coord = [];
switch toplot
    case 1 % spotfinder
        if multichanvid
            for c = 1:nChan
                if numel(coord2tr)>=c
                    coord = cat(1,coord,coord2tr{c});
                end
            end
        else
            coord = coord2tr{chan};
        end

    case 2 % reference coordinates
        if multichanvid
            for c = 1:nChan
                if size(coordref,2)>=(2*c)
                    coord = cat(1, coord, coordref(:,(2*c-1):(2*c)));
                end
            end
        elseif size(coordref,2)>=(2*chan)
            coord = coordref(:,(2*chan-1):(2*chan));
        end
        
    case 3 % coordinates to tranform
        if multichanvid
            for c = 1:nChan
                if numel(coord2tr)>=c
                    coord = cat(1,coord,coord2tr{c});
                end
            end
        else
            coord = coord2tr{chan};
        end

    case 4 % transformed coordinates
        if multichanvid
            for c = 1:nChan
                if size(coordsm,2)>=(2*c)
                    coord = cat(1, coord, coordsm(:,(2*c-1):(2*c)));
                end
            end
        elseif size(coordsm,2)>=(2*chan)
            coord = coordsm(:,(2*chan-1):(2*chan));
        end
        
    case 5 % coordinates for intensity integration
        if multichanvid
            for c = 1:nChan
                if size(coordsm,2)>=(2*c)
                    coord = cat(1, coord, coordsm(:,(2*c-1):(2*c)));
                end
            end
        elseif size(coordsm,2)>=(2*chan)
            coord = coordsm(:,(2*chan-1):(2*chan));
        end
end
