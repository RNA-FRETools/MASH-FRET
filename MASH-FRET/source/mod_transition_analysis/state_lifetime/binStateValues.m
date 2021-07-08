function [val,js] = binStateValues(mu,bin,j1j2)
% [mu,js] = binStateValues(mu,bin,j1j2)
%
% Bin values contained in "mu" with a binning "bin". Return binned values in "val" and indexes of raw values in "js".
%
% mu: [n-by-m] values to bin
% bin: bin size
% j1j2: [n-by-m] indexes corresponding to values in mu
% val: [1-by-nVal] binned values
% js: {1-by-nVal} indexes of raw values that were binned

mu = mu(:);
j1j2 = j1j2(:);
[val,~,~] = unique(mu);

over = 0;
newVal = val;
while ~over
    over = 1;
    for v = 1:size(val,1)
        [r1,~,~] = find(val~=val(v,1) & val>=(val(v,1)-bin) & ...
            val<=(val(v,1)+bin));
        if ~isempty(r1)
            newVal(v,1) = mean([val(v,1);val(r1',1)]);
            [r,~,~] = find(mu==val(v,1));
            mu(r',1) = newVal(v,1);
            over = 0;
        end
    end
    [val,~,~] = unique(mu);
end

V = size(val,1);
js = cell(1,V);
for v = 1:V
    js{v} = unique(j1j2(mu==val(v,1)));
end



