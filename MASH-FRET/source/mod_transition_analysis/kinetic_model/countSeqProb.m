function [TPmax,pos,cnf] = countSeqProb(seq,seq_ref,calcCnf)
% [cnt,pos,cnf] = countSeqProb(seq,seq_ref)
% 
% Compare the state sequence in seq to the larger state sequence in seq_ref, shifting the first frame of seq from the first to the last frame of seq_ref.
% The maximum number of true positives (TP), i.e., the number of values in seq that equals the values in seq_ref at same positions, is compared to a random sequence of the same length.
% The maximum number of TP, the corresponding position and the confidence interval are returned. 
%
% seq: experimental state sequence to match to the reference sequence
% seq_ref: larger reference state sequence
% calcCnf: true to calculate confidence (long comp. time), false otherwise
% TPmax: maximum number of true positive
% pos: index in seq_ref where the first value in seq was compared to, to obtain TPmax
% cnf: confidence (relative)

% default
S = 100;
cnf = [];

L = numel(seq);

% get maximum TP and optimum position
[TPmax,pos] = matchSeqWithRef(seq,seq_ref);

if calcCnf
    % compare max TP to S random sequences
    TPmax_rd = zeros(1,S);
    for s = 1:S
        seq_rd = randsample(unique(seq)',L,true);
        [TPmax_rd(s),~] = matchSeqWithRef(seq_rd,seq_ref);
    end

    % calculate relative confidence
    cnf = sum(TPmax>TPmax_rd)/S;
end


function [TPmax,pos] = matchSeqWithRef(seq,seq_ref)
% [TPmax,pos] = matchSeqWithRef(seq,seq_ref)
%
% Match values in seq to values in seq_ref shifting the first value in seq from the firs to the last value in seq_ref.
% Return maximum number of true positives (TP) with corresponding shift positon.
%
% TPmax: maximum number of TP
% pos: index in seq_ref where the first value in seq was compared to, to obtain TPmax

% get sequence lengths
L_ref = numel(seq_ref);
L = numel(seq);
TP = zeros(1,L_ref-L+1);

for l_ref = 1:(L_ref-L+1) % shift experimental sequence frame-wise
    subseq_ref = seq_ref(l_ref:(l_ref+L-1));
    for l = 1:L % counts TP
        if seq(l)==subseq_ref(l)
            TP(l_ref) = TP(l_ref)+1;
        end
    end
end
[TPmax,pos] = max(TP);% get max TP and corresponding shift position

