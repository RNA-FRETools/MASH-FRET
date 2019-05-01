function clr_hex = rgb2hex(rgb)
% Convert rgb color with values between 0 and 255 to hexadecimal color

%% Created by MH, 1.5.2019
%
%%

clr_hex = '';
for c = 1:3
    clr = dec2hex(rgb(c));
    if rgb(c)<10
        clr = cat(2,'0',clr);
    end
    clr_hex = cat(2,clr_hex,clr);
end