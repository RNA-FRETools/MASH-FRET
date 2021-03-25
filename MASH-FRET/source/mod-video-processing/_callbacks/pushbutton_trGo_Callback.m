function pushbutton_trGo_Callback(obj, evd, h_fig)
% pushbutton_trGo_Callback([],[],h_fig)
% pushbutton_trGo_Callback(fileout,[],h_fig)
%
% h_fig: handle to main figure
% fileout: {1-by-2} destination folder and file

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

if p.nChan<=1 || p.nChan>3
    updateActPan(cat(2,'This functionality is available for 2 or 3 ',...
        'channels only.'), h_fig, 'error');
    return
end

if ~(isfield(p, 'trsf_tr') && isfield(p, 'coordMol') && ...
        ~isempty(p.trsf_tr) && ~isempty(p.coordMol))
    updateActPan('No coordinates or transformation is imported.', h_fig, ...
        'error');
    return
end

% transform coordinates
q.res_x = p.trsf_coordLim(1);
q.res_y = p.trsf_coordLim(2);
q.nChan = p.nChan;
q.spotSize = p.SF_w;
q.spotDmin = p.SF_minDspot;
q.edgeDmin = p.SF_minDedge;
coordTrsf = applyTrafo(p.trsf_tr, p.coordMol, q, h_fig);
if isempty(coordTrsf)
    return
end

% save transformed coordinates
p.coordTrsf = coordTrsf;
p.coord2plot = 4;

% get destination file name
saved = 1;
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
else
    if ~isempty(p.coordMol_file)
        [o,fname,o] = fileparts(p.coordMol_file);
    else
        fname = 'transformed_coordinates';
    end
    defName = [setCorrectPath('transformed', h_fig),fname,'.coord'];
    [fname,pname,o] = uiputfile({...
        '*.coord', 'Transformed coordinates files(*.coord)'; ...
        '*.*', 'All files(*.*)'}, 'Export transformation', defName);
end
if sum(fname)
    cd(pname);
    [o,fname,o] = fileparts(fname);
    fname = getCorrName([fname '.coord'], pname, h_fig);
    if ~sum(fname)
        saved = 0;
    end
else
    saved = 0;
end
if ~saved
    p.coordTrsf_file = [];
    
    % save modifications
    h.param.movPr = p;
    guidata(h_fig, h);
    
    updateActPan(['Coordinates were successfully transformed but were not ' ...
        'saved'], h_fig, 'process');
    
    % set GUI to proper values and refresh plot
    updateFields(h_fig,'imgAxes');
    return
end

% write coordinates to file
str_header = 'x1\ty1'; str_fmt = '%d\t%d';
for i = 2:p.nChan
    str_header = cat(2,str_header,'\tx',num2str(i),'\ty',num2str(i));
    str_fmt = cat(2,str_fmt,'\t%d\t%d');
end
str_header = [str_header '\n'];
str_fmt = [str_fmt '\n'];
f = fopen([pname fname], 'Wt');
fprintf(f, str_header);
fprintf(f, str_fmt, coordTrsf');
fclose(f);

% set transformed coordinates file
p.coordTrsf_file = fname;

% set coordinates file for intensity integration
if p.nChan==1 && isempty(p.coordItg)
    p.coordItg_file = p.coordTrsf_file;
    p.itg_coordFullPth = [pname p.coordTrsf_file];
    p.coordItg = p.coordTrsf;
    guidata(h_fig, h);
end

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');

% show action
updateActPan(['Coordinates were successfully transformedt and saved to ',...
    'file: ' fname '\n in folder: ' pname], h_fig, 'success');
