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

if ~isempty(tr{1,2}.forward_fcn)
    for i = 1:nChan
        if ~isempty(coord_i{i})
            coordTrsf_ij = [];
            coordTrsf_ij(:,2*i-1:2*i) = coord_i{i};
            for j = 1:size(tr,1)
                chan_input = tr{j,1}(1);
                if chan_input == i
                    chan_output = tr{j,1}(2);
                    tr_ij = tr{j,2};
                    coordTrsf_ij(:,2*chan_output-1:2*chan_output) = ...
                        tformfwd(tr_ij, coord_i{i});
                end
            end
            coordTrsf = [coordTrsf; coordTrsf_ij];
        end
    end
    
elseif ~isempty(tr{1,2}.inverse_fcn)
    for i = 1:nChan
        if ~isempty(coord_i{i})
            coordTrsf_ij = [];
            coordTrsf_ij(:,2*i-1:2*i) = coord_i{i};
            for j = 1:size(tr,1)
                chan_output = tr{j,1}(2);
                if chan_output == i
                    chan_input = tr{j,1}(1);
                    tr_ij = tr{j,2};
                    coordTrsf_ij(:,2*chan_input-1:2*chan_input) = ...
                        tforminv(tr_ij, coord_i{i});
                end
            end
            coordTrsf = [coordTrsf; coordTrsf_ij];
        end
    end
    
else
    updateActPan(['Empty transform matrices.\nPlease check the import ' ...
        'options.'], h_fig, 'error');
    return;
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
    updateActPan(['All coordinates were excluded'...
        '\nPlease check the exclusion rules.'], h_fig, 'error');
    return;
end


