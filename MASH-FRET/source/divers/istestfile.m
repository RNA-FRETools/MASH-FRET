function ok = istestfile(file)
% ok = istestfile(file)
%
% Returns ok=1 if the input file is part of the test data set used in MASH's
% interface testing routines, and ok=0 otherwise

src = fileparts(fileparts(which('MASH.m')));
file = strrep(file,'\',filesep);
file = strrep(file,'/',filesep);
if ~strcmp(file(1),filesep)
    file = [filesep,file];
end
ok = exist([src,file],'file')>0;
