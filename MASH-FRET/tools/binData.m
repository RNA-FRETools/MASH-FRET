function binned = binData(data, bin_1, bin_0)

binned = [];

if bin_0>bin_1
    fprintf(['\nTime binning failed: exposure time in data is larger ' ...
        'than the input time binning.\n']);
    return
end

bin_l = bin_1/bin_0;
L_0 = size(data,1);
L_1 = fix(L_0/bin_l);

datSz = size(data);
binned = zeros([L_1,datSz(2:end)]);
l_1 = 1;
curs = 0;
while l_1<=L_1
    % determine l_0 from cursor position
    l_0 = ceil(curs);
    
    % remaining fraction of l_0 to consider for calculation
    if mod(curs,1)>0
        rest_0 = 1-mod(curs,1);
    else
        rest_0 = 0;
    end
    
    % add remaining fraction of l_0 in current l_1
    if l_0>0
        binned(l_1,:,:) = rest_0*data(l_0,:,:);
    end
    
    % remaining frames to add to l_1 to complete a bin
    bin_rest = bin_l-rest_0;
    
    % add full l_0 bins to l_1
    if l_0+fix(bin_rest)<= L_0
        binned(l_1,:,:) = binned(l_1,:,:) + ...
            sum(data(l_0+1:l_0+fix(bin_rest),:,:),1);
    else
        binned = binned(1:l_1-1,:,:);
        return
    end
    
    % add rest l_0 bins to l_1
    if l_0+fix(bin_rest)+1<= L_0
        binned(l_1,:,:) = binned(l_1,:,:) + ...
            (bin_rest-fix(bin_rest))*data(l_0+fix(bin_rest)+1,:,:);
    else
        binned = binned(1:l_1-1,:,:);
        return
    end
    
    % averaging
    binned(l_1,:,:) = binned(l_1,:,:)/bin_l;
    
    % advance cursor in orginial trajectory of one bin and l_1 of one frame
    curs = curs + bin_l;
    l_1 = l_1 + 1;
end
