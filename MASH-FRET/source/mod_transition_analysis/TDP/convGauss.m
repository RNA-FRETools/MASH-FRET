function dataConv = convGauss(data, o2, lim)

dataConv = data;
is2d = size(lim,1)>1;
if ~is2d && size(dataConv,2)==1
    dataConv = dataConv';
end
if numel(o2)==1
    ox = o2;
    oy = ox;
else
    ox = o2(1);
    oy = o2(2);
end

bin_x = (lim(1,2)-lim(1,1))/size(dataConv,2);
if is2d
    bin_y = (lim(2,2)-lim(2,1))/size(dataConv,1);
end

sig_x = sqrt(ox)/bin_x;
if is2d
    sig_y = sqrt(oy)/bin_y;
end

lim_x = ceil(3*sig_x);
lim_x(lim_x<1) = 1;
gFilter_x = exp(-(((-lim_x:lim_x).^2)/(2*(sig_x^2))));
gFilter_x = gFilter_x/sum(gFilter_x,2);

if is2d
    lim_y = ceil(3*sig_y);
    lim_y(lim_y<1) = 1;
    gFilter_y = exp(-(((-lim_y:lim_y).^2)/(2*(sig_y^2))));
    gFilter_y = gFilter_y/sum(gFilter_y,2);
end

try
    if is2d
        dataConv = conv2(data',gFilter_x','same');
        dataConv = conv2(dataConv',gFilter_y','same');
    else
        dataConv = conv(data',gFilter_x','same');
    end
    
catch err
    errordlg(['2D gaussian convolution impossible: ' err.message], ...
        'TDP error', 'modal');
    return;
end


