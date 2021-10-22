function pushbutton_BA_start_Callback(obj, evd, h_fig)

h = guidata(h_fig);
g = guidata(h.bga.figure_bgopt);

if ~checkfield_BA(g.figure_bgopt)
    return
end

p = h.param;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nMol = size(p.proj{proj}.intensities,2)/nChan;

if ~g.param{3}(1) % varies param 1
    p1 = g.param{2}{1};
end
if ~g.param{3}(2) % varies sub-image dim.
    subdim = g.param{2}{2};
end
if g.param{3}(3) % all molecules
    mols = 1:nMol;
else
    mols = g.curr_m;
end

bg_m = cell(nMol,nExc,nChan);
% loading bar parameters--------------------------------------
err = loading_bar('init', g.figure_MASH, numel(mols), ...
    'Calculate background intensities...');
if err
    return;
end
h = guidata(g.figure_MASH);
h.barData.prev_var = h.barData.curr_var;
guidata(g.figure_MASH, h);
% ------------------------------------------------------------

for m = mols
    isprm1 = sum([sum(sum(g.param{1}{m}(:,:,1)==3)) ...
        sum(sum(g.param{1}{m}(:,:,1)==4)) ...
        sum(sum(g.param{1}{m}(:,:,1)==5)) ...
        sum(sum(g.param{1}{m}(:,:,1)==6)) ...
        sum(sum(g.param{1}{m}(:,:,1)==7))]) ;
    if g.param{3}(1) || ~isprm1 % fix param 1
        p1 = g.param{1}{m}(:,:,2);
    end
    issubdim = sum(sum(g.param{1}{m}(:,:,1)~=1));
    if g.param{3}(2) || ~issubdim % fix sub-image dim.
        subdim = g.param{1}{m}(:,:,3);
    end
    for i1 = 1:size(p1,3)
        for i2 = 1:size(subdim,3)
            bg = calcBg_BA(m, p1(:,:,i1), subdim(:,:,i2), g.figure_bgopt);
            for l = 1:nExc
                for c = 1:nChan
                    if i1==1 && i2==1
                        g.param{1}{m}(l,c,7) = bg(l,c);
                    end
                    bg_m{m,l,c} = [bg_m{m,l,c}; [bg(l,c) p1(l,c,i1) ...
                        subdim(l,c,i2)]];
                    if i1==1 && i2==1
                        g.param{1}{m}(l,c,7) = bg(l,c);
                    end
                end
            end
        end
    end
    
    % loading bar updating-------------------------------------
    err = loading_bar('update', g.figure_MASH);
    if err
        return;
    end
    % ---------------------------------------------------------
end
loading_bar('close', g.figure_MASH);
g.res = bg_m;
guidata(g.figure_bgopt, g);
ud_BAfields(g.figure_bgopt);
plot_bgRes(g.figure_bgopt);


