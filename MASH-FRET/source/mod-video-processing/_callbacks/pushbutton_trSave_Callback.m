function pushbutton_trSave_Callback(obj, evd, h_fig)
% pushbutton_trSave_Callback([],[],h_fig)
% pushbutton_trSave_Callback(fileout,[],h_fig)
%
% h_fig: handle to main figure
% fileout: {1-by-2} destination folder and file

% collect interface parameters
h = guidata(h_fig);
p = h.param;
nChan = p.proj{p.curr_proj}.nb_channel;
curr = p.proj{p.curr_proj}.VP.curr;
vidfile = p.proj{p.curr_proj}.movie_file;
coordtr = curr.res_crd{4};
coordfile = curr.gen_crd{3}{1}{2};

% control number of channels
if nChan<=1 || nChan>3
    setContPan('This functionality is available for 2 or 3 channels only.',...
        'error',h_fig);
    return
end

% control coordinates
if isempty(coordtr)
    setContPan(['No coordinates detected. Please start a transformation ',...
        'procedure or or import transformed coordinates.'],'error',h_fig);
    return
end

% get destination file name
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
else
    if isempty(coordfile)
        coordfile = vidfile;
    end
    [o,fname,o] = fileparts(coordfile);
    defName = [setCorrectPath('transformed', h_fig),fname,'.coord'];
    [fname,pname,o] = uiputfile({...
        '*.coord', 'Transformed coordinates files(*.coord)'; ...
        '*.*', 'All files(*.*)'}, 'Export transformation', defName);
end
if ~sum(fname)
    return
end
cd(pname);
[o,fname,o] = fileparts(fname);
fname = getCorrName([fname '.coord'], pname, h_fig);
if ~sum(fname)
    return
end

% display process
setContPan('Write transformed coordinates to file...','process',h_fig);

% write coordinates to file
str_header = 'x1\ty1'; str_fmt = '%d\t%d';
for i = 2:nChan
    str_header = cat(2,str_header,'\tx',num2str(i),'\ty',num2str(i));
    str_fmt = cat(2,str_fmt,'\t%d\t%d');
end
str_header = [str_header '\n'];
str_fmt = [str_fmt '\n'];
f = fopen([pname fname], 'Wt');
fprintf(f, str_header);
fprintf(f, str_fmt, coordtr');
fclose(f);

% save modifications
h.param = p;
guidata(h_fig, h);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');

% display success
setContPan(['Transformed coordinates successfully saved to file: ',pname,...
    fname],'success',h_fig);
