function p = crossCorr(mol, p)

proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;

isCrossCorr = ~isempty(p.proj{proj}.intensities_crossCorr) && ...
    prod(prod(prod(double(~isnan(p.proj{proj}.intensities_crossCorr(:, ...
    ((mol-1)*nChan+1):mol*nChan,:))),1),2),3);

if ~isCrossCorr
    
    nExc = p.proj{proj}.nb_excitations;
    
    I_bgCorr = p.proj{proj}.intensities_bgCorr(:, ...
        ((mol-1)*nChan+1):mol*nChan,:);

    I_corr = I_bgCorr;
    for l = 1:nExc
        for c = 1:nChan

            % bleedthrough corr.
            if nChan > 1
                n = 0;
                for c2 = 1:nChan
                    if c ~= c2
                        n = n+1;
                        coeff = p.proj{proj}.prm{mol}{5}{1}{l,c}(n);
                        I_corr(:,c2,l) = I_corr(:,c2,l) - ...
                            coeff*I_bgCorr(:,c,l);
                    end
                end
            end

            % direct exc. corr.
            if nExc > 1
                n = 0;
                for l2 = 1:nExc
                    if l2 ~= l
                        n = n+1;
                        coeff = p.proj{proj}.prm{mol}{5}{2}{l,c}(n);
                        I_corr(:,c,l) = I_corr(:,c,l) - ...
                            coeff*I_corr(:,c,l2);
                    end
                end
            end
        end
    end

    p.proj{proj}.intensities_crossCorr(:,((mol-1)*nChan+1):mol*nChan,:)= ...
        I_corr;
    p.proj{proj}.intensities_denoise(:,((mol-1)*nChan+1):mol*nChan,:)= NaN;
end

