function popupmenu_noiseType_Callback(obj, evd, h_fig)

switch get(obj, 'Value')
    case 1 % Poisson or P-model from B�rner et al. 2017
        noiseType = 'poiss';
    case 2 % Gaussian, Normal or N-model from B�rner et al. 2017
        noiseType = 'norm';
    case 3 % User defined or NExpN-model from B�rner et al. 2017
        noiseType = 'user';
    case 4 % None, no camera noise but possible camera offset value
        noiseType = 'none';
    case 5 % Hirsch or PGN- Model from Hirsch et al. 2011
        noiseType = 'hirsch';
end

h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.sim.curr.gen_dat{1}{2}{4} = noiseType;

h.param = p;
guidata(h_fig, h);

ud_S_vidParamPan(h_fig);