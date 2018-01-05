function uitable_molCoord_CellEditCallback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    slct = evd.Indices;
    refocus = p.proj{proj}.fix{1}(5);
    if slct(2) > 1
        if ~refocus
            colNames = get(obj, 'ColumnName');
            val = str2num(evd.EditData);
            nC = p.proj{proj}.nb_channel;
            itg_dim = p.proj{proj}.pix_intgr(1);
            res_x = p.proj{proj}.movie_dim(1);
            res_y = p.proj{proj}.movie_dim(2);
            sub_w = round(res_x/nC);
            lim_x = [0 (1:nC-1)*sub_w res_x];
            lim_y = [0 res_y];
            dat = get(obj, 'Data');
            if ~mod(slct(2),2)
                lim = lim_x;
                chan = slct(2)/2;
            else
                lim = lim_y;
                chan = 1;
            end
            if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                    (ceil(val) - floor(itg_dim/2)) > lim(chan) && ...
                    (ceil(val) + floor(itg_dim/2)) < lim(chan+1))
                updateActPan([colNames{slct(2)} ' coordinates must be ' ...
                    '> ' num2str(lim(chan)+floor(itg_dim/2)) ' and < ' ...
                    num2str(lim(chan+1)-floor(itg_dim/2))], ...
                    h.figure_MASH, 'error');
                dat{slct(1),slct(2)} = evd.PreviousData;
                set(obj, 'Data', dat);

            elseif ~isequal(evd.PreviousData,dat{slct(1),slct(2)})
                p.proj{proj}.coord(mol,slct(2)-1) = dat{1,slct(2)};
                chan = ceil((slct(2)-1)/2);
                coord = p.proj{proj}.coord(mol,(2*chan-1):2*chan);
                aDim = p.proj{proj}.pix_intgr(1);
                nPix = p.proj{proj}.pix_intgr(2);
                mov_file = p.proj{proj}.movie_file;
                fCurs = p.proj{proj}.movie_dat{1};
                res_x = p.proj{proj}.movie_dat{2}(1);
                res_y = p.proj{proj}.movie_dat{2}(2);
                nFrames = p.proj{proj}.movie_dat{3};

                [coord trace] = create_trace(coord, aDim, nPix, ...
                    {mov_file, fCurs, [res_y res_x], nFrames});

                nFrames = size(p.proj{proj}.intensities,1);
                nExc = size(p.proj{proj}.intensities,3);
                I = zeros(nFrames, 1, nExc);
                for i = 1:nExc
                    I(:,1,i) = trace(i:nExc:nFrames*nExc,:);
                end
                i_mol = (mol-1)*nC+chan;
                p.proj{proj}.intensities(1:nFrames,i_mol,1:nExc) = I;
                p.proj{proj}.prm{mol} = {};
            end
        else
            updateActPan(['Impossible to modify coordinates in ' ...
                '"refocus" mode'], h.figure_MASH, 'error');
            dat = get(obj, 'Data');
            dat{slct(1),slct(2)} = evd.PreviousData;
            set(obj, 'Data', dat);
            return;
        end
    else
        mol = p.curr_mol(proj);
        p.proj{proj}.coord_incl(mol) = evd.NewData;
    end
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end