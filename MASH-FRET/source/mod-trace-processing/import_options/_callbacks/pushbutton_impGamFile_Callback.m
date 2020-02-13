function pushbutton_impGamFile_Callback(obj, evd, h_fig)

h = guidata(h_fig);
defPth = h.folderRoot;
[fname,pname,o] = uigetfile({'*.gam', 'Gamma factors (*.gam)'; '*.*', ...
    'All files(*.*)'},'Select gamma factor file',defPth,'MultiSelect','on');
if ~isempty(fname) && ~isempty(pname) && sum(pname)
    if ~iscell(fname)
        fname = {fname};
    end
    m = guidata(h.figure_trImpOpt);
    m{6}{2} = pname;
    m{6}{3} = fname;
    str_file = '';
    for i = 1:numel(fname)
        str_file = cat(2,str_file,fname{i},'; ');
    end
    str_file = str_file(1:end-2);
    set(h.trImpOpt.text_fnameGam, 'String', str_file);
    guidata(h.figure_trImpOpt, m);
end


