function [I2D,id] = collectintfor2Ddiscr(FRET,S,exc,chanExc,I0)
% I2D = collectintfor2Ddiscr(FRET,S,exc,chanExc,I0)
%
% Calculates couples of intensity trajectories used for 2D discretization.
%
% FRET: [nF-by-2] indexes of FRET-paired channels (donor,acceptor)
% S: [nS-by-2] indexes of FRET-paired channels for stoichiometry
%    calculations (donor,acceptor)
% exc: [1-by-nExc] laser wavelengths
% chanExc: [1-by-nChan] laser indexes for direct emitter excitation
% I0: [L-by-nChan-by-nExc] intensity trajectories
% I2D: {1-by-nF+nS}[2-by-L] couples of intensity trajectories
% id: [nF+nS-by-4] channels and laser indexes

nF = size(FRET,1);
nS = size(S,1);
nChan = numel(chanExc);
I2D = cell(1,nF+nS);
id = cell(1,nF+nS);

for n = 1:nF
    % identify donor and acceptor discretized intensity-time 
    % traces
    don = FRET(n,1); acc = FRET(n,2);
    [~,l_f,~] = find(exc==chanExc(FRET(n,1)));
    I2D{n} = [I0(:,don,l_f)';I0(:,acc,l_f)'];
    for c = 1:size(I2D{n},1)
        I2D{n}(c,:) = (I2D{n}(c,:)-mean(I2D{n}(c,:)))/std(I2D{n}(c,:));
    end
    id{n} = [don,l_f;acc,l_f];
end

for n = 1:nS
    % identify donor and acceptor discretized intensity-time 
    % traces
    [~,ldon,~] = find(exc==chanExc(S(n,1)));
    [~,lacc,~] = find(exc==chanExc(S(n,2)));
    don0 = sum(I0(:,:,ldon),2);
    acc0 = sum(I0(:,:,lacc),2);
    I2D{nF+n} = [don0';acc0'];
    for c = 1:size(I2D{n},1)
        I2D{nF+n}(c,:) = (I2D{nF+n}(c,:)-mean(I2D{nF+n}(c,:)))/...
            std(I2D{nF+n}(c,:));
    end
    id{nF+n} = [(1:nChan)',ones(nChan,1)*ldon;...
        (1:nChan)',ones(nChan,1)*lacc];
end
