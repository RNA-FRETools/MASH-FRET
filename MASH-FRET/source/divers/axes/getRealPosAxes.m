function pos_rl = getRealPosAxes(pos, ti, type)
if strcmp(type,'traces')
    x = pos(1) + ti(1);
else
    x = pos(1);
end
y = pos(2) + ti(2);
w = pos(3) - ti(1) - ti(3);
h = pos(4) - ti(2) - ti(4);
pos_rl = [x y w h];