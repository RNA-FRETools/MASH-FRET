function orgCoord = orgCoordCol(dat, mode, p, nChan, res_x, h_fig)

% Last update: 28th of March 2019 by Melodie Hadzic
% --> Review channel-specific coordinates sorting to allow import from
% identical x- and y- columns (ex: mapped coordinates in *.map file)

orgCoord = [];

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
    nCol = size(datNum,2);
end

nLine = size(dat,1);

switch mode
    case 'cw'
        hLines = p{2};
        if hLines>=nLine
            updateActPan(cat(2,'Number of lines in reference coordinates',...
                ' file is insufficient.\n\nYou may modify the number of ',...
                'header lines or change to row-wise structure in ',...
                'Coordinates transformation >> Options... >> Reference ',...
                'coordinates.'),h_fig, 'error');
            return;
        end
        datNum = datNum((hLines+1):end,:);
        
        x_col = p{1}(:,1);
        y_col = p{1}(:,2);
        
        for i = 1:nChan
            if x_col(i,1)>nCol || y_col(i,1)>nCol
                updateActPan(cat(2,'Number of columns in reference ',...
                    'coordinates file is insufficient.\n\nYou may modify ',...
                    'the column indexes of x- and y- coordinates or ',...
                    'change to row-wise structure in Coordinates ', ...
                    'transformation >> Options... >> Reference ',...
                    'coordinates.'),h_fig, 'error');
                return;
            end
            
            dat_i = datNum(:,[x_col(i,1) y_col(i,1)]);
            
            if isempty(dat_i)
                updateActPan(cat(2,'No reference coordinates are found ',...
                    'for channel ',num2str(i),'.\n\nYou may modify ',...
                    'the number of channel in panel Experiment settings ',...
                    'or change to row-wise structure in Coordinates ',...
                    'transformation >> Options... >> Reference ',...
                    'coordinates.'),h_fig, 'error');
                return;
            end
            
            orgCoord(:,2*i-1:2*i) = dat_i;
        end

    case 'rw'
        
        start_r = p{1}(:,1);
        iv_r = p{1}(:,2);
        stop_r = p{1}(:,3);
        x_col = p{2}(1);
        y_col = p{2}(2);
        
        if x_col>nCol || y_col>nCol
            updateActPan(cat(2,'Number of columns in reference ',...
                'coordinates file is insufficient.\n\nYou may modify the ',...
                'channel-specific column indexes or change to column-wise',...
                ' structure in Coordinates transformation >> Options... ',...
                '>> Reference coordinates.'),h_fig, 'error');
            return;
        end
        
        for i = 1:nChan
            if ~stop_r(i)
                stop_r(i) = size(dat,1);
            end
            if start_r(i)>nLine || stop_r(i)>nLine
                updateActPan(cat(2,'Number of lines in reference ',...
                    'coordinates file is insufficient.\n\nYou may modify ',...
                    'the row indexes where x- and y- coordinates are ',...
                    'written or change to column-wise structure in ',...
                    'Coordinates transformation >> Options... >> ',...
                    'Reference coordinates.'),h_fig, 'error');
                return;
            end
            
            dat_i = datNum(start_r(i):iv_r(i):stop_r(i),[x_col y_col]);
            
            if isempty(dat_i)
                updateActPan(cat(2,'No reference coordinates are found ',...
                    'for channel ',num2str(i),'.\n\nYou may modify ',...
                    'the number of channel in panel Experiment settings ',...
                    'or change to column-wise structure in Coordinates ',...
                    'transformation >> Options... >> Reference ',...
                    'coordinates.'),h_fig, 'error');
                return;
            end
            
           orgCoord(:,2*i-1:2*i) = dat_i;
        end
end

lim = [0 (1:nChan-1)*round(res_x/nChan) res_x];
orgCoord_i = cell(1,nChan);
for i = 1:nChan
    orgCoord_i{i} = orgCoord((orgCoord(:,2*i-1)>lim(i) & ...
        orgCoord(:,2*i-1)<lim(i+1)),2*i-1:2*i);
    sz_i = size(orgCoord_i{i},1);
end
min_sz = min(sz_i);
orgCoord = [];
for i = 1:nChan
    orgCoord = cat(2,orgCoord,orgCoord_i{i}(1:min_sz,:));
end

if isempty(orgCoord)
    updateActPan(cat(2,'No reference coordinates lay withtin the defined',...
        ' video dimensions.\n\nYou may modify the reference video ', ...
        'dimensions in Coordinates transformation >> Options... >> Video ',...
        'dimensions.'),h_fig, 'error');
    return;
end


