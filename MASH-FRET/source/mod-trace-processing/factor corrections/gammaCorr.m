function p = gammaCorr(h_fig, m, p)

% Last update: by MH, 8.4.2019
% >> correct the control of presence for multidimensional discretized 
%    intensities
%
% update: by MH, 2.4.2019
% >> correct the control of presence of discretized intensities according
%    to FS suggestions
%
% update: 23.5.2019 by MH
% >> reset discretized FRET traces when gamma factors was changed manually
%
% created: by MH, 27.3.2019

proj = p.curr_proj;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
if nFRET<1
    return
end

prm = p.proj{proj}.TP.prm{m}{6};
method = prm{2};

% collect molecule traces
chanExc = p.proj{proj}.chanExc;
nC = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
incl = p.proj{proj}.bool_intensities(:,m);
I_den = p.proj{proj}.intensities_denoise(incl,((m-1)*nC+1):m*nC,:);
I_dta = p.proj{proj}.intensities_DTA(incl,((m-1)*nC+1):m*nC,:);
prm_dta = p.proj{proj}.TP.curr{m}{4};

% calculate factors for reddest-to-greenest donors
[o,id] = sort(chanExc(FRET(:,1)),'descend');
for i = id

    if method(i)==1 % photobleaching-based

        % check validity of previously calculated gamma (valid if donor and 
        % acceptor state sequences are preserved)
        don = p.proj{proj}.FRET(i,1);
        acc = p.proj{proj}.FRET(i,2);
        ldon = find(p.proj{proj}.excitations==p.proj{proj}.chanExc(don),1);
        if ~all(isnan(I_dta(:,[don,acc],ldon)))
            continue
        end

        [I_DA,stop,gamma,ok,str] = gammaCorr_pb(i,I_den,prm{3}(i,1:6),...
            prm_dta,p.proj{proj},h_fig);

        p.proj{proj}.TP.prm{m}{6}{3}(i,7) = stop*nExc;

        % set method to "manual" if gamma calculation did not converge
        if ~ok
            p.proj{proj}.TP.prm{m}{6}{2}(i) = 0;
            setContPan(cat(2,str,': method is set to "manual" and gamma ',...
                'factor to previous value'),'warning',h_fig);

        elseif round(gamma,2)~=p.proj{proj}.TP.prm{m}{6}{1}(1,i) % gamma changed
            % save gamma
            p.proj{proj}.TP.prm{m}{6}{1}(1,i) = round(gamma,2);

            % reset discretized FRET data
            p.proj{proj}.FRET_DTA(:,(m-1)*nFRET+i) = NaN;

            % store D-A state sequences
            I_dta(:,[don,acc],ldon) = I_DA;
            p.proj{proj}.intensities_DTA(incl,((m-1)*nC+1):m*nC,:) = I_dta;
        end

    elseif method(i)==2 % ES linear regression

        [p,ES,gamma,beta,ok,str] = gammaCorr_ES(i,p,prm{4},...
            p.proj{proj}.TP.prm{m}{6}{1},h_fig);
        
        % store all ES histogram (even failures)
        p.proj{proj}.ES{i} = ES;

        if ~ok
            p.proj{proj}.TP.prm{m}{6}{2}(i) = 0;
            setContPan(cat(2,str,': method is set to "manual" and gamma ',...
                'factor to previous value'),'warning',h_fig);

        elseif ~isequal(round([gamma;beta],2),...
                p.proj{proj}.TP.prm{m}{6}{1}(:,i)) % gamma changed
            % save factors for all molecules using this method
            N = size(p.proj{proj}.TP.prm,2);
            for n = 1:N
                if p.proj{proj}.TP.prm{n}{6}{2}(i)==method(i)
                    p.proj{proj}.TP.prm{n}{6}{1}(:,i) = round([gamma;beta],2);
                    p.proj{proj}.TP.prm{n}{6}{4}(i,:) = prm{4}(i,:);

                    % reset discretized FRET data
                    p.proj{proj}.FRET_DTA(:,((n-1)*nFRET+1):n*nFRET) = NaN;
                end
            end
        end

    % cancelled by MH: FRET state sequences are already reset when panel
    % parameter gamma changes; this prevents the automatic re-discretization
    % although gamma does not change
    % else % manual
    %     % reset discretized FRET data
    %     p.proj{proj}.FRET_DTA(:,(m-1)*nFRET+1:m*nFRET) = NaN;
    end
end
