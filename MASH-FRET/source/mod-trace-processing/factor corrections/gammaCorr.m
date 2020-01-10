function p = gammaCorr(h_fig, mol, p)

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
prm = p.proj{proj}.prm{mol}{6};
pbGamma = prm{2}(1);
nFRET = size(p.proj{proj}.FRET,1);

if pbGamma
    
    FRET = p.proj{proj}.FRET;
    nExc = p.proj{proj}.nb_excitations;
    nChan = p.proj{proj}.nb_channel;
    chanExc = p.proj{proj}.chanExc;
    exc = p.proj{proj}.excitations;
    
    % collect molecule traces
    I_den = p.proj{proj}.intensities_denoise(:, ...
        ((mol-1)*nChan+1):mol*nChan,:);
    I_DTA = p.proj{proj}.intensities_DTA(:, ...
        ((mol-1)*nChan+1):mol*nChan,:);
    
    % set method to "manual" if no intensity discretization is found
    
    % modified by MH, 2.4.2019
    % corrected by MH, 8.4.2019
%     if sum(isnan(I_DTA))
    if all(all(isnan(I_DTA)))
        
        setContPan(cat(2,'intensity-time traces must be discretized to ',...
            'apply photobleaching-based gamma factor calculation: method ',...
            'is set to "manual" and gamma factor to previous value.'),...
            'warning',h_fig);
        p.proj{proj}.prm{mol}{5}{4}(1) = 0;
        return;
    end
    
    for i = 1:nFRET
        
        % collect donor and acceptor intensity traces
        acc = FRET(i,2); % the acceptor channel
        don = FRET(i,1);
        I_AA = I_den(:,acc,exc==chanExc(acc));
        
        % calculate and save cutoff on acceptor trace
        stop = calcCutoffGamma(prm{3}(i,2:5),I_AA,nExc);
        p.proj{proj}.prm{mol}{6}{3}(i,6) = stop*nExc;
        
        I_DTA_A = I_DTA(:,acc,exc==chanExc(don));
        I_DTA_D = I_DTA(:,don,exc==chanExc(don));
        
        % calculate gamma
        [gamma,ok] = prepostInt(stop, I_DTA_D, I_DTA_A);
        
        % set method to "manual" if gamma calculation did not converge
        if ~ok
            p.proj{proj}.prm{mol}{6}{2}(1) = 0;
            setContPan(cat(2,'photobleaching-based gamma factor could not be ',...
                'calculated: method is set to "manual" and gamma factor ',...
                'to previous value'),'warning',h_fig);
            
        elseif round(gamma,2) ~= p.proj{proj}.prm{mol}{6}{1}(i) % gamma changed
            % save gamma
            p.proj{proj}.prm{mol}{6}{1}(i) = round(gamma,2);
        
            % reset discretized FRET data
            p.proj{proj}.FRET_DTA(:,(mol-1)*nFRET+i) = NaN;
        end
        
    end
else
    % reset discretized FRET data
    p.proj{proj}.FRET_DTA(:,(mol-1)*nFRET+1:mol*nFRET) = NaN;
end
