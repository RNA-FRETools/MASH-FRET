function dark_coord = getDarkCoord(exc, mol, c, proj, dimImg)
% dark_coord = getDarkCoord(exc, mol, c, proj, dimImg)
%
% Determines the pixel position of the darkest intensity in the molecule's 
% average sub-image.
%
% exc: laser's chronological order (integer number between 1 and laser nb.)
% mol: molecule's index in sample
% c: video channel index
% proj: structure containing project's data and parameters
% dimImg: pixel dimensions of the square sub-image

% collect project's data
viddim = proj.movie_dim;
coord = proj.coord(mol,(2*c-1):2*c);
nChan = proj.nb_channel;
aDim = proj.pix_intgr(1);

% determine channel-specific pixel limits
multichanvid = numel(viddim)==1;
if multichanvid
    aveImg = proj.aveImg{exc+1};
    res_x = viddim{1}(1);
    res_y = viddim{1}(2);
    split = round(res_x/nChan)*(1:nChan-1);
    split_x = [0 split res_x];
    lim_x = [split_x(c) split_x(c+1)];
    lim_y = [0 res_y];
else
    aveImg = proj.aveImg{c,exc+1};
    res_x = viddim{c}(1);
    res_y = viddim{c}(2);
    lim_x = [0 res_x];
    lim_y = [0 res_y];
end

% determines sub-image pixel limits
lim = getSubimgLim(coord, dimImg, [lim_x;lim_y]);
lim_img_x = lim(1,:)+1;
lim_img_y = lim(2,:)+1;

% lists all possibly integratable pixel coordinates within the sub-image
pixX = ceil(lim_img_x(1):lim_img_x(2));
pixY = ceil(lim_img_y(1):lim_img_y(2));
[X,Y] = meshgrid(pixX,pixY);
pixCoord = [reshape(X,numel(X),1),reshape(Y,numel(Y),1)];
incl = pixCoord(:,2)>=(aDim/2) & pixCoord(:,2)<=(res_y-aDim/2) &...
    pixCoord(:,1)>=aDim & pixCoord(:,1)<=(res_x-aDim/2);
pixCoord = pixCoord(incl,:);

% identifies the darkest pixel intensity within the sub-image
pixSum = summolpix(aveImg,pixCoord,aDim);
[~,ind] = sort(pixSum);
% ind = ind(round(numel(ind)/2)); % median
ind = ind(1); % minimum
dark_coord = [pixCoord(ind,1),pixCoord(ind,2)]-0.5;

