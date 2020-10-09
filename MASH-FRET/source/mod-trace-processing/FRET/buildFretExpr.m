function str = buildFretExpr(D,A,K)
% str = buildFretExpr(D,A,K);
%
% Return the expression of the FRET value E_DA of a FRET pair composed of a donor D and an acceptor A in a network made of K emitters, in function of:
% - intensities I_ij collected in emitter i-specific detection channel upon emitter j-specific illumination, 
% - FRET values E_ij of FRET pairs composed of a donor emitter i and an acceptor emitter j,
% - gamma factors gamma_ij of FRET pairs composed of a donor emitter i and an acceptor emitter j
%
% Emitter indexes are ordered according to their detection range: 1 for the most blue-shifted and K for the most red-shifted.
%
% "D":   donor emitter index in the FRET network 
% "A":   acceptor emitter index in the FRET network
% "K":   total number of emitters in the FRET network
% "str": expression of E_DA used for FRET calculation in MASH

% created by MH, 1.4.2019

if A<=D
    disp(cat(2,'no FRET expression found: acceptor index must be strictly',...
        ' higher than donor index.'));
    return
end

str = sprintf('1 / (1 + gamma_%i%i*I_%i%i / (I_%i%i',D,A,D,D,A,D);

for i = A+1:K
    if i==A+1
        str = cat(2,str,'*(1');
    end
    str = cat(2,str,sprintf(' + E_%i%i/(1 - E_%i%i)',A,i,A,i));
    if i==K
        str = cat(2,str,')');
    end
end

for i = D+1:A-1
    str = cat(2,str,sprintf(...
        ' - gamma_%i%i*I_%i%i*E_%i%i/(1 - E_%i%i)',i,A,i,D,i,A,i,A));
end

str = cat(2,str,'))');

