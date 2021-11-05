function addFntnmToTable(fntnm)
% Append the reference table with new font names or remove old ones.
%
% addFntnmToTable(fntnm)
%
% Takes input parameter:
% "fntnm": cell vector containing font names to add (names with character "-" in first position will be deleted from the table)

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
letters = tbl{1};
fntun0 = tbl{2}{1};
fntsz0 = tbl{2}{2};
fntnm0 = tbl{2}{3};

% adjust input
if ~iscell(fntnm)
    fntnm = {fntnm};
end

% remove font names from reference table
s = [];
sfn = [];
for n = 1:numel(fntnm)
    if fntnm{n}(1)=='-'
        s = cat(2,s,find(contains(fntnm0,fntnm{n}(2:end))));
        sfn = cat(2,sfn,n);
    elseif sum(contains(fntnm0,fntnm{n}))
        disp(['Font "',fntnm{n},'" is already in the table.']);
        sfn = cat(2,sfn,n);
    end
end
tbl{2}{3}(s) = [];
tbl{3}{1}(:,:,:,s) = [];
tbl{3}{2}(:,:,:,s) = [];
fntnm(sfn) = [];

% add font sizes to reference table
if ~isempty(fntnm)
    % calculate widths
    disp('calculates character widths for normal-weighted font...')
    w_normal = getLetterWidths(letters,fntun0,fntsz0,fntnm,'normal');
    disp('calculates character widths for bold-weighted font...')
    w_bold = getLetterWidths(letters,fntun0,fntsz0,fntnm,'bold');

    % add new font sizes to reference table
    tbl{2}{3} = cat(2,tbl{2}{3},fntnm);
    tbl{3}{1} = cat(4,tbl{3}{1},w_normal{3});
    tbl{3}{2} = cat(4,tbl{3}{2},w_bold{3});
end

% save appended table to reference file
disp('save modifications to file...');
save(fullfile,'tbl');

disp(cat(2,'process completed: font sizes were successfully added to/',...
    'removed from the reference file!'))
