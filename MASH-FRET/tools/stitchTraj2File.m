function stitchTraj2File()
% stitchTraj2File()
%
% Concatenate trajectory text files exported from MASH-FRET for the same 
% molecule index.
% This is used when successive video files were recorded and respective 
% trajectories need to be stitched one with another to obtain the 
% trajectories with full recording length.
% Molecule index m is read from file name '_mol[m]of[M].txt'.

% request source dir
src = uigetdir(pwd,'Select trajectory directory');

% check existence of source dir
if ~exist(src,'dir')
    return
end

% propup source dir
if src(end)~=filesep
    src = [src,filesep];
end

% list all traj files in source dir
flist = dir([src,'*.txt']);
F = size(flist,1);

% collect all molecule indexes and associated traj files
mols = [];
fmols = {};
disp('stitchTraj2File: collecting molecule files...');
for f = 1:F
    [~,fname,~] = fileparts(flist(f).name);
    fparts = split(fname,'_');
    mdat = sscanf(fparts{end},'mol%iof%i');
    if ~any(mols==mdat(1))
        mols = cat(2,mols,mdat(1));
        fmols = cat(2,fmols,{{}});
        fmols{end} = ...
            cat(2,fmols{end},[flist(f).folder,filesep,flist(f).name]);
    else
        m = find(mols==mdat(1),1);
        fmols{m} = ...
            cat(2,fmols{m},[flist(f).folder,filesep,flist(f).name]);
    end
end

% make destination dir
dest = [src,'stitched-traj',filesep];
if exist(dest,'dir')
    delete([dest,'*']);
    rmdir(dest);
end
mkdir(dest);

% merge traj files for each molecule
M = numel(mols);
for m = 1:M
    fprintf(['stitchTraj2File: stitching trajectories for molecule ',...
        '%i (%i/%i)...\n'],mols(m),m,M);
    Fm = numel(fmols{m});
    for fm = 1:Fm
        % read file data
        fdat = importdata(fmols{m}{fm});
        datfm = fdat.data;
        hdfm = fdat.textdata;
        if fm==1
            % defines reference headers from first file
            hd0 = hdfm;
            
            % initializes concatenated data
            datm = datfm;
            continue
        end
        
        % identifies data headers
        nHd0 = numel(hd0);
        excl = false(1,nHd0);
        ord = zeros(1,nHd0);
        for n0 = 1:nHd0
            if ~any(contains(hdfm,hd0{n0}))
                excl(n0) = true;
                disp(['header ',hd0{n0},' was not found in file ',...
                    fmols{m}{fm}]);
                continue
            end
            ord(n0) = find(strcmp(hd0{n0},hdfm),1);
        end
        
        % delete unfound headers
        ord(excl) = [];
        hd0(excl) = [];
        datm(:,excl) = [];
        
        % concatenates data for current molecule
        datm = cat(1,datm,datfm(:,ord(~excl)));
    end
    
    % adjust time and frame axis
    coltime = find(contains(hd0,'time'));
    colframe = find(contains(hd0,'frame'));
    L = size(datm,1);
    for c = coltime
        t0 = datm(1,c);
        expt = datm(2,c)-datm(1,c);
        datm(:,c) = t0:expt:(t0+(L-1)*expt);
    end
    for c = colframe
        frame0 = datm(1,c);
        df = datm(2,c)-datm(1,c);
        datm(:,c) = frame0:df:(frame0+(L-1)*df);
    end
    
    % write concatenated data to file
    [~,fname,fext] = fileparts(fmols{m}{1});
    fid = fopen([dest,fname,fext],'Wt');
    strhd = '';
    for n0 = 1:numel(hd0)
        strhd = cat(2,strhd,hd0{n0},'\t');
    end
    strhd(end) = 'n';
    fprintf(fid,strhd);
    fprintf(fid,[repmat('%d\t',1,size(datm,2)-1),'%d\n'],datm');
    fclose(fid);
end

disp('stitchTraj2File: process completed!');
