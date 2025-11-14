function p = plotSubImg(mol, p, h_axes)
% returns dark coordinates if appropriate background correction method is
% selected
%
% Last update by MH, 29.4.2019: move molecule position recentering to
% separate function "pushbutton_refocus_Callback"

proj = p.curr_proj;
if ~(p.proj{proj}.is_coord && p.proj{proj}.is_movie)
    return
end
if ~(~isempty(h_axes) && all(ishandle(h_axes)))
    return
end

nChan = p.proj{proj}.nb_channel;
wl = p.proj{proj}.excitations;
viddim = p.proj{proj}.movie_dim;
lbl = p.proj{proj}.labels;
clr = p.proj{proj}.colours;
lcurr = p.proj{proj}.TP.fix{1}(1);
q.brght = p.proj{proj}.TP.fix{1}(3); % [-1:1]
q.ctrst = p.proj{proj}.TP.fix{1}(4); % [-1:1]
q.itgArea = p.proj{proj}.pix_intgr(1);
multichanvid = isscalar(viddim);

p_bg = p.proj{proj}.TP.curr{mol}{3};
if multichanvid
    img = p.proj{proj}.aveImg{lcurr+1};
    res_x = viddim{1}(1);
    res_y = viddim{1}(2);
    split = round(res_x/nChan)*(1:nChan-1);
    lim_x = [0 split res_x];
    q.lim.y = [0 res_y];
end
for c = 1:nChan
    if multichanvid
        q.lim.x = [lim_x(c) lim_x(c+1)];
    else
        img = p.proj{proj}.aveImg{c,lcurr+1};
        res_x = viddim{c}(1);
        res_y = viddim{c}(2);
        q.lim.y = [0 res_y];
        q.lim.x = [0,res_x];
    end
    q.img = img(:,q.lim.x(1)+1:q.lim.x(2));
    meth = p_bg{2}(lcurr,c);
    q.dimImg = p_bg{3}{lcurr,c}(meth,2);
    q.dimImg(q.dimImg<=0) = 20;
    coord = p.proj{proj}.coord(:,2*c-1:2*c);

    plotChanCoord(h_axes(c),mol,coord, q, lbl{c}, wl(lcurr), ...
        clr{1}{lcurr,c});
    
    if p_bg{2}(lcurr,c)~=6 % dark trace
        continue
    end
    
    set(h_axes(c), 'NextPlot', 'add');
    if p_bg{3}{lcurr,c}(6,6) % auto dark
        coord_dark = getDarkCoord(lcurr,mol,c,p.proj{proj},q.dimImg);
        p.proj{proj}.TP.curr{mol}{3}{3}{lcurr,c}(6,4:5) = coord_dark;
    else
        coord_dark = p_bg{3}{lcurr,c}(6,4:5)+0.5;
    end
    crdCenter = coord_dark - 0.5;
    coord_dark = crdCenter - q.itgArea/2;
    rectangle('Parent',h_axes(c),'Position',...
        [coord_dark,q.itgArea,q.itgArea],'EdgeColor',[0,1,0]);
    plot(h_axes(c),crdCenter(1),crdCenter(2),'+g','MarkerSize',10);
    set(h_axes(c), 'NextPlot', 'replacechildren');
end


function plotChanCoord(h_axes, mol, coord, q, lbl, exc, clr)

% defaults
minMap = 0;
maxMap = 1;
n_map = 50;
clr_curr = [1,0,0];
clr_others = [1,1,0];

% retrieve drawing parameters
lim_x = q.lim.x;
lim_y = q.lim.y;
dimImg = q.dimImg;
brght = q.brght; % [-1:1]
ctrst = q.ctrst; % [-1:1]
img = q.img;
aDim = q.itgArea;

% adjust colormap according to brigthness and contrast values
x_map = linspace(minMap, maxMap, n_map);
a = 1+(ctrst)^3;
b = brght + (1-a)*0.5;
r = (a*x_map + b)';
r(r < 0) = 0;
r(r > 1) = 1;
colormap(h_axes, [r r r]);

% clip video frame and draw close up image
lim = getSubimgLim(coord(mol,:), dimImg, [lim_x;lim_y]);
lim_img_x = lim(1,:);
lim_img_y = lim(2,:);
imagesc([lim_x(1)+0.5 lim_x(2)-0.5], [lim_y(1)+0.5 lim_y(2)-0.5], ...
    img, 'Parent', h_axes);
set(h_axes, 'NextPlot', 'add');
colormap(h_axes, [r r r]);

% draw integration area of current molecule ...
crdCenter = ceil(coord) - 0.5; % center of the rectangle
coord = crdCenter - aDim/2;
rectangle('Parent',h_axes,'Position',[coord(mol,[1,2]),aDim,aDim],...
    'EdgeColor',clr_curr);
plot(h_axes,crdCenter(mol,1),crdCenter(mol,2),'Marker','+',...
    'MarkerEdgeColor',clr_curr,'MarkerSize',10);

% ... and of others
for m = 1:size(coord,1)
    if m ~= mol && ...
            crdCenter(m,1)>lim_img_x(1) && crdCenter(m,1)<lim_img_x(2) ...
            && crdCenter(m,2)>lim_img_y(1) && crdCenter(m,2)<lim_img_y(2)
        rectangle('Parent',h_axes,'Position',[coord(m,[1,2]),aDim, ...
            aDim],'EdgeColor',clr_others);
        plot(h_axes,crdCenter(m,1),crdCenter(m,2),'Marker','+',...
            'MarkerEdgeColor',clr_others,'MarkerSize',10);
    end
end

% set axis
axis(h_axes, 'image');
xlim(h_axes, lim_img_x);
ylim(h_axes, lim_img_y);

% add text with channel label and wavelength
text(h_axes, mean(lim_img_x), lim_img_y(1), sprintf('%s %inm',lbl,exc), ...
    'horizontalalignment', 'center', 'verticalalignment','top', 'color', ...
    clr, 'backgroundcolor', 'none');

% finialize axes
set(h_axes, 'NextPlot', 'replacechildren');


