function [bg,coord_dark] = calcbgint(mol,l,c,dynbg,meth,prm,proj,h_fig)

coord_dark = [];

nC = proj.nb_channel;
nExc = proj.nb_excitations;
isCoord = proj.is_coord;
isMov = proj.is_movie;

I = proj.intensities(:,((mol-1)*nC+1):mol*nC,:);
img = [];

if isCoord && isMov
    viddim = proj.movie_dim;
    viddat = proj.movie_dat;
    vidfile = proj.movie_file;
    multichanvid = isscalar(viddim);
    if multichanvid
        vidfile_mv = vidfile{1};
        viddat_mv = viddat{1};
        res_x = viddim{1}(1);
        res_y = viddim{1}(2);
        split = round(res_x/nC)*(1:nC-1);
        lim_x = [0 split res_x];
        limy_c = [0 res_y];
        limx_c = [lim_x(c),lim_x(c+1)];
        avimg = proj.aveImg{l+1};
    else
        vidfile_mv = vidfile{c};
        viddat_mv = viddat{c};
        res_x = viddim{c}(1);
        res_y = viddim{c}(2);
        limx_c = [0,res_x];
        limy_c = [0,res_y];
        avimg = proj.aveImg{c,l+1};
    end

    % determines sub-image pixel limits
    sub_w = prm(2);
    coord = floor(proj.coord(mol,(2*c-1):2*c))+0.5;
    lim_img_x = [coord(1)-sub_w/2+1 coord(1)+sub_w/2];
    lim_img_y = [coord(2)-sub_w/2+1 coord(2)+sub_w/2];
    if lim_img_x(1) <= (limx_c(1)+1)
        lim_img_x(1) = limx_c(1)+1;
        lim_img_x(2) = limx_c(1) + sub_w;

    elseif lim_img_x(2) >= limx_c(2)
        lim_img_x(2) = limx_c(2);
        lim_img_x(1) = limx_c(2)-sub_w+1;
    end
    if lim_img_y(1) <= (limy_c(1)+1)
        lim_img_y(1) = limy_c(1)+1;
        lim_img_y(2) = limy_c(1) + sub_w;

    elseif lim_img_y(2) >= limy_c(2)
        lim_img_y(2) = limy_c(2);
        lim_img_y(1) = limy_c(2)-sub_w+1;
    end
    lim_img_y = ceil(lim_img_y);
    lim_img_x = ceil(lim_img_x);
    yrange = lim_img_y(1):lim_img_y(2);
    xrange = lim_img_x(1):lim_img_x(2);

    if ~dynbg % average sub-image
        img = avimg(yrange,xrange);

    else % sub-video

        % collect video parameters
        fDat{1} = vidfile_mv;
        fDat{2}{1} = viddat_mv{1};
        if isFullLengthVideo(vidfile_mv,h_fig)
            h = guidata(h_fig);
            fDat{2}{2} = h.movie.movie;
        else
            fDat{2}{2} = [];
        end
        fDat{3} = [res_x res_y];
        fDat{4} = viddat_mv{3};

        if meth~=6
            % determines coordinates of all pixels in the sub-area
            [X,Y] = meshgrid(xrange,yrange);
            pixCoord = ...
                [reshape(X,numel(X),1),reshape(Y,numel(Y),1)];
            [Xid,Yid] = meshgrid(1:numel(xrange),1:numel(yrange));
            pixId = [reshape(Xid,numel(Xid),1),...
                reshape(Yid,numel(Yid),1)];

            % calculates trajectories for all pixels in the sub-area
            [~,traj] = create_trace(pixCoord,1,1,fDat,true);
            traj = traj(l:nExc:end,:);
            traj = traj(1:size(I,1),:);

            % reshape trajectories into a sub-video
            nCoord = size(pixCoord,1);
            img = zeros(numel(yrange),numel(xrange),size(I,1));
            for n = 1:nCoord
                img(pixId(n,2),pixId(n,1),:) = ...
                    permute(traj(:,n),[3,2,1]);
            end
        end
    end
end

nPix = proj.pix_intgr(2);
nsubframes = size(img,3);
bg = zeros(1,nsubframes);

switch meth
    case 1 % Manual
        bg = prm(3); % BG intensity

    case 2 % N most probable
        for n = 1:nsubframes
            [bg(n),~] = determine_bg(14, img(:,:,n), []);
            bg(n) = nPix*bg(n);
        end

    case 3 % Mean value
        for n = 1:nsubframes
            [bg(n),~] = determine_bg(11, img(:,:,n), prm(1));
            bg(n) = nPix*bg(n);
        end

    case 4 % Most frequent value
        for n = 1:nsubframes
            [bg(n),~] = determine_bg(12, img(:,:,n), [0 prm(1)]);
            bg(n) = nPix*bg(n);
        end

    case 5 % Histothresh 50% value
        for n = 1:nsubframes
            [bg(n),~] = determine_bg(13, img(:,:,n), [0 prm(1)]);
            bg(n) = nPix*bg(n);
        end

    case 6 % Dark coordinates
        sub_w = prm(2);
        autoDark = prm(6);
        aDim = proj.pix_intgr(1);

        % determines dark coordinates
        if autoDark
            coord_dark = getDarkCoord(l,mol,c,proj,sub_w);
        else
            coord_dark = prm(4:5);
            coord_dark(coord_dark(:,1)<xrange(1)) = xrange(1)-0.5;
            coord_dark(coord_dark(:,2)<yrange(1)) = yrange(1)-0.5;
            coord_dark(coord_dark(:,1)>xrange(end)) = ...
                xrange(end)-0.5;
            coord_dark(coord_dark(:,2)>yrange(end)) = ...
                yrange(end)-0.5;
        end

        % integrates intensity at dark coordinates
        if dynbg
            [~,bg] = create_trace(coord_dark,aDim,nPix,fDat,true);
            bg = bg(l:nExc:end,:);
            bg = bg(1:size(I,1));
        else
            bg = summolpix(avimg,coord_dark,aDim);
        end

        % smooth dark trajectory
        if nsubframes>1
            bg = slideAve(bg,prm(1));
        end

    case 7 % Median value
        for n = 1:nsubframes
            [bg(n),~] = determine_bg(15, img(:,:,n), prm(1));
            bg(n) = nPix*bg(n);
        end
end
