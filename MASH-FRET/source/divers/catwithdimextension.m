function dat = catwithdimextension(d0,dat1,dat2,varargin)
% dat = catwithdimextension(d,dat1,dat2)
% dat = catwithdimextension(d,dat1,dat2,c)
%
% Concatenate two arrays according to input dimension and extending array
% sizes for compatibility, filling missing data with NaN or c.
%
% d: concatenated dimension
% dat1: [R1-by-C1-by-Z1-by-...] first array
% dat2: [R2-by-C2-by-Z2-by-...] second array
% c: number to fill missing data

% defaults
c = NaN; % fill missing data with this

% collect input
if ~isempty(varargin)
    c = varargin{1};
end

% determine maximum array dimensions
sz1 = size(dat1);
D1 = numel(sz1);
sz2 = size(dat2);
D2 = numel(sz2);
D = max([D1,D2]);
sz1 = [sz1,ones(1,D-D1)];
sz2 = [sz2,ones(1,D-D2)];

% extend array dimensions to maximum array sizes
alldat = {dat1,dat2};
for d = 1:D
    if d==d0 || sz1(d)==sz2(d)
        continue
    end
    maxsz = max([sz1(d),sz2(d)]);
    [~,arrid] = min([sz1(d),sz2(d)]);
    
    newsz = size(alldat{arrid});
    newsz(d) = maxsz-size(alldat{arrid},d);
    
    alldat{arrid} = cat(d,alldat{arrid},repmat(c,newsz));
end

dat = cat(d0,alldat{1},alldat{2});
