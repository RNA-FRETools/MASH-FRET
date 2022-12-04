function checkMASHmex()

% compile molecule localization method Schmied2012
if exist('forloop','file')~=3
    cd(fileparts(which('forloop.c')));
    try
        mex('forloop.c');
    catch err
        dispMatlabErr(err);
    end
end

% compile image filters
% if exist('FilterArray','file')~=3
%     pname = fileparts(which('FilterArray.c'));
%     % set runtime library path for LINUX
%     if strcmp(computer,'GLNXA86') || strcmp(computer,'GLNXA64')
%         system(['LD_LIBRARY_PATH=$LD_LIBRARY_PATH:',matlabroot,filesep,...
%             'glnxa64:',matlabroot,filesep,'sys',filesep,'os',filesep,...
%             'glnxa64']);
%     end
%     if strcmp(computer,'PCWIN') || strcmp(computer,'GLNX86') % 32bit OS
%         runtimefolder = 'runtime32';
%         libflag = '-lITASL32';
% 
%     elseif strcmp(computer,'PCWIN64') || strcmp(computer,'GLNX64') % 64bit OS
%         runtimefolder = 'runtime64';
%         libflag = '-lITASL64';
%     end
%     cd([pname,filesep,'..',filesep,runtimefolder]);
%     try
%         mex('-R2018a',[pname,filesep,'FilterArray.c'],...
%             ['-L',pname,filesep,'lib'],libflag);
%     catch err
%         dispMatlabErr(err);
%     end
% end

% compile SIF file import
if exist('SIFImport','file')~=3
    
    % libraries unavailable for LINUX
    if strcmp(computer,'GLNXA86') || strcmp(computer,'GLNXA64') || ...
            strcmp(computer,'MACI86') || strcmp(computer,'MACI64')
        disp(['import of old versions of SIF files is not supported ',...
            'on MacOS and Linux systems']);
    else
        pname = fileparts(which('SIFImport.c'));

        if strcmp(computer,'PCWIN') || strcmp(computer,'MACI86') % 32bit OS
            runtimefolder = 'runtime32';
            libflag = '-lITASL32';

        elseif strcmp(computer,'PCWIN64') || strcmp(computer,'MACI64') % 64bit OS
            runtimefolder = 'runtime64';
            libflag = '-lITASL64';
        end
        cd([pname,filesep,'..',filesep,runtimefolder]);
        try
            mex('-R2018a',[pname,filesep,'SIFImport.c'],...
                ['-L',pname,filesep,'lib'],libflag);
        catch err
            dispMatlabErr(err);
        end
    end
end

% compile SPE file import
if exist('SPEImport','file')~=3
    
    % libraries unavailable for LINUX
    if strcmp(computer,'GLNXA86') || strcmp(computer,'GLNXA64') || ...
            strcmp(computer,'MACI86') || strcmp(computer,'MACI64')
        disp(['import of SPE files is not supported on MacOS and Linux ',...
            'systems']);
    else
        pname = fileparts(which('SPEImport.c'));

        if strcmp(computer,'PCWIN') % 32bit OS
            runtimefolder = 'runtime32';
            libflag = '-lITASL32';

        elseif strcmp(computer,'PCWIN64') % 64bit OS
            runtimefolder = 'runtime64';
            libflag = '-lITASL64';
        end
        cd([pname,filesep,'..',filesep,runtimefolder]);
        try
            mex('-R2018a',[pname,filesep,'SPEImport.c'],...
                ['-L',pname,filesep,'lib'],libflag);
        catch err
            dispMatlabErr(err);
        end
    end
end

% compile DPH training algorithm
if exist('trainPH','file')~=3
    cd(fileparts(which('trainPH.c')));
    try
        mex -R2018a -O trainPH.c vectop.c
    catch err
        dispMatlabErr(err);
    end
end

% compile Baum-Welch algorithm
if exist('baumwelch','file')~=3
    cd(fileparts(which('baumwelch.c')));
    try
        mex -R2018a -O baumwelch.c vectop.c fwdbwd.c
    catch err
        dispMatlabErr(err);
    end
end

% compile model error calculation
if exist('calcmdlconfiv','file')~=3
    cd(fileparts(which('calcmdlconfiv.c')));
    try
        mex -R2018a -O calcmdlconfiv.c vectop.c fwdbwd.c
    catch err
        dispMatlabErr(err);
    end
end
    