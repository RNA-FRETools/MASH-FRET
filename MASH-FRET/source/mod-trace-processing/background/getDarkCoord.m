function dark_coord = getDarkCoord(exc, mol, c, p, dimImg)

proj = p.curr_proj;

viddim = p.proj{proj}.movie_dim;
coord = p.proj{proj}.coord(mol,(2*c-1):2*c);
nChan = p.proj{proj}.nb_channel;
aDim = p.proj{proj}.pix_intgr(1);
multichanvid = numel(viddim)==1;

if multichanvid
    aveImg = p.proj{proj}.aveImg{exc+1};
    res_x = viddim{1}(1);
    res_y = viddim{1}(2);
    split = round(res_x/nChan)*(1:nChan-1);
    split_x = [0 split res_x];
    lim_x = [split_x(c) split_x(c+1)];
    lim_y = [0 res_y];
else
    aveImg = p.proj{proj}.aveImg{c,exc+1};
    res_x = viddim{c}(1);
    res_y = viddim{c}(2);
    lim_x = [0 res_x];
    lim_y = [0 res_y];
end

lim = getSubimgLim(coord, dimImg, [lim_x;lim_y]);
lim_img_x = lim(1,:);
lim_img_y = lim(2,:);

lim_img_x(1) = lim_img_x(1) + 1;
range_x = ceil(lim_img_x(1):lim_img_x(2));
lim_img_y(1) = lim_img_y(1) + 1;
range_y = ceil(lim_img_y(1):lim_img_y(2));

dark_y = 0;
dark_x = 0;
[X,Y] = meshgrid(range_x,range_y);
coord_img = [reshape(X,1,numel(X));reshape(Y,1,numel(Y))];

while (dark_y < aDim/2 || dark_y > (res_y-aDim/2)|| dark_x < aDim || ...
        dark_x > (res_x-aDim/2))
    [o,ind] = sort(reshape(aveImg(range_y,range_x),1,numel(range_y)* ...
        numel(range_x)));
    ind = ind(round(numel(ind)/2));
    aveImg(coord_img(2,ind),coord_img(1,ind)) = Inf;

    dark_y = coord_img(2,ind) - 0.5;
    dark_x = coord_img(1,ind) - 0.5;
end

dark_coord = [dark_x dark_y];

