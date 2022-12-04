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
exc = p.proj{proj}.TP.fix{1}(1);
res_x = p.proj{proj}.movie_dim(1);
res_y = p.proj{proj}.movie_dim(2);
split = round(res_x/nChan)*(1:nChan-1);
img = p.proj{proj}.aveImg{exc+1};
lim_x = [0 split res_x];
q.lim.y = [0 res_y];
q.brght = p.proj{proj}.TP.fix{1}(3); % [-1:1]
q.ctrst = p.proj{proj}.TP.fix{1}(4); % [-1:1]
q.itgArea = p.proj{proj}.pix_intgr(1);

p_bg = p.proj{proj}.TP.curr{mol}{3};

for c = 1:nChan
    q.lim.x = [lim_x(c) lim_x(c+1)];
    q.img = img(:,q.lim.x(1)+1:q.lim.x(2));
    meth = p_bg{2}(exc,c);
    q.dimImg = p_bg{3}{exc,c}(meth,2);
    q.dimImg(q.dimImg<=0) = 20;
    coord = p.proj{proj}.coord(:,2*c-1:2*c);

    plotChanCoord(h_axes(c),mol,coord, q);
    
    if p_bg{2}(exc,c)~=6 % dark trace
        continue
    end
    
    set(h_axes(c), 'NextPlot', 'add');
    if p_bg{3}{exc,c}(6,6) % auto dark
        coord_dark = getDarkCoord(exc,mol,c,p,q.dimImg);
        p.proj{proj}.TP.curr{mol}{3}{3}{exc,c}(6,4:5) = coord_dark;
    else
        coord_dark = p_bg{3}{exc,c}(6,4:5)+0.5;
    end
    crdCenter = coord_dark - 0.5;
    coord_dark = crdCenter - q.itgArea/2;
    rectangle('Parent',h_axes(c),'Position',...
        [coord_dark,q.itgArea,q.itgArea],'EdgeColor',[0,1,0]);
    plot(h_axes(c),crdCenter(1),crdCenter(2),'+g','MarkerSize',10);
    set(h_axes(c), 'NextPlot', 'replacechildren');
end


function plotChanCoord(h_axes, mol, coord, q)
lim_x = q.lim.x;
lim_y = q.lim.y;
dimImg = q.dimImg;
brght = q.brght; % [-1:1]
ctrst = q.ctrst; % [-1:1]
img = q.img;
aDim = q.itgArea;

minMap = 0;
maxMap = 1;
n_map = 50;

x_map = linspace(minMap, maxMap, n_map);
a = 1+(ctrst)^3;
b = brght + (1-a)*0.5;
r = (a*x_map + b)';
r(r < 0) = 0;
r(r > 1) = 1;
colormap(h_axes, [r r r]);

lim = getSubimgLim(coord(mol,:), dimImg, [lim_x;lim_y]);
lim_img_x = lim(1,:);
lim_img_y = lim(2,:);

imagesc([lim_x(1)+0.5 lim_x(2)-0.5], [lim_y(1)+0.5 lim_y(2)-0.5], ...
    img, 'Parent', h_axes);
set(h_axes, 'NextPlot', 'add');

crdCenter = ceil(coord) - 0.5; % center of the rectangle
coord = crdCenter - aDim/2;

rectangle('Parent',h_axes,'Position',[coord(mol,[1,2]),aDim,aDim],...
    'EdgeColor',[1,0,0]);
plot(h_axes,crdCenter(mol,1),crdCenter(mol,2),'+r','MarkerSize',10);
for m = 1:size(coord,1)
    if m ~= mol && ...
            crdCenter(m,1)>lim_img_x(1) && crdCenter(m,1)<lim_img_x(2) ...
            && crdCenter(m,2)>lim_img_y(1) && crdCenter(m,2)<lim_img_y(2)
        rectangle('Parent',h_axes,'Position',[coord(m,[1,2]),aDim, ...
            aDim],'EdgeColor',[1,1,0]);
        plot(h_axes,crdCenter(m,1),crdCenter(m,2),'+y','MarkerSize',10);
    end
end

set(h_axes, 'NextPlot', 'replacechildren');
axis(h_axes, 'image');
xlim(h_axes, lim_img_x);
ylim(h_axes, lim_img_y);


