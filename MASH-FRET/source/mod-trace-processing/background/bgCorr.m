function p = bgCorr(mol, p, h_fig)
proj = p.curr_proj;
nC = p.proj{proj}.nb_channel;

isBgCorr = ~isempty(p.proj{proj}.intensities_bgCorr) && ...
    ~all(sum(sum(isnan(p.proj{proj}.intensities_bgCorr(:, ...
    ((mol-1)*nC+1):mol*nC,:)),2),3));

if isBgCorr
    return
end
isCoord = p.proj{proj}.is_coord;
isMov = p.proj{proj}.is_movie;

I = p.proj{proj}.intensities(:,((mol-1)*nC+1):mol*nC,:);
I_bgCorr = I;

if isCoord && isMov
    viddim = p.proj{proj}.movie_dim;
    viddat = p.proj{proj}.movie_dat;
    vidfile = p.proj{proj}.movie_file;
    multichanvid = numel(viddim)==1;
    if multichanvid
        vidfile_mv = vidfile{1};
        viddat_mv = viddat{1};
        res_x = viddim{1}(1);
        res_y = viddim{1}(2);
        split = round(res_x/nC)*(1:nC-1);
        lim_x = [0 split res_x];
        limy_c = [0 res_y];
    end
else
    for c = 1:size(I,2)
        for l = 1:size(I,3)
            p.proj{proj}.TP.prm{mol}{3}{2}(l,c) = 1; % method manual
        end
    end
end

for c = 1:size(I,2)
    for l = 1:size(I,3)
        method = p.proj{proj}.TP.prm{mol}{3}{2}(l,c);
        prm = p.proj{proj}.TP.prm{mol}{3}{3}{l,c}(method,:);
        apply = p.proj{proj}.TP.prm{mol}{3}{1}(l,c);

        img = [];

        if isCoord && isMov
            if multichanvid
                limx_c = [lim_x(c),lim_x(c+1)];
                avimg = p.proj{proj}.aveImg{l+1};
            else
                avimg = p.proj{proj}.aveImg{c,l+1};
                res_x = viddim{c}(1);
                res_y = viddim{c}(2);
                limx_c = [0,res_x];
                limy_c = [0,res_y];
                vidfile_mv = vidfile{c};
                viddat_mv = viddat{c};
            end
            
            sub_w = prm(2);
            coord = floor(p.proj{proj}.coord(mol,(2*c-1):2*c))+0.5;
            lim_img_x = [coord(1)-sub_w/2 coord(1)+sub_w/2];
            lim_img_y = [coord(2)-sub_w/2 coord(2)+sub_w/2];

            if lim_img_x(1) <= limx_c(1)
                lim_img_x(1) = limx_c(1)+1;
                lim_img_x(2) = limx_c(1) + sub_w;

            elseif lim_img_x(2) >= limx_c(2)
                lim_img_x(2) = limx_c(2);
                lim_img_x(1) = limx_c(2)-sub_w+1;
            end
            if lim_img_y(1) <= limy_c(1)
                lim_img_y(1) = limy_c(1)+1;
                lim_img_y(2) = limy_c(1) + sub_w;

            elseif lim_img_y(2) >= limy_c(2)
                lim_img_y(2) = limy_c(2);
                lim_img_y(1) = limy_c(2)-sub_w+1;
            end
            lim_img_y = ceil(lim_img_y);
            lim_img_x = ceil(lim_img_x);
            img = avimg(lim_img_y(1):lim_img_y(2),...
                lim_img_x(1):lim_img_x(2));
        end

        nPix = p.proj{proj}.pix_intgr(2);
        bg = 0;

        switch method
            case 1 % Manual
                bg = prm(3); % BG intensity

            case 2 % 20 darkest value
                [bg o] = determine_bg(14, img, []);
                bg = nPix*bg;

            case 3 % Mean value
                [bg o] = determine_bg(11, img, prm(1));
                bg = nPix*bg;

            case 4 % Most frequent value
                [bg o] = determine_bg(12, img, [0 prm(1)]);
                bg = nPix*bg;

            case 5 % Histothresh 50% value
                [bg o] = determine_bg(13, img, [0 prm(1)]);
                bg = nPix*bg;

            case 6 % Dark trace
                sub_w = prm(2);
                aDim = p.proj{proj}.pix_intgr(1);
                autoDark = prm(6);
                fDat{1} = vidfile_mv;
                fDat{2}{1} = viddat_mv{1};
                if isFullLengthVideo(vidfile_mv,h_fig)
                    h = guidata(h_fig);
                    fDat{2}{2} = h.movie.movie;
                else
                    fDat{2}{2} = [];
                end
                fDat{3} = [res_y res_x];
                fDat{4} = viddat_mv{3};
                if autoDark
                    coord_dark = getDarkCoord(l,mol,c,p,sub_w);
                else
                    coord_dark = prm(4:5);
                    itgDim = p.proj{proj}.pix_intgr(1);
                    min_xy = itgDim/2;
                    max_y = res_y - itgDim/2;
                    max_x = res_x - itgDim/2;
                    coord_dark(coord_dark(:,1:2)<=min_xy)=min_xy+1;
                    coord_dark(coord_dark(:,1)>=max_x)=max_x-1;
                    coord_dark(coord_dark(:,2)>=max_y)=max_y-1;
                end
                p.proj{proj}.TP.prm{mol}{3}{3}{l,c}(6,4:5) = ...
                    coord_dark;
                [o,I_bg] = create_trace(coord_dark,aDim,nPix,fDat,...
                    false);
                I_bg = slideAve(I_bg(l:size(I,3):end,:), prm(1));
                bg = I_bg(1:size(I,1));

            case 7 % Median value
                [bg,o] = determine_bg(15, img, prm(1));
                bg = nPix*bg;
        end

        p.proj{proj}.TP.prm{mol}{3}{3}{l,c}(method,3) = mean(bg);
        if apply
            I_bgCorr(:,c,l) = I(:,c,l) - bg;
        end
    end
end

p.proj{proj}.intensities_bgCorr(:,((mol-1)*nC+1):mol*nC,:) = ...
    I_bgCorr;
p.proj{proj}.intensities_crossCorr(:,((mol-1)*nC+1):mol*nC,:) = NaN;



