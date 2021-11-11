% load gamma factor file, added by FS, 24.4.2018
function pushbutton_loadFactors_Callback(obj, ~, h_fig)
% pushbutton_loadFactors_Callback([],[],h_fig)
% pushbutton_loadFactors_Callback(factor_files,[],h_fig)
%
% h_fig: handle to main figure
% factor_files: {1-by-2} source directory and factor file (.bet or .gam)

% Last update by MH, 8.3.2020: allow file selection via function arguments (routine call)
% update by MH, 3.4.2019: (1) moved pushbutton_loadGamma_Callback from gammaOpt.m to separate file to allow calling from multiple sources (2) adapt import for multiple FRET data and manage actions

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
defPth = p.proj{proj}.folderRoot;
nMol = numel(p.proj{proj}.coord_incl);
FRET = p.proj{proj}.FRET;

% load gamma factor file if it exists
if iscell(obj)
    pname = obj{1};
    fnames = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
else
    [fnames,pname,~] = uigetfile({'*.gam;*.bet', ...
        'Correction factors (*.gam,*.bet)'; '*.*', 'All files(*.*)'}, ...
        'Select factor file', defPth, 'MultiSelect', 'on');
end
if ~numel(fnames) || ~sum(pname)
    return
end
if ~iscell(fnames)
    fnames = {fnames};
end

% show process
setContPan('Importing correction factors from files...','process',h_fig);

str_file = '';
if numel(fnames)>1
    str_file = cat(2,str_file,'s:\n');
else
    str_file = cat(2,str_file,': ');
end
nFiles = numel(fnames);

isGam = false(1,nFiles);
for ff = 1:nFiles
    [o,o,fext] = fileparts(fnames{ff});
    isGam(ff) = strcmp(fext,'.gam');
    str_file = cat(2,str_file,fnames{ff},'\n');
end
updateActPan(['process import of factor file',str_file],h_fig,'process');

factCell = cell(1,length(fnames));
pairs = [];
for f = 1:length(fnames)
    filename = [pname fnames{f}];
    content = importdata(filename);
    if isstruct(content)
        factCell{f} = content.data;
        if f==1
            pairs = getFRETfromFactorFiles(content.colheaders);
        end
    else
        factCell{f} = content;
    end
end
gamFact = cell2mat(factCell(isGam)');
betFact = cell2mat(factCell(~isGam)');

% check if number of molecules is the same in the project and the .gam file
if ~isempty(gamFact) && size(gamFact,1)~=nMol
    updateActPan(cat(2,'The number of gamma factors does not match ',...
        'the number of molecules: import aborted.'), h_fig, 'error');
    return
end
if ~isempty(betFact) && size(betFact,1)~=nMol
    updateActPan(cat(2,'The number of beta factors does not match ',...
        'the number of molecules: import aborted.'), h_fig, 'error');
    return
end

nFRET = size(FRET,1);
nG = size(gamFact,2);
szG = min([nFRET,nG]);
nB = size(betFact,2);
szB = min([nFRET,nB]);

% set the gamma factors from the .gam file or beta factors from the .bet
% file
idG = 1:nFRET;
idB = idG;
if ~isempty(pairs)
    for i = 1:szG
        j = find(FRET(:,1)==pairs(i,1) & FRET(:,2)==pairs(i,2),1);
        if ~isempty(j)
            idG(i) = j;
        end
    end
    for i = 1:szB
        j = find(FRET(:,1)==pairs(i,1) & FRET(:,2)==pairs(i,2),1);
        if ~isempty(j)
            idB(i) = j;
        end
    end
end
for n = 1:nMol
    p.proj{proj}.TP.curr{n}{6}{1}(1,idG(1:szG)) = gamFact(n,1:szG);
    p.proj{proj}.TP.curr{n}{6}{1}(2,idB(1:szB)) = betFact(n,1:szB);
end

% update the parameters
h.param = p;
guidata(h_fig, h);

% refresh TP calculations and interface
updateFields(h_fig, 'ttPr'); 

% show success
setContPan(cat(2,'correction factors were successfully imported from ',...
    'file ',str_file), 'success', h_fig);
