function addCharToTable(letters)
% Append the reference table with new characters.
%
% addCharToTable(letters)
%
% Takes input parameter "letters", a string containing characters to add to the reference table.

% default
mainFcn = 'MASH';
folder1 = 'source';
folder2 = 'GUI';
fname = 'charDimTable.mat';
fieldname = 'tbl';

% collect data from already existing reference file
[folder0,o,o] = fileparts(which(mainFcn));
fullfile = cat(2,folder0,filesep,folder1,filesep,folder2,filesep,fname);
tbl = getfield(load(fullfile),fieldname);
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
