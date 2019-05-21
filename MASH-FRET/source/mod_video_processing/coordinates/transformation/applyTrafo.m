function coordTrsf = applyTrafo(tr, coord, p, h_fig)
% Apply spatial transformation(s) to coordinates and return transformed
% coordinates.
% "tr" >>
% "coord" >>
% "p" >>
% "h_fig" >>
% "coordTrasf" >>

% Requires external function: updateActPan.
% Last update: 10th of February 2014 by Mélodie C.A.S Hadzic

coordTrsf = [];

res_x = p.res_x;
res_y = p.res_y;
nChan = p.nChan;
spotDmin = p.spotDmin;
edgeDmin = p.edgeDmin;

lim = [0 (1:(nChan-1))*round(res_x/nChan) res_x];
for i = 1:nChan
    coord_i{i} = coord((coord(:,1)>lim(i) & coord(:,1)<lim(i+1)) & ...
        (coord(:,2)>0 & coord(:,2)<res_y),:);
end

if isempty(coord_i)
    updateActPan(['Unconsistent coordinates.'...
        '\nPlease check the import options.'], h_fig, 'error');
    return;
end

[coord_tr_i,ok] = transformPoints(tr,coord_i,nChan,h_fig);
if ~ok
    return;
end

coordTrsf_i = cell(1,nChan);

for i = 1:nChan
    if all(cellfun('isempty',coord_tr_i{i}))
        updateActPan(['Unconsistent number of channel.'...
            '\n\nPlease check the number of channels in the reference',...
            ' image used in the creation of the transformation file.'],...
            h_fig,'error');
        return;
    end
    for j = 1:nChan
        if ~isempty(coord_tr_i{i}{j})
            coordTrsf_i{i} = cat(1,coordTrsf_i{i},coord_tr_i{i}{j}(:,[1,2]));
        end
    end
end

coordTrsf = [];
for i = 1:nChan
    coordTrsf = cat(2,coordTrsf,coordTrsf_i{i});
end

ok = exclude_doublecoord(3, coordTrsf);
coordTrsf = coordTrsf(ok',:);
if ~isempty(coordTrsf)
    for i = 1:nChan
        if ~isempty(coordTrsf)
            ok = select_spots_distfromedge(coordTrsf(:,2*i-1:2*i), ...
                edgeDmin(i), [lim(i) lim(i+1);0 res_y]);
            coordTrsf = coordTrsf(ok,:);
        end
    end
    for i = 1:nChan
        if ~isempty(coordTrsf)
            ok = select_spots_distance(coordTrsf(:,2*i-1:2*i), ...
                spotDmin(i));
            coordTrsf = coordTrsf(ok,:);
        end
    end
end

if isempty(coordTrsf)
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
    return;
end


