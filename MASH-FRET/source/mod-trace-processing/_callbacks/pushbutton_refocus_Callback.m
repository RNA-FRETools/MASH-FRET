function pushbutton_refocus_Callback(obj,evd,h_fig)
% Last update by MH, 29.4.2019: is now a pushbutton

h = guidata(h_fig);
p = h.param;
    
if ~(p.proj{p.curr_proj}.is_coord && p.proj{p.curr_proj}.is_movie)
    return
end

proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nChan = p.proj{proj}.nb_channel;
coord = p.proj{proj}.coord;
labels = p.proj{proj}.labels;
itgArea = p.proj{proj}.pix_intgr(1);
res_x = p.proj{proj}.movie_dim(1);
res_y = p.proj{proj}.movie_dim(2);
L_ex = size(p.proj{proj}.intensities,1);
nExc = p.proj{proj}.nb_excitations;
nPix = p.proj{proj}.pix_intgr(2);
mov_file = p.proj{proj}.movie_file;
fCurs = p.proj{proj}.movie_dat{1};
L = p.proj{proj}.movie_dat{3};
exc = p.proj{proj}.TP.fix{1}(1);
L_adj = nExc*L_ex;

split = round(res_x/nChan)*(1:nChan-1);
lim_x = [0 split res_x];
lim.y = [0 res_y];

img = p.proj{proj}.aveImg{exc};

for c = 1:nChan
    lim.x = [lim_x(c) lim_x(c+1)];
    new_coord = recenterSpot(img,coord(mol,2*c-1:2*c),itgArea,lim);

    if ~isequal(new_coord, coord(mol,(2*c-1):2*c))
        disp(cat(2,'recenter molecule position in channel ',labels{c}));

        p.proj{proj}.coord(mol,(2*c-1):2*c) = new_coord;

        [o,trace] = create_trace(new_coord,itgArea,nPix, ...
            {mov_file,{fCurs []},[res_y,res_x],L},h.mute_actions);

        I = nan(L_ex,1,nExc);
        for i = 1:nExc
            I(:,1,i) = trace(i:nExc:L_adj,:);
        end

        p.proj{proj}.coord(mol,(2*c-1):2*c) = new_coord;
        p.proj{proj}.intensities(:,((mol-1)*nChan+c),:) = I;
        p.proj{proj}.intensities_bgCorr(:,((mol-1)*nChan+c),:) = NaN;
    else
        disp(cat(2,'molecule position in channel ',labels{c},...
            ' is already centered'))
    end

    coord(mol,(2*c-1):2*c) = new_coord;
end

h.param = p;
guidata(h_fig, h);

updateFields(h_fig, 'ttPr');

