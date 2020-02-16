function pushbutton_next_Callback(obj, evd, h_fig)
h = guidata(h_fig);
choice = questdlg('Automatically process molecules unprocessed? ', ...
    'Processing before saving', 'Yes', 'No', 'Cancel', 'Yes');
if strcmp(choice, 'Yes')
    h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.process = 1;
elseif strcmp(choice, 'No')
    h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.process = 0;
else
    return;
end
guidata(h_fig, h);
p = h.param.ttPr;
proj = p.curr_proj;
name_proj = p.proj{proj}.proj_file;
if ~isempty(name_proj)
    [o,name_proj,o] = fileparts(name_proj);
end
defname = [setCorrectPath('traces_processing', h_fig) name_proj];

[fname,pname,o] = uiputfile({'*.*', 'All files(*.*)'}, ...
    'Save processed data', defname);
if ~isempty(fname) && sum(fname)
    [o,fname_proc,o] = fileparts(fname);
    close(h.optExpTr.figure_optExpTr);
    saveProcAscii(h_fig, h.param.ttPr, h.param.ttPr.proj{proj}.exp, ...
        pname, fname_proc);
end