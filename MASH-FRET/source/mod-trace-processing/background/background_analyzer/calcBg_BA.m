function bg_m = calcBg_BA(m, p1, subdim, h_fig)

g = guidata(h_fig);
h = guidata(g.figure_MASH);
p = h.param;
proj = p.curr_proj;
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;
nPix = p.proj{proj}.pix_intgr(2);
viddim = p.proj{proj}.movie_dim;
multichanvid = numel(viddim)==1;

bg_m = zeros(nExc,nChan);

if multichanvid
    res_x = viddim{1}(1);
    res_y = viddim{1}(2);
    split = round(res_x/nChan)*(1:nChan-1);
    lim_x_c = [0 split res_x];
    lim_y = [0 res_y];
end

for l = 1:nExc
    for c = 1:nChan
        if multichanvid
            lim_x = lim_x_c([c,c+1]);
        else
            res_x = viddim{c}(1);
            res_y = viddim{c}(2);
            lim_x = [0,res_x];
            lim_y = [0,res_y];
        end
        sub_w = subdim(l,c);
        coord = floor(p.proj{proj}.coord(m,(2*c-1):2*c))+0.5;
        lim_img_x = [coord(1)-sub_w/2 coord(1)+sub_w/2];
        lim_img_y = [coord(2)-sub_w/2 coord(2)+sub_w/2];

        if lim_img_x(1) <= lim_x(1)
            lim_img_x(1) = lim_x(1)+1;
            lim_img_x(2) = lim_x(1) + sub_w;

        elseif lim_img_x(2) >= lim_x(2)
            lim_img_x(2) = lim_x(2);
            lim_img_x(1) = lim_x(2)-sub_w+1;
        end
        if lim_img_y(1) <= lim_y(1)
            lim_img_y(1) = lim_y(1)+1;
            lim_img_y(2) = lim_y(1) + sub_w;

        elseif lim_img_y(2) >= lim_y(2)
            lim_img_y(2) = lim_y(2);
            lim_img_y(1) = lim_y(2)-sub_w+1;
        end
        lim_img_y = ceil(lim_img_y);
        lim_img_x = ceil(lim_img_x);
        img = p.proj{proj}.aveImg{l}(lim_img_y(1):lim_img_y(2), ...
            lim_img_x(1):lim_img_x(2));
        
        switch g.param{1}{m}(l,c,1)
            case 1 % Manual
                bg = g.param{1}{m}(l,c,7);

            case 2 % 20 darkest value
                [bg o] = determine_bg(14, img, []);
                bg = nPix*bg;

            case 3 % Mean value
                [bg o] = determine_bg(11, img, p1);
                bg = nPix*bg;

            case 4 % Most frequent value
                [bg o] = determine_bg(12, img, [0 p1(l,c)]);
                bg = nPix*bg;

            case 5 % Histothresh
                [bg o] = determine_bg(13, img, [0 p1(l,c)]);
                bg = nPix*bg;

            case 6 % Dark trace
                aDim = p.proj{proj}.pix_intgr(1);
                autoDark = g.param{1}{m}(l,c,6);
                
                if multichanvid
                    mov = 1;
                else
                    mov = c;
                end
                fDat{1} = p.proj{proj}.movie_file{mov};
                fDat{2}{1} = p.proj{proj}.movie_dat{mov}{1};
                fDat{2}{2} = [];
                fDat{3} = [res_y res_x];
                fDat{4} = p.proj{proj}.movie_dat{mov}{end};
                if autoDark
                    coord_dark = getDarkCoord(l, m, c, p, sub_w);
                else
                    coord_dark = [g.param{1}{m}(l,c,4) ...
                        g.param{1}{m}(l,c,5)];
                    res_y = p.proj{proj}.movie_dim{mov}(2);
                    res_x = p.proj{proj}.movie_dim{mov}(1);
                    min_xy = aDim/2;
                    max_y = res_y - aDim/2;
                    max_x = res_x - aDim/2;
                    coord_dark(coord_dark(:,1:2)<=min_xy)=min_xy+1;
                    coord_dark(coord_dark(:,1)>=max_x)=max_x-1;
                    coord_dark(coord_dark(:,2)>=max_y)=max_y-1;
                end
                g.param{1}{m}(l,c,4) = coord_dark(1);
                g.param{1}{m}(l,c,5) = coord_dark(2);
                [o,I_bg] = create_trace(coord_dark, aDim, nPix, fDat, ...
                    h.mute_actions);
                bg = slideAve(I_bg(l:nExc:end,:), p1(l,c));
                
            case 7 % Median value
                [bg,o] = determine_bg(15, img, p1(l,c));
                bg = nPix*bg;
        end

        bg_m(l,c) = mean(bg);
    end
end
guidata(h_fig, g);

