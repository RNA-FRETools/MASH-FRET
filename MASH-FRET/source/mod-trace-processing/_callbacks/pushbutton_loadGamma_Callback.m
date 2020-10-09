% load gamma factor file, added by FS, 24.4.2018
function pushbutton_loadGamma_Callback(obj, ~, h_fig)

% Last update by MH, 3.4.2019:
% >> moved pushbutton_loadGamma_Callback from gammaOpt.m to separate file 
%    to allow calling from multiple sources.
% >> adapt import for multiple FRET data and manage actions

h = guidata(h_fig);
p = h.param.ttPr;
defPth = h.folderRoot;

% load gamma factor file if it exists
[fnameGamma,pnameGamma,~] = uigetfile({'*.gam', 'Gamma factors (*.gam)'; '*.*', ...
    'All files(*.*)'}, 'Select gamma factor file', defPth, 'MultiSelect', 'on');

if isempty(fnameGamma) || isempty(pnameGamma) || ~sum(pnameGamma)
    return;
end

if ~iscell(fnameGamma)
    fnameGamma = {fnameGamma};
end

str_file = '';
if numel(fnameGamma)>1
    str_file = cat(2,str_file,'s:\n\t');
else
    str_file = cat(2,str_file,': ');
end
for ff = 1:numel(fnameGamma)
    str_file = cat(2,str_file,fnameGamma{ff},'\n');
    if ff<numel(fnameGamma)
        str_file = cat(2,str_file,'\t');
    end
end
updateActPan(cat(2,'process import of gamma factors from file',...
    str_file), h_fig, 'process');

gammasCell = cell(1,length(fnameGamma));
for f = 1:length(fnameGamma)
    filename = [pnameGamma fnameGamma{f}];
    gammasCell{f} = importdata(filename);
end
gammas = cell2mat(gammasCell');

% check if number of molecules is the same in the project and the .gam file
proj = p.curr_proj;
nMol = numel(p.proj{proj}.coord_incl);
if size(gammas,1) ~= nMol
    updateActPan(cat(2,'The number of gamma factors does not match ',...
        'the number of molecules: import aborted.'), h_fig, 'error');
    return;
end

nFRET = size(p.proj{proj}.FRET,1);
nG = size(gammas,2);
szG = min([nFRET,nG]);

% set the gamma factors from the .gam file
for n = 1:nMol
    p.proj{proj}.curr{n}{5}{3}(1:szG) = gammas(n,1:szG);
end

% update the parameters
h.param.ttPr = p;
guidata(h_fig, h);

updateActPan(cat(2,'Gamma factors were successfully imported from file',...
    str_file), h_fig, 'success');

updateFields(h_fig, 'ttPr'); 

% close figure
if isfield(h,'gpo') && isfield(h.gpo,'pushbutton_loadGamma') && ...
    obj==h.gpo.pushbutton_loadGamma
    close(h.gpo.figure_gammaOpt);
end
