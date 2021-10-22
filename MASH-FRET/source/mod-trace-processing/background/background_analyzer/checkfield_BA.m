function ok = checkfield_BA(h_fig)

ok = 0;

g = guidata(h_fig);
h = guidata(g.figure_MASH);
p = h.param;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nMol = size(p.proj{proj}.intensities,2)/nChan;
exc = p.proj{proj}.chanExc;
chan = p.proj{proj}.labels;

% update g structure
if ~g.param{3}(1) % fix param 1
    p1 = g.param{2}{1};
    edit_param1 = g.edit_param1_i;
else
    edit_param1 = g.edit_param1;
end
if ~g.param{3}(2) % fix sub-image dim.
    subdim = g.param{2}{2};
    edit_subimdim = g.edit_subimdim_i;
else
    edit_subimdim = g.edit_subimdim;
end
if g.param{3}(3) % all molecules
    mols = 1:nMol;
else
    mols = g.curr_m;
end

for m = mols
    isprm1 = sum([sum(sum(g.param{1}{m}(:,:,1)==3)) ...
        sum(sum(g.param{1}{m}(:,:,1)==4)) ...
        sum(sum(g.param{1}{m}(:,:,1)==5)) ...
        sum(sum(g.param{1}{m}(:,:,1)==6))]) ;
    if g.param{3}(1) || ~isprm1 % fix param 1
        p1 = g.param{1}{m}(:,:,2);
    end
    issubdim = sum(sum(g.param{1}{m}(:,:,1)~=1));
    if g.param{3}(2) || ~issubdim % fix sub-image dim.
        subdim = g.param{1}{m}(:,:,3);
    end
    if g.param{3}(1) % fix param 1
        p1 = g.param{1}{m}(:,:,2);
    end
    if g.param{3}(3) % fix sub-image dim.
        subdim = g.param{1}{m}(:,:,3);
    end
    for l = 1:nExc
        for c = 1:nChan
            meth = g.param{1}{m}(l,c,1);
            % param 1
            if sum(meth==[3 4 5 6 7])
                for i1 = 1:size(p1,3)
                    if meth==6 && ~(numel(p1(l,c,i1))==1 && ...
                            ~isnan(p1(l,c,i1)) && p1(l,c,i1)>=0)
                        updateActPan(sprintf(['Molecule %i, %s channel' ...
                            ' upon %inm excitation:\nThe sliding ' ...
                            'average window size must be an integer >=' ...
                            ' 0.'], m, chan{c}, exc(l)), ...
                            g.figure_MASH, 'error');
                        set(edit_param1(i1), 'BackgroundColor', ...
                            [1 0.75 0.75]);
                        return;
                    elseif meth==3 && ~(numel(p1(l,c,i1))==1 ...
                            && ~isnan(p1(l,c,i1)) && p1(l,c,i1)>=0)
                        updateActPan(sprintf(['Molecule %i, %s channel' ...
                            ' upon %inm excitation:\nThe tolerance ' ...
                            'cutoff must be >=0'], m, chan{c}, exc(l)), ...
                            g.figure_MASH, 'error');
                        set(edit_param1(i1), 'BackgroundColor', ...
                            [1 0.75 0.75]);
                        return;
                    elseif meth==4 && ~(numel(p1(l,c,i1))==1 ...
                            && ~isnan(p1(l,c,i1)) && p1(l,c,i1)>0)
                        updateActPan(sprintf(['Molecule %i, %s channel' ...
                            ' upon %inm excitation:\nThe number of ' ...
                            'interval must be a strictly positive ' ...
                            'number.'], m, chan{c}, exc(l)), ...
                            g.figure_MASH, 'error');
                        set(edit_param1(i1), 'BackgroundColor', ...
                            [1 0.75 0.75]);
                        return;
                    elseif meth==5 && ~(numel(p1(l,c,i1))==1 ...
                            && ~isnan(p1(l,c,i1)) && p1(l,c,i1)>=0 && ...
                            p1(l,c,i1)<=1)
                        updateActPan(sprintf(['Molecule %i, %s channel' ...
                            ' upon %inm excitation:\nThe cumulative ' ...
                            'probability threshold must be comprised ' ...
                            'between 0 and 1.'], m, chan{c}, exc(l)), ...
                            g.figure_MASH, 'error');
                        set(edit_param1(i1), 'BackgroundColor', ...
                            [1 0.75 0.75]);
                        return;
                    elseif meth==7 && ~(numel(p1(l,c,i1))==1 && ...
                            ~isnan(p1(l,c,i1)) && sum(p1(l,c,i1)==[1 2]))
                        updateActPan(sprintf(['Molecule %i, %s channel' ...
                            ' upon %inm excitation:\nMedian ' ...
                            'calculation method must be 1 or 2'], m, ...
                            chan{c}, exc(l)), g.figure_MASH, 'error');
                        set(edit_param1(i1), 'BackgroundColor', ...
                            [1 0.75 0.75]);
                        return;
                    end
                end
            end
            % sub-image dim.
            if ~meth==1
                for i2 = 1:size(subdim,3)
                    if ~(numel(subdim(l,c,i2))==1 && ...
                            ~isnan(subdim(l,c,i2)) && subdim(l,c,i2)>0)
                        updateActPan(sprintf(['Molecule %i, %s channel' ...
                            ' upon %inm excitation:\nThe sub-image ' ...
                            'dimensions must be a strictly positive ' ...
                            'number.'], m, chan{c}, exc(l)), ...
                            g.figure_MASH, 'error');
                        set(edit_subimdim(i2), 'BackgroundColor', ...
                            [1 0.75 0.75]);
                        return;
                    end
                end
            end
            if meth==6
                % dark x-coord
                % dark y-coord
            end
            if meth==1
                % BG intensity
            end
        end
    end
end
ok = 1;


