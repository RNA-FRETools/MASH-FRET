function pushbutton_impGamFile_Callback(obj, evd, h_fig)
% pushbutton_impGamFile_Callback([],[],h_fig)
% pushbutton_impGamFile_Callback(beta_files,[],h_fig)
%
% h_fig: handle to main figure
% beta_files: {1-by-2} destination folder and files with:
%  beta_files{1}: dstination folder
%  beta_files{2}: {1-by-nFiles} files used for gamma factor import

% collect interface parameters
h = guidata(h_fig);

if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
else
    % ask for gamma factor files
    defPth = h.folderRoot;
    [fname,pname,o] = uigetfile({'*.gam', 'Gamma factors (*.gam)'; '*.*', ...
        'All files(*.*)'},'Select gamma factor file',defPth,'MultiSelect',...
        'on');
end
if isempty(fname) || ~sum(pname)
    return
end

% collect improt options
m = guidata(h.figure_trImpOpt);

if ~iscell(fname)
    fname = {fname};
end
m{6}{2} = pname;
m{6}{3} = fname;

% save modifications
guidata(h.figure_trImpOpt, m);

% set GUI to proper values
ud_trImpOpt(h_fig);

