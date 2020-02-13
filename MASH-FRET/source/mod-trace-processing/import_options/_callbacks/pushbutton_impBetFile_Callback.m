function pushbutton_impBetFile_Callback(obj, evd, h_fig)
h = guidata(h_fig);
defPth = h.folderRoot;
[fname,pname,o] = uigetfile({'*.bet', 'Beta factors (*.bet)'; '*.*', ...
    'All files(*.*)'},'Select gamma factor file',defPth,'MultiSelect','on');
if ~isempty(fname) && ~isempty(pname) && sum(pname)
    if ~iscell(fname)
        fname = {fname};
    end
    m = guidata(h.figure_trImpOpt);
    m{6}{5} = pname;
    m{6}{6} = fname;
    str_file = '';
    for i = 1:numel(fname)
        str_file = cat(2,str_file,fname{i},'; ');
    end
    str_file = str_file(1:end-2);
    set(h.trImpOpt.text_fnameBet, 'String', str_file);
    guidata(h.figure_trImpOpt, m);
end


