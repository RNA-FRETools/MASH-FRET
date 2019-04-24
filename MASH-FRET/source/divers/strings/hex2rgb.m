function rgb = hex2rgb(clr_hex)
% Convert hexadecimal color to rgb color and return rgb values between 0
% and 255

%% Created by MH, 24.4.2019
%
%%

rgb = [];

% remove potential '#' character
if numel(clr_hex)==7 && clr(1)=='#'
    clr_hex = clr_hex(2:end);
end

% hexadeciaml colors must contain 6 characters
if numel(clr_hex)~=6
    return;
end

try
    r = hex2dec(clr_hex(1:2));
    g = hex2dec(clr_hex(3:4));
    b = hex2dec(clr_hex(5:6));
    
    if ~(r>=0 && r<=255 && g>=0 && g<=255 && b>=0 && b<=255)
        return;
    end
    
    rgb = [r,g,b];
    
catch err
    if strcmp(err.identifier,'MATLAB:hex2dec:IllegalHexadecimal')
        return;
    else
        throw(err);
    end
end

