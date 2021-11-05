function addFntszToTable(fntsz,fntun)
% Append the reference table with new font sizes or remove old ones.
%
% addFntszToTable(fntsz,fntun)
%
% Takes input parameters:
% "fntsz": row vector containing font sizes to add (negative font sizes will be deleted from the table)
% "fntun": font units of font sizes ('points','pixels','inches' or 'centimeters')

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

% convert new font sizes to table's units
fntsz = convFntun(fntsz,fntun,fntun0);

% remove font sizes from reference table
s = [];
ssz = [];
for sz = fntsz
    if sz<0
        s = cat(2,s,find(fntsz0==(-sz),1));
        ssz = cat(2,ssz,s);
    elseif any(fntsz0==sz)
        disp(['Font size ',num2str(fntsz(s)),' ',fntun,' is already ',...
            'present in the table.'])
        ssz = cat(2,ssz,s);
    end
end
tbl{2}{2}(s) = [];
tbl{3}{1}(s,:,:,:) = [];
tbl{3}{2}(s,:,:,:) = [];
fntsz(ssz) = [];

% add font sizes to reference table
if ~isempty(fntsz)
    % calculate widths
    disp('calculates character widths for normal-weighted font...')
    w_normal = getLetterWidths(letters,fntun,fntsz,fntnm0,'normal');
    disp('calculates character widths for bold-weighted font...')
    w_bold = getLetterWidths(letters,fntun,fntsz,fntnm0,'bold');

    % add new font sizes to reference table
    tbl{2}{2} = cat(2,tbl{2}{2},fntsz);
    tbl{3}{1} = cat(1,tbl{3}{1},w_normal{3});
    tbl{3}{2} = cat(1,tbl{3}{2},w_bold{3});
end

% save appended table to reference file
disp('save modifications to file...');
save(fullfile,'tbl');

disp(cat(2,'process completed: font sizes were successfully added to/',...
    'removed from the reference file!'))
