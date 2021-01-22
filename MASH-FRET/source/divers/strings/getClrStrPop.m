function str_clr = getClrStrPop(str_pop,clr)
% str_clr = getClrStrPop(str_pop,clr)
%
% Return HTML-tagged string for colored menu
%
% str_pop: {1-by-M} menu's string
% clr: [M-by-3] or [M-by-6] RGB background or bacground and font colors (between 0 and 1)

M = numel(str_pop);
str_clr = cell(1,M);
isFntClr = size(clr,2)==6;

for m = 1:M
    clr_bg = sprintf('rgb(%i,%i,%i)', round(clr(m,1:3)*255));
    if ~isFntClr
        clr_fnt = sprintf('rgb(%i,%i,%i)', [255 255 255]*(sum(clr(m,1:3)) <= 1.5));
    else
        clr_fnt = sprintf('rgb(%i,%i,%i)', round(clr(m,4:6)*255));
    end
    str_clr{m} = ['<html><span style= "background-color: ' clr_bg ...
        ';color: ' clr_fnt ';">' str_pop{m} '</span></html>'];
end