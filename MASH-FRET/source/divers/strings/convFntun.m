function fntsz_out = convFntun(fntsz_in,fntun_in,fntun_out)

fntsz_out = [];

% convert first to points
switch fntun_in
    case 'points'
        % do nothing
    case 'pixels'
        fntsz_in = 3*fntsz_in/4;
    case 'inches'
        dpi = get(0,'ScreenPixelsPerInch');
        fntsz_in = dpi*fntsz_in;
    case 'centimeters'
        dpi = get(0,'ScreenPixelsPerInch');
        fntsz_in = 2.54*dpi*fntsz_in;
    otherwise
        disp('font units is not supported');
        return;
end

% then convert points to desired font units
switch fntun_out
    case 'points'
        fntsz_out = round(fntsz_in);
    case 'pixels'
        fntsz_out = 4*fntsz_in/3;
    case 'inches'
        dpi = get(0,'ScreenPixelsPerInch');
        fntsz_out = fntsz_in/dpi;
    case 'centimeters'
        dpi = get(0,'ScreenPixelsPerInch');
        fntsz_out = fntsz_in/(2.54*dpi);
    otherwise
        disp('font units is not supported');
        return;
end