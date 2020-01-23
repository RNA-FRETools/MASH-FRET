function [isdiscr,str] = controlDiscrForAS(ind, p_proj)

chanExc = p_proj.chanExc;
exc = p_proj.excitations;
nChan = p_proj.nb_channel;
nExc = p_proj.nb_excitations;
nFRET = size(p_proj.FRET,1);
nS = size(p_proj.S,1);
nI0 = sum(chanExc>0);

str = '';

n = 0;
if ind<=nChan*nExc % intensities
    for l = 1:nExc
        for c = 1:nChan
            n = n+1;
            if n==ind
                break
            end
        end
    end
    discr = p_proj.intensities_DTA(:,c:nChan:end,l);

    str = 'top';
    
elseif ind<=(nChan*nExc+nI0) % intensities
    for c = 1:nChan
        if chanExc(c)==0
            continue
        end
        n = n+1;
        if n==(ind-nChan*nExc)
            break
        end
    end
    l = find(exc==chanExc(c),1);
    discr = p_proj.intensities_DTA(:,:,l);

    str = 'top';

elseif ind<=(nChan*nExc+nI0+nFRET) % FRET
    n = ind-(nChan*nExc+nI0);
    discr = p_proj.FRET_DTA(:,n:nFRET:end);
    
    str = 'bottom';

elseif ind<=(nChan*nExc+nI0+nFRET+nS) % stoichiometries
    n = ind-(nChan*nExc+nI0+nFRET);
    discr = p_proj.S_DTA(:,n:nS:end);
    
    str = 'bottom';
end

isdiscr = ~all(isnan(sum(sum(discr,3),2)));
