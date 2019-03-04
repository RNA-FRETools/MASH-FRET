function [data,ok] = readCrd(fullname, h_fig)

ok = 0;
data = [];

[pname,fname,fext] = fileparts(fullname);

if ~(strcmp(fext,'.spots') || strcmp(fext,'.crd') || strcmp(fext,'.coord'))
    return;
end

nheadl = 1;

if ~isempty(fname) && sum(fname)
    cd(pname);
    fData = importdata(fullname, '\n');

    nCol = size(str2num(fData{nheadl+1,1}),2);
    
    if strcmp(fext,'.spots')
        col_x = 1;
        col_y = 2;
    elseif strcmp(fext,'.crd') || strcmp(fext,'.coord')
        col_x = 1:2:nCol;
        col_y = 2:2:nCol;
    end
    
    nLines = size(fData,1)-nheadl;
    coord = [];
    for i = 1+nheadl:nLines
        l = str2num(fData{i,1});
        if ~isempty(l)
            coord = [coord; l(:,[col_x col_y])];
        end
    end
    coord = [reshape(coord(:,1:numel(col_x)), ...
        [numel(coord(:,1:numel(col_x))),1]) ...
        reshape(coord(:,numel(col_x)+1:2*numel(col_x)), ...
        [numel(coord(:,numel(col_x)+1:2*numel(col_x))),1])];
    
    if isempty(coord)
        ok = 0;
        if ~isempty(h_fig)
            updateActPan(['No coordinates imported:\nWrong file ' ...
                'structure.'], h_fig, 'error');
        else
            disp('No coordinates imported:\nWrong file structure.');
        end
        return;
    end
    
    extrmX = [0, max(ceil(max(coord(:,1))))+1];
    extrmY = [0, max(ceil(max(coord(:,2))))+1];
    
    x = extrmX(1):extrmX(2);
    y = extrmY(1):extrmY(2);
    [mat,o,o,o] = hist2(coord,x,y);
    
end

data = struct('cycleTime', 1, ...
              'pixelY', size(mat,1), ...
              'pixelX', size(mat,2), ...
              'frameLen', 1, ...
              'fCurs', [], ...
              'frameCur', mat, ...
              'movie', mat);
ok = 1;

          