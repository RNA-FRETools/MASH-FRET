function slider_zoom_Callback(obj,evd,h_fig)

h = guidata(h_fig);
q = h.map;

fact = get(obj,'Value');

% update zoom factor text
q.text_zoom.String = ['Zoom: ',num2str(round(fact*100)),'%'];

nChan = numel(q.axes_bottom);
for c = 1:nChan
    img_c = get(q.axes_bottom(c), 'UserData');
    [resy,resx] = size(img_c);
    
    % calculates smallest slider step
    posax = getPixPos(q.axes_top(c));
    [wrect,hrect] = calcmaptoolrectdim(fact,resx,posax(3),posax(4));
    [stpx,stpy] = calcmaptoolsldstep(wrect,hrect,resx,resy);
    
    % set slider step
    q.slider_x(c).SliderStep = stpx;
    q.slider_y(c).SliderStep = stpy;
    
    % recenter rectangle
    x0 = q.rect(c).Position(1)+q.rect(c).Position(3)/2;
    y0 = q.rect(c).Position(2)+q.rect(c).Position(4)/2;
    xrect = x0-wrect/2;
    xrect(xrect<0) = 0;
    xrect(xrect>(resx-wrect)) = resx-wrect;
    yrect = y0-hrect/2;
    yrect(yrect<0) = 0;
    yrect(yrect>(resy-hrect)) = resy-hrect;
    
    % adjust slider positions accordingly
    xc = xrect/(resx-wrect);
    xc(isnan(xc) || isinf(xc)) = 0;
    yc = 1-yrect/(resy-hrect);
    yc(isnan(yc) || isinf(yc)) = 0;
    q.slider_x(c).Value = xc;
    q.slider_y(c).Value = yc;
end

updatePnts(h_fig)
