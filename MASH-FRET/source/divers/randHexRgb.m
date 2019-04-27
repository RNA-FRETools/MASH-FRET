function clr_hex = randHexRgb(varargin)
% Generate random RGB color and return the hexadecimal format

clr_rgb = round(255*rand(1,3));

clr_hex = '';
for c = 1:3
    clr = num2str(dec2hex(clr_rgb(c)));
    if numel(clr)==1
        clr = cat(2,'0',clr);
    end
    clr_hex = cat(2,clr_hex,clr);
end
