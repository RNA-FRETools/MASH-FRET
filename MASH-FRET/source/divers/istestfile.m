function ok = istestfile(file)
% ok = istestfile(file)
%
% Returns ok=1 if the input file is part of the test data set used in MASH's
% interface testing routines, and ok=0 otherwise

src0 = fileparts(which('MASH.m'));
file = strrep(file,'\',filesep);
file = strrep(file,'/',filesep);

% if file path is relative, check existence of file with adjusted absolute
% location
if ~strcmp(file(1),filesep)
    file = [filesep,file];
    ok = exist([src0,file],'file')>0;

% if file path is absolute, check location
else
    ok = contains(file,[src0,filesep,'source',filesep,'routines',filesep]) ...
        && contains(file,[filesep,'assets',filesep]);
end

