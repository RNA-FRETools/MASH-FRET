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

if sum(j1==[0,1]) % frame-wise data
    if ~sum(j2==[0,1])
        return
    end
end
if sum(j1==(2:8)) % molecule-wise
    if ~sum(j2==(2:8))
        return
    end
end
if sum(j1==(9:10)) % state-wise
    if ~sum(j2==(9:10))
        return
    end
    if ind1~=ind2
        return
    end
end

ok = true;
