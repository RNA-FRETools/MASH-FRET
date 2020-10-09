function pushbutton_next_Callback(obj, evd, h_fig)
% pushbutton_next_Callback([],[],h_fig)
% pushbutton_next_Callback(file_out,[],h_fig)
%
% h_fig: handle to main figure
% file_out: {1-by-2} destination folder and file name

h = guidata(h_fig);

if ~h.mute_actions
    choice = questdlg('Automatically process molecules unprocessed? ', ...
        'Processing before saving', 'Yes', 'No', 'Cancel', 'Yes');
else
    choice = 'Yes';
end
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

if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
else
    name_proj = p.proj{proj}.proj_file;
    if ~isempty(name_proj)
        [o,name_proj,o] = fileparts(name_proj);
    end
    defname = [setCorrectPath('traces_processing', h_fig) name_proj];

    [fname,pname,o] = uiputfile({'*.*', 'All files(*.*)'}, ...
        'Save processed data', defname);
end
if ~sum(fname)
    return
end

[o,fname_proc,o] = fileparts(fname);
close(h.optExpTr.figure_optExpTr);
saveProcAscii(h_fig, h.param.ttPr, h.param.ttPr.proj{proj}.exp, pname, ...
    fname_proc);
