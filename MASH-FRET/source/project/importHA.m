function p = importHA(p,dat,h_fig)
% p = importHA(p,dat,h_fig)
%
% p: structure containing parameters for Histogram analysis interface
% dat: structure containing project data
% h_fig: handle to main figure

% add project to list
p.proj = [p.proj dat];

% define data processing parameters applied (prm)
for i = (size(p.proj,2)-size(dat,2)+1):size(p.proj,2)
    nChan = p.proj{i}.nb_channel;
    nExc = p.proj{i}.nb_excitations;
    allExc = p.proj{i}.excitations;
    chanExc = p.proj{i}.chanExc;
    nFRET = size(p.proj{i}.FRET,1);
    nS = size(p.proj{i}.S,1);
    em0 = find(chanExc~=0);
    nDE = numel(em0);
    nTpe = 2*nChan*nExc + 2*nDE + 2*nFRET + 2*nS;
    nTag = numel(p.proj{i}.molTagNames);
    I = p.proj{i}.intensities_denoise;
    I_discr = p.proj{i}.intensities_DTA;
    m_incl = p.proj{i}.coord_incl;
    FRET = p.proj{i}.FRET;
    FRET_discr = p.proj{i}.FRET_DTA;
    S = p.proj{i}.S;
    S_discr = p.proj{i}.S_DTA;
    L = size(I,1); N = size(I,2)/nChan;

    if ~isfield(p.proj{i}, 'prmThm')
        p.proj{i}.prm = cell(nTag+1,nTpe);
    else
        p.proj{i}.prm = p.proj{i}.prmThm;
        p.proj{i} = rmfield(p.proj{i}, 'prmThm');
    end
    if ~isfield(p.proj{i}, 'expThm')
        p.proj{i}.exp = [];
    else
        p.proj{i}.exp = p.proj{i}.expThm;
        p.proj{i} = rmfield(p.proj{i}, 'expThm');
    end
    prm = p.proj{i}.prm;

    % if project was not processed in Trace processing, get raw intensities
    if ~isfield(p.proj{i},'prmTT')
        p.proj{i}.prmTT = cell(1,N);
        I = p.proj{i}.intensities;
    end

    if nTpe>size(prm,2)
        if size(prm,2)==(nTpe-2*nDE)
            prm_new = cell(1,nTpe);
            prm_new([1:(2*nChan*nExc),(2*nChan*nExc+2*nDE+1):end]) = prm;
            prm = prm_new;
            clear prm_new;
        else
            prm = cell(nTag+1,nTpe);
        end
    end

    % if the number of data changed, reset results and resize
    if size(prm,2)~=(nTpe)
        prm = cell(nTag+1,nTpe);
    end
    
    % if the number of tags changed, reset results and resize
    if size(prm,1)~=(nTag+1)
        prm = cat(1,prm(1,:),cell(nTag,nTpe));
    end

    for tpe = 1:nTpe
        for tag = 1:(nTag+1)
            if tag==1
                m_tag = m_incl;
            else
                m_tag = m_incl & p.proj{i}.molTag(:,tag-1)';
            end

            % current data isn't an intensity ratio
            isratio = 0;

            if tpe <= nChan*nExc % intensity
                i_c = mod(tpe,nChan); i_c(i_c==0) = nChan;
                i_l = ceil(tpe/nChan);
                trace = I(:,i_c:nChan:end,i_l);

            elseif tpe <= 2*nChan*nExc % discr. intensity
                i_c = mod(tpe-nChan*nExc,nChan); i_c(i_c==0) = nChan;
                i_l = ceil((tpe-nChan*nExc)/nChan);
                trace = I_discr(:,i_c:nChan:end,i_l);

            elseif tpe <= (2*nChan*nExc + nDE) % total intensity
                id = tpe - 2*nChan*nExc;
                trace = [];
                l0 = allExc==chanExc(em0(id));
                for n = 1:N
                    trace = cat(2,trace,...
                        sum(I(:,((n-1)*nChan+1):(n*nChan),l0),2));
                end

            elseif tpe <= (2*nChan*nExc + 2*nDE) % total discr. intensity
                id = tpe - 2*nChan*nExc - nDE;
                trace = [];
                l0 = allExc==chanExc(em0(id));
                for n = 1:N
                    trace = cat(2,trace,...
                        sum(I_discr(:,((n-1)*nChan+1):(n*nChan),l0),2));
                end

            elseif tpe <= (2*nChan*nExc + 2*nDE + nFRET) % FRET
                I_re = nan(L*N,nChan,nExc);
                for c = 1:nChan
                    I_re(:,c,:) = reshape(I(:,c:nChan:end,:), ...
                        [N*L 1 nExc]);
                end
                i_f = tpe - 2*nChan*nExc - 2*nDE;

                gammas = [];
                for i_m = 1:N
                    if size(p.proj{i}.prmTT{i_m},2)==5 && ...
                            size(p.proj{i}.prmTT{i_m}{5},2)==5
                        gamma_m = p.proj{i}.prmTT{i_m}{5}{3};
                    elseif size(p.proj{i}.prmTT{i_m},2)==6 && ...
                            size(p.proj{i}.prmTT{i_m}{6},2)>=1 && ...
                            size(p.proj{i}.prmTT{i_m}{6}{1},2)==nFRET
                        gamma_m = p.proj{i}.prmTT{i_m}{6}{1}(1,:);
                    else
                        gamma_m = ones(1,nFRET);
                    end
                    gammas = [gammas; repmat(gamma_m,L,1)];
                end
                allFRET = calcFRET(nChan, nExc, allExc, chanExc, FRET, ...
                    I_re, gammas);
                trace = allFRET(:,i_f);
                trace = reshape(trace, [L N]);

                % current data is an intensity ratio
                isratio = 1;

            elseif tpe <= (2*nChan*nExc + 2*nDE + 2*nFRET) % FRET
                i_f = tpe - 2*nChan*nExc - 2*nDE - nFRET;
                trace = FRET_discr(:,i_f:nFRET:end);

                % current data is an intensity ratio
                isratio = 1;

            elseif tpe <= (2*nChan*nExc + 2*nDE + 2*nFRET+nS) % Stoichiometry
                I_re = nan(L*N,nChan,nExc);
                for c = 1:nChan
                    I_re(:,c,:) = reshape(I(:,c:nChan:end,:), ...
                        [N*L 1 nExc]);
                end
                i_s = tpe - 2*nChan*nExc - 2*nDE - 2*nFRET;

                gammas = [];
                betas = [];
                for i_m = 1:N
                    if size(p.proj{i}.prmTT{i_m},2)==5 && ...
                            size(p.proj{i}.prmTT{i_m}{5},2)==5
                        gamma_m = p.proj{i}.prmTT{i_m}{5}{3};
                        beta_m = ones(1,nFRET);
                    elseif size(p.proj{i}.prmTT{i_m},2)==6 && ...
                            size(p.proj{i}.prmTT{i_m}{6},2)>=1 && ...
                            size(p.proj{i}.prmTT{i_m}{6}{1},2)==nFRET
                        gamma_m = p.proj{i}.prmTT{i_m}{6}{1}(1,:);
                        beta_m = p.proj{i}.prmTT{i_m}{6}{1}(2,:);
                    else
                        gamma_m = ones(1,nFRET);
                        beta_m = ones(1,nFRET);
                    end
                    gammas = [gammas; repmat(gamma_m,L,1)];
                    betas = [betas; repmat(beta_m,L,1)];
                end
                allS = calcS(allExc,chanExc,S,FRET,I_re,gammas,betas);
                trace = allS(:,i_s);
                trace = reshape(trace, [L N]);

                % current data is an intensity ratio
                isratio = 1;

            elseif tpe <= (2*nChan*nExc + 2*nDE + 2*nFRET + 2*nS) % Stoichiometry
                i_s = tpe - 2*nChan*nExc - 2*nDE - 2*nFRET - nS;
                trace = S_discr(:,i_s:nS:end);

                % current data is an intensity ratio
                isratio = 1;
            end

            trace = trace(:,m_incl & m_tag);

            prm{tag,tpe} = setDefPrm_thm(prm{tag,tpe}, trace, isratio, ...
                p.colList);
        end
    end
    p.proj{i}.prm = prm;
    p.curr_tpe(i) = 1;
    p.curr_tag(i) = 1;
end

