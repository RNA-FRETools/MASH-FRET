function p = gammaCorr(h_fig, mol, p)
% MH, last update 27.3.2019

proj = p.curr_proj;
prm = p.proj{proj}.prm{mol}{5};
pbGamma = prm{4}(1);

if pbGamma
    
    FRET = p.proj{proj}.FRET;
    nExc = p.proj{proj}.nb_excitations;
    nChan = p.proj{proj}.nb_channel;
    nFRET = size(p.proj{proj}.FRET,1);
    chanExc = p.proj{proj}.chanExc;
    exc = p.proj{proj}.excitations;
    
    % collect molecule traces
    I_den = p.proj{proj}.intensities_denoise(:, ...
        ((mol-1)*nChan+1):mol*nChan,:);
    
    for i = 1:nFRET
        
        % collect donor and acceptor intensity traces
        acc = FRET(i,2); % the acceptor channel
        don = FRET(i,1);
        I_A = I_den(:,acc,exc==chanExc(don));
        I_D = I_den(:,don,exc==chanExc(don));
        
        % calculate and save cutoff on acceptor trace
        stop = calcCutoffGamma(prm{5}(i,2:5),I_A,nExc);
        p.proj{proj}.prm{mol}{5}{5}(i,6) = stop*nExc;
        
        % calculate gamma
        [gamma,ok] = prepostInt(stop, I_D, I_A);
        
        if round(gamma,2) ~= p.proj{proj}.prm{mol}{5}{3}(i) % gamma changed
            % save gamma
            p.proj{proj}.prm{mol}{5}{3}(i) = round(gamma,2);
        
            % reset discretized FRET data
            p.proj{proj}.FRET_DTA(:,(mol-1)*nFRET+i) = NaN;
        end
        
    end
end
