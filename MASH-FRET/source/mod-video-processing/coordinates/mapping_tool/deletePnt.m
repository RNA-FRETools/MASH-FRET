function deletePnt(obj, evd, who, h_fig)

global pntCoord;
nChan = size(pntCoord,2);

if strcmp(who, 'last')
    maxN = 0;
    for i = 1:nChan
        if ~isempty(pntCoord{i})
            if max(pntCoord{i}(:,3)) > maxN
                lastChan = i;
                maxN = max(pntCoord{i}(:,3));
            end
        end
    end
    
    if maxN > 0
        pntCoord{lastChan} = pntCoord{lastChan}(1:(end-1), :);
    end
    
elseif strcmp(who, 'set')

    for i = 1:nChan
        if ~isempty(pntCoord{i})
            pntCoord{i} = pntCoord{i}(1:(end-1), :);
        end
    end
end

updatePnts(h_fig);
