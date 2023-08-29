function coordtr = applyTrafo(tr, coord, q, h_fig)
% Apply spatial transformation(s) to coordinates and return transformed
% coordinates.
%
% tr: transformation
% coord: {1-by-Chan}[N-by-2] coordinates to transform
% q: structure containing fields:
%  q.res_x: video pixel width
%  q.res_y: video pixel height
%  q.nChan: nb of channels
%  q.spotDmin: minimum inter-spot distance
%  q.edgeDmin: minimum distance between spots and image edges
% h_fig: handle to main figure
% coordtr: transformed coordinates

% Last update: 10th of February 2014 by Mélodie C.A.S Hadzic

% default
coordtr = [];

res_x = q.res_x;
res_y = q.res_y;
nChan = q.nChan;
spotDmin = q.spotDmin;
edgeDmin = q.edgeDmin;
nMov = numel(res_x);
multichanvid = nMov==1;

[coord_tr_i,ok] = transformPoints(tr,coord,nChan,h_fig);
if ~ok
    return
end

coordTrsf_i = cell(1,nChan);

for i = 1:nChan
    if all(cellfun('isempty',coord_tr_i{i}))
        updateActPan(['Unconsistent number of channel.'...
            '\n\nPlease check the number of channels in the reference',...
            ' image used in the creation of the transformation file.'],...
            h_fig,'error');
        return
    end
    for j = 1:nChan
        if ~isempty(coord_tr_i{i}{j})
            coordTrsf_i{i} = ...
                cat(1,coordTrsf_i{i},coord_tr_i{i}{j}(:,[1,2]));
        end
    end
end

coordtr = [];
for i = 1:nChan
    coordtr = cat(2,coordtr,coordTrsf_i{i});
end

if multichanvid
    lim = [0 (1:(nChan-1))*round(res_x/nChan) res_x];
end

ok = exclude_doublecoord(1,coordtr);
coordtr = coordtr(ok',:);
if ~isempty(coordtr)
    for i = 1:nChan
        if ~isempty(coordtr)
            if multichanvid
                ok = select_spots_distfromedge(coordtr(:,2*i-1:2*i), ...
                    edgeDmin(i), [lim(i) lim(i+1);0 res_y(1)]);
            else
                ok = select_spots_distfromedge(coordtr(:,2*i-1:2*i), ...
                    edgeDmin(i), [0 res_x(i);0 res_y(i)]);
            end
            coordtr = coordtr(ok,:);
        end
    end
    for i = 1:nChan
        if ~isempty(coordtr)
            ok = select_spots_distance(coordtr(:,2*i-1:2*i), ...
                spotDmin(i));
            coordtr = coordtr(ok,:);
        end
    end
end

if isempty(coordtr)
    str_spotDmin= [];
    str_edgeDmin= [];
    for c = 1:nChan
        if nChan>1 && c==nChan
            str_spotDmin = cat(2,str_spotDmin,sprintf(' and %i (chan %i)',...
                spotDmin(c),c));
            str_edgeDmin = cat(2,str_edgeDmin,sprintf(' and %i (chan %i)',...
                edgeDmin(c),c));
        elseif nChan>1 && c==1
            str_spotDmin = cat(2,str_spotDmin,sprintf('%i (chan %i)',...
                spotDmin(c),c));
            str_edgeDmin = cat(2,str_edgeDmin,sprintf('%i (chan %i)',...
                edgeDmin(c),c));
        else
            str_spotDmin = cat(2,str_spotDmin,sprintf(', %i (chan %i)',...
                spotDmin(c),c));
            str_edgeDmin = cat(2,str_edgeDmin,sprintf(', %i (chan %i)',...
                edgeDmin(c),c));
        end
    end
    updateActPan(cat(2,'No coordinates is left after transformation. ',...
        'This happens because:\n\n',...
        '-  options are ill-defined: see Coordinates transformation >> ',...
        'Options... >> Video dimensions.\n\n',...
        '-  coordinates are less than or exactly ',str_spotDmin,' pixel ',...
        'appart: see Spotfinder >> Exclusion rules\n\n',...
        '-  coordinates are less than or exactly ',str_edgeDmin,...
        ' pixel away from image edges: see Spotfinder >> Exclusion rules'),...
        h_fig,'error');
    return
end


