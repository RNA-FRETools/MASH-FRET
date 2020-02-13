function str = buildSExpr(D,A,K)
% str = buildSExpr(D,A,K);
%
% Return the expression of the Stoichiometry S_DA of a FRET pair composed of a donor D and an acceptor A in a network made of K emitters, in function of:
% - intensities I_ij collected in emitter i-specific detection channel upon emitter j-specific illumination, 
% - gamma factors gamma_ij of FRET pairs composed of a donor emitter i and an acceptor emitter j,
% - beta factor beta_DA of the specified FRET pair
%
% Emitter indexes are ordered according to their detection range: 1 for the most blue-shifted and K for the most red-shifted.
%
% "D":   donor emitter index in the FRET network 
% "A":   acceptor emitter index in the FRET network
% "K":   total number of emitters in the FRET network
% "str": expression of S_DA used for Stoichiometry calculations in MASH

% created by MH, 3.2.2020

if A<=D
    disp(cat(2,'no Stoichiometry expression found: acceptor index must be',...
        ' strictly higher than donor index.'));
    return
end

str = sprintf('1 / (1 + (I_%i%i',A,A);

for i = (A+1):K
    str = cat(2,str,sprintf(' + I_%i%i/gamma_%i%i',i,A,A,i));
end

str = cat(2,str,sprintf(') / (beta_%i%i*(I_%i%i',D,A,A,D));

for i = (D+1):(A-1)
    str = cat(2,str,sprintf(' + gamma_%i%i*I_%i%i',i,A,i,D));
end
for i = (A+1):K
    str = cat(2,str,sprintf(' + I_%i%i/gamma_%i%i',i,D,A,i));
end

str = cat(2,str,')))');

