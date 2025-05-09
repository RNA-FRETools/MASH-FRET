function ok = checkXYdataCoherence(indx,indy,jx,jy)

ok = false;

if ~checkCoherence(indx,indy,jx,jy)
    return
end
if ~checkCoherence(indy,indx,jy,jx)
    return
end

ok = true;


function ok = checkCoherence(ind1,ind2,j1,j2)

ok = false;

if sum(j1==getASdataindex('framewise')) % frame-wise data
    if ~sum(j2==getASdataindex('framewise'))
        return
    end
end
if sum(j1==getASdataindex('molwise')) % molecule-wise
    if ~sum(j2==getASdataindex('molwise'))
        return
    end
end
if sum(j1==getASdataindex('statewise')) % state-wise
    if ~sum(j2==getASdataindex('statewise'))
        return
    end
    if ind1~=ind2
        return
    end
end

ok = true;
