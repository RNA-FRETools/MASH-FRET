function str = buildFretExpr(D,A,K)
% str = buildFretExpr(D,A,K);
%
% Return the expression of the apparent FRET E_DA from a donor D to an 
% acceptor A in a network made of K emitters, in function of intensities
% I_kem_Dex collected in each of the K emitter-specific detection channels 
% upon D-specific illumination, and in function of other apparent FRET
% values.
%
% "D": donor emitter index in the FRET network (1: most blue-shifted 
%      emitter, K: most red-shited)
% "A": acceptor emitter indes in the FRET network
% "K": total number of emitters in the FRET network

% created by MH, 1.4.2019

if A<=D
    disp(cat(2,'no FRET expression found: acceptor index must be strictly',...
        ' higher than donor index.'));
    return
end

str = cat(2,'E_',num2str(D),num2str(A),sprintf(' = I_%iem_%iex',A,D));

str = cat(2,str,' / ');

for i = A+1:K
    if i==A+1
        str = cat(2,str,'(1');
    end
    str = cat(2,str,' - E_',num2str(A),num2str(i));
    if i==K
        str = cat(2,str,')');
    end
end

for i = D:K
    if i==D
        str = cat(2,str,'*(');
    end
    str = cat(2,str,sprintf('I_%iem_%iex',i,D));
    if i<K
        str = cat(2,str,' + ');
    else
        str = cat(2,str,')');
    end
end

for i = D+1:A-1
    if i==D+1
        str = cat(2,str,' - (');
    end
    str = cat(2,str,'E_',num2str(D),num2str(i));
    for j = i+1:A
        if j==i+1
            str = cat(2,str,'*(');
        end
        str = cat(2,str,'E_',num2str(i),num2str(j));
        for k = j+1:A
            str = cat(2,str,'*E_',num2str(j),num2str(k));
        end
        if j<A
            str = cat(2,str,' + ');
        else
            str = cat(2,str,')');
        end
    end
    if i<A-1
        str = cat(2,str,' + ');
    else
        str = cat(2,str,')');
    end
end

