function [zout,xin,yin,coord] = hist2(varargin)

switch size(varargin,2)
    
    case 1
        if size(varargin{1},2)==2 || size(varargin{1},1)==2
            if size(varargin{1},2)>size(varargin{1},1)
                xy = varargin{1};
            else
                xy = varargin{1}(:,[1 2])';
            end
        else
            error(['hist2: first input argument must be [N-by-2] or ' ...
                '[2-by-N] data matrix.']);
        end
        xin = linspace(min(xy(1,:)),max(xy(1,:)),11);
        yin = linspace(min(xy(2,:)),max(xy(2,:)),11);
        
    case 2
        if size(varargin{1},2)==2 || size(varargin{1},1)==2
            if size(varargin{1},2)>size(varargin{1},1)
                xy = varargin{1};
            else
                xy = varargin{1}(:,[1 2])';
            end
        else
            error(['hist2: first input argument must be [N-by-2] or ' ...
                '[2-by-N] data matrix.']);
        end
        if numel(varargin{2})==2
            nbin_x = varargin{1}(1);
            nbin_y = varargin{1}(2);
            xin = linspace(min(xy(1,:)),max(xy(1,:)),nbin_x+1);
            yin = linspace(min(xy(2,:)),max(xy(2,:)),nbin_y+1);
            
        elseif size(varargin{2},2)==2 || size(varargin{2},1)==2
            if size(varargin{2},2)>size(varargin{2},1)
                xin = varargin{2}(1,:);
                yin = varargin{2}(2,:);
            else
                xin = varargin{2}(:,1)';
                yin = varargin{2}(:,2)';
            end
            
        else
            error(['hist2: second input argument must be [N-by-2] or ' ...
                '[2-by-N] binning matrix or [1-by-2] number of bins ' ...
                'vector.']);
        end
        
    case 3
        if size(varargin{1},2)==2 || size(varargin{1},1)==2
            if size(varargin{1},2)>size(varargin{1},1)
                xy = varargin{1};
            else
                xy = varargin{1}(:,[1 2])';
            end
        else
            error(['hist2: first input argument must be [N-by-2] or ' ...
                '[2-by-N] data matrix.']);
        end
        
        if size(varargin{2},2)==1 || size(varargin{2},1)==1
            if size(varargin{2},2)>size(varargin{2},1)
                xin = varargin{2}(1,:);
            else
                xin = varargin{2}(:,1)';
            end
        end
        if size(varargin{3},2)==1 || size(varargin{3},1)==1
            if size(varargin{3},2)>size(varargin{3},1)
                yin = varargin{3}(1,:);
            else
                yin = varargin{3}(:,1)';
            end
        end
        
    otherwise
        error('hist2: wrong number of input arguments.');
end

[vals,o,o] = unique(xy','rows');

coord = zeros(size(xy,2),2);

zout = zeros(size(yin,2)-1,size(xin,2)-1);

for v = 1:size(vals,1)
    [o,yinf] = find(yin<vals(v,2));
    [o,xinf] = find(xin<vals(v,1));
    
    [o,id,o] = find(xy(1,:)==vals(v,1) & xy(2,:)==vals(v,2));
    P = numel(id);

    if ~isempty(xinf) && ~isempty(yinf) && yinf(end)<size(yin,2) && ...                
            xinf(end)<size(xin,2)
        zout(yinf(end),xinf(end)) = zout(yinf(end),xinf(end)) + P;
        coord(id,[1 2]) = repmat([xinf(end) yinf(end)],numel(id),1);
    end
end

