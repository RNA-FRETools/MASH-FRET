function p = crossCorr(mol, p)

% Last update by MH 29.3.2019
% >> adapt bleethrough and direct excitation calculations to new parameter
%    structure (see project/setDefPrm_traces.m)
% >> correct traces, first from bleedthrough, then from direct excitation

proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;

% added by MH, 29.3.2019
exc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;
labels = p.proj{proj}.labels;

isCrossCorr = ~isempty(p.proj{proj}.intensities_crossCorr) && ...
    prod(prod(prod(double(~isnan(p.proj{proj}.intensities_crossCorr(:, ...
    ((mol-1)*nChan+1):mol*nChan,:))),1),2),3);

if ~isCrossCorr
    
    nExc = p.proj{proj}.nb_excitations;
    
    I_bgCorr = p.proj{proj}.intensities_bgCorr(:, ...
        ((mol-1)*nChan+1):mol*nChan,:);

    I_corr = I_bgCorr;

    % added by MH, 29.3.2019
    % bleedthrough corr.
    for c = 1:nChan
        if nChan > 1
            n = 0;
            for c2 = 1:nChan % c bleeds into c2
                if c ~= c2
                    n = n+1;
                    coeff = p.proj{proj}.fix{4}{1}(c,n);
                    I_corr(:,c2,:) = I_corr(:,c2,:)-coeff*I_bgCorr(:,c,:);
                end
            end
        end
    end
    % direct exc. corr.
    if nExc > 1
        for c = 1:nChan

            l0 = find(exc==chanExc(c));
            if isempty(l0)
                if sum(p.proj{proj}.fix{4}{2}(:,c))
                    disp(cat(2,labels{c},'-specific illumination ',...
                        'is not defined: direct excitation can not be ',...
                        'calculated; DE coefficient set to zero.'));
                    p.proj{proj}.fix{4}{2}(:,c) = 0;
                end
                continue;
            end
            l0 = l0(1);
            
            n = 0;
            for l = 1:nExc
                if l ~= l0
                    n = n+1;

                    coeff = p.proj{proj}.fix{4}{2}(n,c);
                    I_corr(:,c,l) = I_corr(:,c,l) - coeff*I_corr(:,c,l0);
                end
            end
        end
    end

    p.proj{proj}.intensities_crossCorr(:,((mol-1)*nChan+1):mol*nChan,:)= ...
        I_corr;
    p.proj{proj}.intensities_denoise(:,((mol-1)*nChan+1):mol*nChan,:)= NaN;
end

