function ok = ishexclr(clr)
% Return 1 if the input string correspond to a RGB color in hexadecimal
% format, and 0 otherwise

%% Created by MH, 24.4.2019
%
%%

ok = 1;

% remove potential '#' character
if numel(clr)==7 && clr(1)=='#'
    clr = clr(2:end);
end

% hexadeciaml colors must contain 6 characters
if numel(clr)~=6
    ok = 0;
    return;
end

try
    r = hex2dec(clr(1:2));
    g = hex2dec(clr(3:4));
    b = hex2dec(clr(5:6));
    
    if ~(r>=0 && r<=255 && g>=0 && g<=255 && b>=0 && b<=255)
        ok = 0;
        return;
    end
    
catch err
    if strcmp(err.identifier,'MATLAB:hex2dec:IllegalHexadecimal')
        ok = 0;
        return;
    else
        throw(err);
    end
end