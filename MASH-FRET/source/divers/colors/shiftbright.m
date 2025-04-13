function darkclr = shiftbright(clr, boffset)
transit = false;
if size(clr,1)>size(clr,2)
    transit = true;
    clr = clr';
end
fact = clr/max(clr);
darkclr = min(...
    [max([clr+fact*boffset;zeros(1,3)],[],1);ones(1,3)],[],1);
if transit
    darkclr = darkclr';
end