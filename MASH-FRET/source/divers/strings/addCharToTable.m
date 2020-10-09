function addCharToTable(letters)
% Append the reference table with new characters.
%
% addCharToTable(letters)
%
% Takes input parameter "letters", a string containing characters to add to the reference table.
%
% example: addCharToTable(char([32:127,176,913:937,945:969]));
% adds characters  !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWX
% YZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~°??????????????????????????????????
% ????????????????

% default
mainFcn = 'MASH';
folder1 = 'source';
folder2 = 'GUI';
fname = 'charDimTable.mat';
fieldname = 'tbl';
def_fntun = 'points';
def_fntsz = [8,9];

% collect data from already existing reference file
[folder0,o,o] = fileparts(which(mainFcn));
fullfile = cat(2,folder0,filesep,folder1,filesep,folder2,filesep,fname);
if exist(fullfile,'file')
    dat = load(fullfile);
else
    dat = struct();
end
if isfield(dat,fieldname)
    tbl = getfield(load(fullfile),fieldname);
else
    tbl = cell(1,3);
    tbl{1} = '';
    tbl{2} = {def_fntun,def_fntsz};
    tbl{3} = {[],[]};
end
fntun = tbl{1,2}{1,1};
fntsz = tbl{1,2}{1,2};

% calculate widths
disp('calculates character widths for normal-weighted font...')
w_normal = getLetterWidths(letters,fntun,fntsz,'normal');

disp('calculates character widths for bold-weighted font...')
w_bold = getLetterWidths(letters,fntun,fntsz,'bold');

% add new characters to reference table
tbl{1} = cat(2,tbl{1},letters);
tbl{3}{1} = cat(3,tbl{3}{1},w_normal{3});
tbl{3}{2} = cat(3,tbl{3}{2},w_bold{3});

% save appended table to reference file
disp('save modifications to file...');
save(fullfile,'tbl');

disp(cat(2,'process completed: characters were successfully added to the ',...
    'reference file!'))
