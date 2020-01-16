% load gamma factor file, added by FS, 24.4.2018
function pushbutton_loadFactors_Callback(obj, ~, h_fig)

% Last update by MH, 3.4.2019:
% >> moved pushbutton_loadGamma_Callback from gammaOpt.m to separate file 
%    to allow calling from multiple sources.
% >> adapt import for multiple FRET data and manage actions

h = guidata(h_fig);
p = h.param.ttPr;
defPth = h.folderRoot;

% load gamma factor file if it exists
[fname,pname,~] = uigetfile({'*.gam;*.bet', ...
    'Correction factors (*.gam,*.bet)'; '*.*', 'All files(*.*)'}, ...
    'Select factor file', defPth, 'MultiSelect', 'on');

if ~sum(fname) || ~sum(pname)
    return
end

[o,o,fext] = fileparts(fname);
isGam = strcmp(fext,'.gam');

if ~iscell(fname)
    fname = {fname};
end

str_file = '';
if numel(fname)>1
    str_file = cat(2,str_file,'s:\n\t');
else
    str_file = cat(2,str_file,': ');
end
for ff = 1:numel(fname)
    str_file = cat(2,str_file,fname{ff},'\n');
    if ff<numel(fname)
        str_file = cat(2,str_file,'\t');
    end
end
if isGam
    str = 'gamma';
else
    str = 'beta';
end
updateActPan(cat(2,'process import of ',str,' factors from file',str_file), ...
    h_fig, 'process');

factCell = cell(1,length(fname));
pairs = [];
for f = 1:length(fname)
    filename = [pname fname{f}];
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
factors = cell2mat(factCell');

% check if number of molecules is the same in the project and the .gam file
proj = p.curr_proj;
nMol = numel(p.proj{proj}.coord_incl);
if size(factors,1) ~= nMol
    updateActPan(cat(2,'The number of ',str,' factors does not match ',...
        'the number of molecules: import aborted.'), h_fig, 'error');
    return;
end

nFRET = size(p.proj{proj}.FRET,1);
nG = size(factors,2);
szG = min([nFRET,nG]);

% set the gamma factors from the .gam file or beta factors from the .bet
% file
id = 1:nFRET;
if ~isempty(pairs)
    for i = 1:szG
        j = find(p.proj{proj}.FRET(:,1)==pairs(i,1) & ...
            p.proj{proj}.FRET(:,2)==pairs(i,2),1);
        if ~isempty(j)
            id(i) = j;
        end
    end
end
for n = 1:nMol
    if isGam
        p.proj{proj}.curr{n}{6}{1}(1,id(1:szG)) = factors(n,1:szG);
    else
        p.proj{proj}.curr{n}{6}{1}(2,id(1:szG)) = factors(n,1:szG);
    end
end

% update the parameters
h.param.ttPr = p;
guidata(h_fig, h);

updateActPan(cat(2,str,' factors were successfully imported from file',...
    str_file), h_fig, 'success');

updateFields(h_fig, 'ttPr'); 
