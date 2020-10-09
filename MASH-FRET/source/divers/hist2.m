function [zout,xiv,yiv,coord] = hist2(varargin)

switch size(varargin,2)
    
    case 1
        xy = varargin{1};
        if size(xy,2)==2 || size(xy,1)==2
            if size(xy,2)<size(xy,1) 
                xy = xy(:,[1 2])';
            end
        else
            error(['hist2: first input argument must be [N-by-2] or ' ...
                '[2-by-N] data matrix.']);
        end
        xiv = linspace(min(xy(1,:)),max(xy(1,:)),11);
        yiv = linspace(min(xy(2,:)),max(xy(2,:)),11);
        
    case 2
        xy = varargin{1};
        ivprm = varargin{2};
        
        if size(xy,2)==2 || size(xy,1)==2
            if size(xy,2)<size(xy,1)
                xy = xy(:,[1 2])';
            end
        else
            error(['hist2: first input argument must be [N-by-2] or ' ...
                '[2-by-N] data matrix.']);
        end
        if numel(ivprm)==2
            nbin_x = ivprm(1);
            nbin_y = ivprm(2);
            xiv = linspace(min(xy(1,:)),max(xy(1,:)),nbin_x+1);
            yiv = linspace(min(xy(2,:)),max(xy(2,:)),nbin_y+1);
            
        elseif size(ivprm,2)==2 || size(ivprm,1)==2
            if size(ivprm,2)>size(ivprm,1)
                xiv = ivprm(1,:);
                yiv = ivprm(2,:);
            else
                xiv = ivprm(:,1)';
                yiv = ivprm(:,2)';
            end
            
        else
            error(['hist2: second input argument must be [N-by-2] or ' ...
                '[2-by-N] binning matrix or [1-by-2] number of bins ' ...
                'vector.']);
        end
        
    case 3
        xy = varargin{1};
        xiv = varargin{2};
        yiv = varargin{3};
        
        if size(xy,2)==2 || size(xy,1)==2
            if size(xy,2)<size(xy,1)
                xy = xy(:,[1 2])';
            end
        else
            error(['hist2: first input argument must be [N-by-2] or ' ...
                '[2-by-N] data matrix.']);
        end
        if size(xiv,2)==1 || size(xiv,1)==1
            if size(xiv,2)<size(xiv,1)
                xiv = xiv(:,1)';
            end
        end
        if size(yiv,2)==1 || size(yiv,1)==1
            if size(yiv,2)<size(yiv,1)
                yiv = yiv(:,1)';
            end
        end
        
    otherwise
        error('hist2: wrong number of input arguments.');
end

[vals,o,o] = unique(xy','rows');

coord = zeros(size(xy,2),2);

zout = zeros(size(yiv,2)-1,size(xiv,2)-1);

for v = 1:size(vals,1)
    [o,yinf] = find(yiv<vals(v,2));
    [o,xinf] = find(xiv<vals(v,1));
    
    [o,id,o] = find(xy(1,:)==vals(v,1) & xy(2,:)==vals(v,2));
    P = numel(id);

    if ~isempty(xinf) && ~isempty(yinf) && yinf(end)<size(yiv,2) && ...                
            xinf(end)<size(xiv,2)
        zout(yinf(end),xinf(end)) = zout(yinf(end),xinf(end)) + P;
        coord(id,[1 2]) = repmat([xinf(end) yinf(end)],numel(id),1);
    end
end

