function [bg_m,coord_dark_m] = calcBg_BA(m, p1, subdim, h_fig)

g = guidata(h_fig);
h = guidata(g.figure_MASH);
p = h.param;
proj = p.curr_proj;
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;

bg_m = zeros(nExc,nChan);
coord_dark_m = cell(nExc,nChan);

for l = 1:nExc
    for c = 1:nChan
        method = g.param{1}{m}(l,c,1);
        methprm = g.param{1}{m}(l,c,[2,3,7,4:6]);
        methprm([1,2]) = [p1(l,c),subdim(l,c)];
        dynbg = g.param{1}{m}(l,c,8);

        [bg,coord_dark] = calcbgint(m,l,c,dynbg,method,methprm,...
            p.proj{proj},g.figure_MASH);

        bg_m(l,c) = mean(bg);
        if method==6
            coord_dark_m{l,c} = coord_dark;
        else
            coord_dark_m{l,c} = [0,0];
        end
    end
end
guidata(h_fig, g);

