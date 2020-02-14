function pushbutton_impGamFile_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
defPth = h.folderRoot;

% ask for gamma files
[fname,pname,o] = uigetfile({'*.gam', 'Gamma factors (*.gam)'; '*.*', ...
    'All files(*.*)'},'Select gamma factor file',defPth,'MultiSelect','on');
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

