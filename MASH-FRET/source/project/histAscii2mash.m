function s = histAscii2mash(pname, fname, s, p, h_fig)

% defaults
bufferSz = 1e3;

row1 = p(1);
delim = p(2);
xcol = p(3);
pcol = p(4);

try
    % collects column-delimitation characters
    delimchar = collectsdelimchar(delim);
        
    % read file
    dat = [];
    f = fopen([pname fname], 'r');

    for line = 1:(row1-1)
        fgetl(f);
    end
    str = split(fgetl(f),delimchar)';
    excl = false(1,numel(str));
    for col = 1:numel(str)
        chars = unique(str{col});
        if numel(chars)==0 || (numel(chars)==1 && chars==' ')
            excl(col) = true;
        end
    end
    str(excl) = [];
    nCol = numel(str);
    frewind(f);

    for line = 1:row1
        fgetl(f);
    end
    scdat = reshape(fscanf(f,...
        ['%f',repmat(' %f',[1,nCol-1]),'\n'],nCol*bufferSz),nCol,...
        [])' ;
    while ~isempty(scdat)
        if ~isempty(dat) && size(scdat,2)~=size(dat,2)
            if size(scdat,2)<size(dat,2)
                scdat = cat(2,scdat,...
                    cell(1,size(dat,2)-size(scdat,2)));
            else
                dat = cat(2,dat,...
                    cell(size(dat,1),size(scdat,2)-size(dat,2)));
            end
        end
        dat = cat(1,dat,scdat);
        scdat = reshape(fscanf(f,...
            ['%f',repmat(' %f',[1,nCol-1]),'\n'],nCol*bufferSz),...
            nCol,[])' ;
    end
    fclose(f);

    % collects histogram data from file
    histdat = dat(:,[xcol,pcol]);
        
catch err
    loading_bar('close', h_fig);
    updateActPan(['An error occurred during processing of file: ' ...
        fname ':\n' err.message], h_fig, 'error');
    dispMatlabErr(err);
    s = [];
    return
end

s.folderRoot = pname;
s.sampling_time = 1;
s.spltime_from_video = false;
s.pix_intgr = [1 1]; % intgr. area dim. + nb of intgr pix

s.is_coord = false;
s.coord_file = []; 
s.coord_imp_param = []; 
s.coord = []; 
s.coord_incl = true;

s.hist_import_opt = p;
s.bool_intensities = [];
s.histdat = histdat;
s.FRET = [];
s.FRET_DTA = [];
s.FRET_DTA_import = [];
