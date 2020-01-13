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
nFRET = size(p.proj{proj}.FRET,1);
if nFRET<1
    return
end

prm = p.proj{proj}.prm{m}{6};
method = prm{2}(1);

if method==1 % photobleaching-based
    
    % collect molecule traces
    nC = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    incl = p.proj{proj}.bool_intensities(:,m);
    I_den = p.proj{proj}.intensities_denoise(incl,((m-1)*nC+1):m*nC,:);
    I_dta = p.proj{proj}.intensities_DTA(incl,((m-1)*nC+1):m*nC,:);
    prm_dta = p.proj{proj}.curr{m}{4};
    
    for i = 1:nFRET
        
        % check validity of previously calculated gamma (valid if donor and 
        % acceptor state sequences are preserved)
        don = p.proj{proj}.FRET(i,1);
        acc = p.proj{proj}.FRET(i,2);
        ldon = find(p.proj{proj}.excitations==p.proj{proj}.chanExc(don),1);
        if ~all(isnan(I_dta(:,[don,acc],ldon)))
            continue
        end

        [I_dta(:,[don,acc],ldon),stop,gamma,ok] = gammaCorr_pb(i,I_den,...
            prm{3}(i,2:5),prm_dta,p.proj{proj},h_fig);

        p.proj{proj}.prm{m}{6}{3}(i,6) = stop*nExc;

        % set method to "manual" if gamma calculation did not converge
        if ~ok
            p.proj{proj}.prm{m}{6}{2}(1) = 0;
            setContPan(cat(2,'photobleaching-based gamma factor could not',...
                ' be calculated: method is set to "manual" and gamma ',...
                'factor to previous value'),'warning',h_fig);

        elseif round(gamma,2)~=p.proj{proj}.prm{m}{6}{1}(1,i) % gamma changed
            % save gamma
            p.proj{proj}.prm{m}{6}{1}(1,i) = round(gamma,2);

            % reset discretized FRET data
            p.proj{proj}.FRET_DTA(:,(m-1)*nFRET+i) = NaN;
            
            % store D-A state sequences
            p.proj{proj}.intensities_DTA(incl,((m-1)*nC+1):m*nC,:) = I_dta;
        end
    end
    
elseif method==2 % ES linear regression
    
    prm = p.proj{proj}.prm{m}{6}{4};
    
    [ES,gamma,beta,ok,str] = gammaCorr_ES(p.proj{proj},prm,h_fig);

    if ~ok
        p.proj{proj}.prm{m}{6}{2}(1) = 0;
        setContPan(cat(2,str,': method is set to "manual" and gamma ',...
            'factor to previous value'),'warning',h_fig);

    elseif ~isequal(round([gamma;beta],2),p.proj{proj}.prm{m}{6}{1}) % gamma changed
        % save gamma
        p.proj{proj}.prm{m}{6}{1} = round([gamma;beta],2);

        % reset discretized FRET data
        p.proj{proj}.FRET_DTA(:,((m-1)*nFRET+1):m*nFRET) = NaN;

        % store ES histogram
        p.proj{proj}.ES = ES;
    end

% cancelled by MH: FRET state sequences are already reset when panel
% parameter gamma changes; this prevents the automatic re-discretization
% although gamma does not change
% else % manual
%     % reset discretized FRET data
%     p.proj{proj}.FRET_DTA(:,(m-1)*nFRET+1:m*nFRET) = NaN;
end
