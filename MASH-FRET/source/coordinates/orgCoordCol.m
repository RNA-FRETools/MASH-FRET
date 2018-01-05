function orgCoord = orgCoordCol(dat, mode, p, nChan, res_x)

if iscell(dat)
    n = size(dat,1);
    nCol = size(str2num(dat{end,1}),2);
    for i = 1:n
        l = str2num(dat{i,1});
        if ~isempty(l)
            datNum(i,1:nCol) = str2num(dat{i,1});
        else
            datNum(i,1:nCol) = 0;
        end
    end
else
    datNum = dat;
end

switch mode
    case 'cw'
        hLines = p{2};
        datNum = datNum((hLines+1):end,:);
        
        x_col = p{1}(:,1);
        y_col = p{1}(:,2);
        for i = 1:nChan
            orgCoord(:,2*i-1:2*i) = ...
                datNum(:,[x_col(i,1) y_col(i,1)]);
        end

    case 'rw'
        
        start_r = p{1}(:,1);
        iv_r = p{1}(:,2);
        stop_r = p{1}(:,3);
        x_col = p{2}(1);
        y_col = p{2}(2);
        for i = 1:nChan
            if ~stop_r(i)
                stop_r(i) = size(dat,1);
            end
           orgCoord(:,2*i-1:2*i) = ...
                datNum(start_r(i):iv_r(i):stop_r(i),[x_col y_col]);
        end
end

lim = [0 (1:nChan-1)*round(res_x/nChan) res_x];
for i = 1:nChan
    orgCoord = orgCoord((orgCoord(:,2*i-1)>lim(i) & ...
        orgCoord(:,2*i-1)<lim(i+1)),:);
end


