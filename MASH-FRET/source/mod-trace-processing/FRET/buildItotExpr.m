function str = buildItotExpr(em,K)
% str = buildItotExpr(em,K);
%
% Return the expression of the total donor intensity I0 of an emitterin a network made of of K emitters, in function of:
% - intensities I_ij collected in emitter i-specific detection channel upon emitter j-specific illumination, 
% - gamma factors gamma_ij of FRET pairs composed of a donor emitter i and an acceptor emitter j,
% Emitter indexes are ordered according to their detection range: 1 for the most blue-shifted and K for the most red-shifted.
%
% "em":  emitter index in the FRET network 
% "K":   total number of emitters in the FRET network
% "str": expression of I0 used for total intensity calculations in MASH

% created by MH, 3.2.2020

str = sprintf('I_%i%i',em,em);

for i = 1:(em-1)
    str = cat(2,str,sprintf(' + gamma_%i%i*I_%i%i',i,em,i,em));
end
for i = (em+1):K
    str = cat(2,str,sprintf(' + I_%i%i/gamma_%i%i',i,em,em,i));
end

