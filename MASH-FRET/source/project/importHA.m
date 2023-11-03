function p = importHA(p,projs)
% p = importHA(p,projs)
%
% Ensure proper import of input projects' HA processing parameters.
%
% p: structure containing interface parameters
% projs: indexes of projects

% define data processing parameters applied (prm)
for i = projs
    if isempty(p.proj{i}.HA)
        continue
    end
    
    nChan = p.proj{i}.nb_channel;
    nExc = p.proj{i}.nb_excitations;
    allExc = p.proj{i}.excitations;
    chanExc = p.proj{i}.chanExc;
    nFRET = size(p.proj{i}.FRET,1);
    nS = size(p.proj{i}.S,1);
    I = p.proj{i}.intensities;
    I_den = p.proj{i}.intensities_denoise;
    I_discr = p.proj{i}.intensities_DTA;
    m_incl = p.proj{i}.coord_incl;
    FRET = p.proj{i}.FRET;
    FRET_discr = p.proj{i}.FRET_DTA;
    S = p.proj{i}.S;
    S_discr = p.proj{i}.S_DTA;

    em0 = find(chanExc~=0);
    inclem = true(1,numel(em0));
    for em = 1:numel(em0)
        if ~sum(chanExc(em)==allExc)
            inclem(em) = false;
        end
    end
    em0 = em0(inclem);
    nDE = numel(em0);
    nTpe = 2*nChan*nExc + 2*nDE + 2*nFRET + 2*nS;
    nTag = numel(p.proj{i}.molTagNames);
    L = size(I_den,1); N = size(I_den,2)/nChan;

    % initializes applied parameters
    if ~isfield(p.proj{i}.HA,'prm')
        p.proj{i}.HA.prm = cell(nTag+1,nTpe);
    end
    
    % initializes export options
    if ~isfield(p.proj{i}.HA,'exp')
        p.proj{i}.HA.exp = [];
    end

    if nTpe>size(p.proj{i}.HA.prm,2)
        p.proj{i}.HA.prm = cell(nTag+1,nTpe);
    end

    % if the number of data changed, reset results and resize
    if size(p.proj{i}.HA.prm,2)~=(nTpe)
        p.proj{i}.HA.prm = cell(nTag+1,nTpe);
    end
    
    % if the number of tags changed, reset results and resize
    if size(p.proj{i}.HA.prm,1)~=(nTag+1)
        p.proj{i}.HA.prm = cat(1,p.proj{i}.HA.prm(1,:),cell(nTag,nTpe));
    end
    
    p.proj{i}.HA.def = cell(nTag+1,nTpe);
    p.proj{i}.HA.curr = cell(nTag+1,nTpe);
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
                if sum(all(isnan(I_den(:,i_c:nChan:end,i_l))))
                    trace = I(:,i_c:nChan:end,i_l);
                else
                    trace = I_den(:,i_c:nChan:end,i_l);
                end

            elseif tpe <= 2*nChan*nExc % discr. intensity
                i_c = mod(tpe-nChan*nExc,nChan); i_c(i_c==0) = nChan;
                i_l = ceil((tpe-nChan*nExc)/nChan);
                if sum(all(isnan(I_discr(:,i_c:nChan:end,i_l))))
                    trace = I(:,i_c:nChan:end,i_l);
                else
                    trace = I_discr(:,i_c:nChan:end,i_l);
                end

            elseif tpe <= (2*nChan*nExc + nDE) % total intensity
                id = tpe - 2*nChan*nExc;
                trace = [];
                l0 = allExc==chanExc(em0(id));
                for n = 1:N
                    I_n = sum(I_den(:,((n-1)*nChan+1):(n*nChan),l0),2);
                    if all(isnan(I_n))
                        trace = cat(2,trace,...
                            sum(I(:,((n-1)*nChan+1):(n*nChan),l0),2));
                    else
                        trace = cat(2,trace,I_n);
                    end
                end

            elseif tpe <= (2*nChan*nExc + 2*nDE) % total discr. intensity
                id = tpe - 2*nChan*nExc - nDE;
                trace = [];
                l0 = allExc==chanExc(em0(id));
                for n = 1:N
                    I_n = sum(I_discr(:,((n-1)*nChan+1):(n*nChan),l0),2);
                    if all(isnan(I_n))
                        trace = cat(2,trace,...
                            sum(I(:,((n-1)*nChan+1):(n*nChan),l0),2));
                    else
                        trace = cat(2,trace,I_n);
                    end
                end

            elseif tpe <= (2*nChan*nExc + 2*nDE + nFRET) % FRET
                I_re = nan(L*N,nChan,nExc);
                for c = 1:nChan
                    I_re(:,c,:) = reshape(I_den(:,c:nChan:end,:), ...
                        [N*L 1 nExc]);
                end
                i_f = tpe - 2*nChan*nExc - 2*nDE;

                gammas = [];
                for i_m = 1:N
                    if size(p.proj{i}.TP.prm{i_m},2)==5 && ...
                            size(p.proj{i}.TP.prm{i_m}{5},2)==5
                        gamma_m = p.proj{i}.TP.prm{i_m}{5}{3};
                    elseif size(p.proj{i}.TP.prm{i_m},2)==6 && ...
                            size(p.proj{i}.TP.prm{i_m}{6},2)>=1 && ...
                            size(p.proj{i}.TP.prm{i_m}{6}{1},2)==nFRET
                        gamma_m = p.proj{i}.TP.prm{i_m}{6}{1}(1,:);
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
                    I_re(:,c,:) = reshape(I_den(:,c:nChan:end,:), ...
                        [N*L 1 nExc]);
                end
                i_s = tpe - 2*nChan*nExc - 2*nDE - 2*nFRET;

                gammas = [];
                betas = [];
                for i_m = 1:N
                    if size(p.proj{i}.TP.prm{i_m},2)==5 && ...
                            size(p.proj{i}.TP.prm{i_m}{5},2)==5
                        gamma_m = p.proj{i}.TP.prm{i_m}{5}{3};
                        beta_m = ones(1,nFRET);
                    elseif size(p.proj{i}.TP.prm{i_m},2)==6 && ...
                            size(p.proj{i}.TP.prm{i_m}{6},2)>=1 && ...
                            size(p.proj{i}.TP.prm{i_m}{6}{1},2)==nFRET
                        gamma_m = p.proj{i}.TP.prm{i_m}{6}{1}(1,:);
                        beta_m = p.proj{i}.TP.prm{i_m}{6}{1}(2,:);
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
            
            p.proj{i}.HA.def{tag,tpe} = setDefPrm_thm([],trace,isratio,...
                p.thm.colList);
            
            p.proj{i}.HA = downCompatibilityHA(p.proj{i}.HA,tpe,tag);
            
            p.proj{i}.HA.curr{tag,tpe} = setDefPrm_thm(...
                p.proj{i}.HA.prm{tag,tpe}, trace, isratio, p.thm.colList);
        end
    end
    
    % initializes current data type, tag and plot
    p.thm.curr_tpe(i) = 1;
    p.thm.curr_tag(i) = 1;
    p.thm.curr_plot(i) = 1;
end

