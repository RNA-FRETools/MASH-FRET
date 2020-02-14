function pushbutton_impBetFile_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
defPth = h.folderRoot;

% ask for beta factor files
[fname,pname,o] = uigetfile({'*.bet', 'Beta factors (*.bet)'; '*.*', ...
    'All files(*.*)'},'Select gamma factor file',defPth,'MultiSelect','on');
if isempty(fname) || ~sum(pname)
    return
end

% collect import options
m = guidata(h.figure_trImpOpt);

if ~iscell(fname)
    fname = {fname};
end
m{6}{5} = pname;
m{6}{6} = fname;

% save modifications
guidata(h.figure_trImpOpt, m);

% set GUI to proper values
ud_trImpOpt(h_fig);



