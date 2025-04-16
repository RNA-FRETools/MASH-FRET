function data = binData(data0, bin, bin0, timeCols, frameCols)

data = [];

if bin0>bin
    fprintf(['\nTime binning failed: exposure time in data is larger ' ...
        'than the input time binning.\n']);
    return
end

% determine trace length after binning
binRatio = bin/bin0;
L0 = size(data0,1);
binedg = 0:binRatio:L0;
if (L0-binedg(end-1))<binRatio
    binedg(end) = [];
end
L = numel(binedg)-1;

firstTimePoint = sort(unique(data0(1,timeCols)));
nExc = numel(firstTimePoint);
nTimeCols = numel(timeCols);
for col = 1:nTimeCols
    
    % % determine laser position associated to current time column
    % laserOrder = find(firstTimePoint==data0(1,timeCols(col)));
    
    % % determine trace length after binning
    % binedg = [((laserOrder-1)*binRatio/nExc),...
    %     (laserOrder*binRatio/nExc):binRatio:L0];

    % get column indexes associated to current time column
    if col<nTimeCols
        datCols = (min([timeCols(col),frameCols(col)])):...
            (min([timeCols(col+1),frameCols(col+1)])-1);
    else
        datCols = (min([timeCols(col),frameCols(col)])):size(data0,2);
    end
    dat_t = data0(:,datCols);
    datBin_t = zeros(L,size(dat_t,2));
    t_col = find(datCols==timeCols(col),1);
    l_col = find(datCols==frameCols(col),1);
    d_col = 1:size(dat_t,2);
    d_col([t_col,l_col]) = [];
    
    % start binning
    curs = binedg(1);
    l_1 = 1;
    while l_1<=L
        % determine l_0 from cursor position
        l_0 = ceil(curs);

        % remaining fraction of l_0 to consider for calculation
        if l_1>1
            rest_0 = 1-mod(curs,1);
            % add remaining fraction of l_0 in current l_1
            datBin_t(l_1,d_col,:) = rest_0*dat_t(l_0,d_col,:);
        else
            rest_0 = 0;
        end
        
        % write time and frame
        datBin_t(l_1,t_col,:) = (curs+binRatio/nExc)*bin0;
        datBin_t(l_1,l_col,:) = curs+binRatio/nExc;

        % remaining frames to add to l_1 to complete a bin
        bin_rest = binRatio-rest_0;

        % add full l_0 bins to l_1
        if (l_0+fix(bin_rest))<=L0
            datBin_t(l_1,d_col,:) = datBin_t(l_1,d_col,:) + ...
                sum(dat_t((l_0+1):(l_0+fix(bin_rest)),d_col,:),1);
        else
            datBin_t = datBin_t(1:l_1-1,:,:);
            L = L-1;
            break
        end

        % add rest l_0 bins to l_1
        if (l_0+fix(bin_rest)+1)<=L0
            datBin_t(l_1,d_col,:) = datBin_t(l_1,d_col,:) + ...
                (bin_rest-fix(bin_rest))*dat_t(l_0+fix(bin_rest)+1,d_col,:);
        else
            datBin_t = datBin_t(1:l_1-1,:,:);
            L = L-1;
            break
        end

        % advance cursor in orginial trajectory of one bin and l_1 of one frame
        curs = curs + binRatio;
        l_1 = l_1 + 1;
    end
    
    if ~isempty(data) && size(data,1)<size(datBin_t,1)
        datBin_t = datBin_t(1:size(data,1),:);
    elseif ~isempty(data) && size(data,1)>size(datBin_t,1)
        data = data(1:size(datBin_t,1),:);
    elseif isempty(data)
        data = zeros(size(datBin_t,1),size(data0,2));
    end
    data(:,datCols) = datBin_t;
end
