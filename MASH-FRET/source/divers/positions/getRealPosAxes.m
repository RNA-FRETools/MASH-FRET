function pos_rl = getRealPosAxes(pos, ti, type)
% pos_rl = getRealPosAxes(pos, ti, type);
%
% Return axes position corrected for axis and tick labels.
%
% pos: axes position
% ti: (tight insets) margins including axis label and tick labels [left,bottom,right,top]
% type: 'trace' shift axes position to the right to add labels

if strcmp(type,'traces')
    x = pos(1) + ti(1);
else
    x = pos(1);
end
y = pos(2) + ti(2);
w = pos(3) - ti(1) - ti(3);
h = pos(4) - ti(2) - ti(4);
pos_rl = [x y w h];