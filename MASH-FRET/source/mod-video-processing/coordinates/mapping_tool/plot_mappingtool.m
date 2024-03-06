function q = plot_mappingtool(q,img,x,y,z,h_fig)
% q = plot_mappingtool(q,img_c,x,y,z,h_fig)
%
% Plot average images and zoom rectangle in mapping tool.
%
% q: structure containing "Mapping tool" figure content
% img: {1-by-nChan} channel average images
% x: [1-by-nChan] position of horizontal slider (0<=x<=1)
% y: [1-by-nChan] position of vertical slider (0<=x<=1)
% z: zoom factor (>=1)
% h_fig: handle to main figure

% defaults
lw = 2;
clr = [1,0,0];

% delete existing rectangle
nChan = numel(img);

if isfield(q,'rect') 
    for c = 1:nChan
        if numel(q.rect)>=c && ishandle(q.rect(c))
            delete(q.rect(c));
        end
    end
end
    
% set limits of top axes and draw rectangle in bottom axes
for c = 1:nChan
    
    resx = size(img{c},2);
    resy = size(img{c},1);
    
    % draw image in bottom axes
    if isfield(q,'img') && numel(q.img)>=c && ishandle(q.img(c))
        imagesc(q.axes_bottom(c), img{c}, q.axes_bottom(c).CLim);
    else
        imagesc(q.axes_bottom(c), img{c});
    end
    axis(q.axes_bottom(c), 'image');
    
    % draw image in top axes
    if isfield(q,'img') && numel(q.img)>=c && ishandle(q.img(c))
        q.img(c) = imagesc(q.axes_top(c),0.5:resx-0.5, 0.5:resy-0.5, ...
            img{c}, q.axes_top(c).CLim);
    else
        q.img(c) = imagesc(q.axes_top(c),0.5:resx-0.5, 0.5:resy-0.5, ...
            img{c});
    end
    set(q.img(c), 'ButtonDownFcn', {@axes_map_ButtonDownFcn, h_fig, c});
    
    % calculate rectangle dimensions and position
    posax = getPixPos(q.axes_top(c));
    [wrect,hrect] = calcmaptoolrectdim(z,resx,posax(3),posax(4));
    xrect = (resx-wrect)*x(c);
    yrect = (1-y(c))*(resy-hrect);
    
    % rectify rectangle position
    xrect(xrect<0) = 0;
    xrect(xrect>(resx-wrect)) = resx-wrect;
    yrect(yrect<0) = 0;
    yrect(yrect>(resy-hrect)) = resy-hrect;
    
    % adjust slider positions accordingly
    x(c) = xrect/(resx-wrect);
    if isnan(x(c))|| isinf(x(c))
        x(c) = 0;
    end
    y(c) = 1-yrect/(resy-hrect);
    if isnan(y(c))|| isinf(y(c))
        y(c) = 0;
    end
    q.slider_x(c).Value = x(c);
    q.slider_y(c).Value = y(c);

    % plot rectangle in bottom axes
    q.rect(c) = rectangle('Parent', q.axes_bottom(c), 'Position', ...
        [xrect,yrect,wrect,hrect], 'LineWidth', lw, 'EdgeColor', clr);
    
    % set top axes limits as defined by rectangle
    xlim(q.axes_top(c), [xrect xrect+wrect]);
    ylim(q.axes_top(c), [yrect yrect+hrect]);
end
