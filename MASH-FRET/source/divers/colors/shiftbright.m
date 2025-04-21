function [shftclr,clr] = shiftbright(clr0, boffset)
[transit,clr0] = mustbetransposed(clr0);
if max(clr0)>0
    fact = clr0/max(clr0);
else
    fact = ones(size(clr0));
end

shftclr = clr0+fact*boffset;
clr = clr0;
if boffset<0
    clr(shftclr<0) = clr0(shftclr<0)-shftclr(shftclr<0);
    shftclr(shftclr<0) = 0;
else
    clr(shftclr>1) = clr0(shftclr>1)-(shftclr(shftclr>1)-1);
    shftclr(shftclr>1) = 1;
end

clr(clr<0) = 0;
clr(clr>1) = 1;

if transit
    shftclr = shftclr';
    clr = clr';
end

function [transposeit,clr] = mustbetransposed(clr)
transposeit = false;
if size(clr,1)>size(clr,2)
    transposeit = true;
    clr = clr';
end