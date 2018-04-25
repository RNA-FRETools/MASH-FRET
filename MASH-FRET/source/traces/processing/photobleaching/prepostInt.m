% get intensity before and after photobleaching of the acceptor fluorophore
% FS, last updated on 12.1.18

function p = prepostInt(h_fig, mol, p)

proj = p.curr_proj;
curr_mol = p.proj{proj}.curr{mol};
apply_pbGamma = curr_mol{5}{4}(1);
nChan = p.proj{proj}.nb_channel;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
stop = curr_mol{5}{5}(1,6);
chanExc = p.proj{proj}.chanExc;
excOrder = p.proj{proj}.excitations;
nExc = p.proj{proj}.nb_excitations;


% determine DTA intensities prior to and after the calculated cutoff
for i = 1:nFRET
    exc = find(excOrder == chanExc(FRET(i,1)));
    chan_D = FRET(i,1);
    chan_A = FRET(i,2);
    
    try
        I_pre = p.proj{proj}.intensities_DTA(stop/nExc-3, ...
            (mol-1)*nChan+1:mol*nChan,exc);
        I_post = p.proj{proj}.intensities_DTA(stop/nExc+3, ...
            (mol-1)*nChan+1:mol*nChan,exc);
        
        if I_pre(chan_D) ~= I_post(chan_D) % is donor intensity equal before and after the cutoff
            if apply_pbGamma
                gamma = (I_pre(chan_A)-I_post(chan_A))/(I_post(chan_D)-I_pre(chan_D));
                p.proj{proj}.curr{mol}{5}{3}(i) = round(gamma,2);
                
                p.proj{proj}.FRET_DTA(:,((mol-1)*nFRET+1):mol*nFRET) = NaN;
                p.proj{proj}.intensities_DTA(:,((mol-1)*nChan+1):mol*nChan,:) = NaN;
            end
            p.proj{proj}.curr{mol}{5}{5}(i,7) = 1; % donor intensities are different (-> check image)
        else
            p.proj{proj}.curr{mol}{5}{4}(1) = 0; % deactivate the pb based gamma corr checkbox
            p.proj{proj}.curr{mol}{5}{5}(i,7) = 0; % donor intensities are the same (-> cross image)
            %updateActPan('the donor intensity before and after the photobleaching cutoff is identical, cannot determine gamma factor, falling back to previous value', ...
            %    h_fig, 'error');
        end
    catch
        p.proj{proj}.curr{mol}{5}{4}(1) = 0; % deactivate the pb based gamma corr checkbox
        p.proj{proj}.curr{mol}{5}{5}(i,7) = 0; % donor intensities are the same (-> cross image)
    end
end

% equalize .prm (previous state) and .curr (current state) because not changed in edit field by manually clicking
% (would be managed by resetMol)
p.proj{proj}.prm{mol}{5}{3} = ...
    p.proj{proj}.curr{mol}{5}{3};
p.proj{proj}.prm{mol}{5}{4} = ...
    p.proj{proj}.curr{mol}{5}{4};

end
