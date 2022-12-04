function p = denoiseTraces(m, p)

proj = p.curr_proj;
nC = p.proj{proj}.nb_channel;

isDenoise = ~isempty(p.proj{proj}.intensities_denoise) && isempty(find(...
    isnan((p.proj{proj}.intensities_denoise(:,((m-1)*nC+1):m*nC,:))),1));

if isDenoise
    return
end

nExc = p.proj{proj}.nb_excitations;

I_corr = p.proj{proj}.intensities_crossCorr(:,((m-1)*nC+1):m*nC,:);
incl = ~isnan(sum(sum(I_corr,3),2));
I_corr = I_corr(incl,:,:);
I_den = I_corr;

prm = p.proj{proj}.TP.prm{m}{1};
apply = prm{1}(2);

if apply
    meth = prm{1}(1);
    switch meth
        case 1 % sliding average
            for l = 1:nExc
                for c = 1:nC
                    I_den(:,c,l) = slideAve(I_corr(:,c,l),prm{2}(meth,1));
                end
            end

        case 2 % Haran filter
            FRET = p.proj{proj}.FRET;
            exc = p.proj{proj}.excitations;
            chanExc = p.proj{proj}.chanExc;
            for l = 1:nExc
                for c = 1:nC

                    Ia = I_corr(:,c,l);
                    Ib = I_corr(:,c,l);

                    if ~isempty(FRET)
                        [row,col,o] = find((FRET(:,1)==c | FRET(:,2)==c));
                        if ~isempty(row)
                            [o,l_c,o] = find(exc==chanExc(FRET(row,1)));
                            if ~isempty(l_c) && l == l_c
                                if col(1) == 1
                                    Ia = I_corr(:,c,l);
                                    Ib = I_corr(:,FRET(row,2),l);
                                else
                                    Ia = I_corr(:,c,l);
                                    Ib = I_corr(:,FRET(row,1),l);
                                end
                            end
                        end
                    end

                    Ia_mean = mean(Ia);
                    Ib_mean = mean(Ib);
                    r.a = Ia/Ia_mean;
                    r.b = Ib/Ib_mean;

                    [r_nlf] = nlfilteret(r,prm{2}(meth,1),prm{2}(meth,2),...
                        [1 2 3 4]*prm{2}(meth,3));
                    I_den(:,c,l) = r_nlf.a * Ia_mean;
                end
            end

        case 3 % Wavelet analysis
            strgth = prm{2}(meth,1);
            strgth_prm = [0 0 0];
            strgth_prm(strgth) = 1;
            fret_shrink.firm = strgth_prm(1);
            fret_shrink.hard = strgth_prm(2); 
            fret_shrink.soft = strgth_prm(3); 

            time_local = prm{2}(meth,2);
            fret_shrink.adaptive = abs(time_local-2);

            cycle_spin = prm{2}(meth,3);
            fret_shrink.cspin_on = abs(cycle_spin-2);

            % Taylor/Landes wavelet denoising function
            if fret_shrink.adaptive && fret_shrink.firm(1) == 1 && ...
                    ~exist('upper_th.dat', 'file')
                updateActPan(['Wavelet analysis impossible: file ' ...
                   '"upper_th.dat" missing.'], h_fig, 'error');
                return;
            end
            for l = 1:nExc
                I_den(:,:,l) = run_control(fret_shrink, I_corr(:,:,l));
            end
    end
end

p.proj{proj}.intensities_denoise(incl,((m-1)*nC+1):m*nC,:) = I_den;
p.proj{proj}.intensities_DTA(:,((m-1)*nC+1):m*nC,:) = NaN;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
if nFRET > 0
    p.proj{proj}.FRET_DTA(:,((m-1)*nFRET+1):m*nFRET,:) = NaN;
end
if nS > 0
    p.proj{proj}.S_DTA(:,((m-1)*nS+1):m*nS,:) = NaN;
end

