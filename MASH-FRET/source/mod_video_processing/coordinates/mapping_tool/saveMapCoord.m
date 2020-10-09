function ok = saveMapCoord(h_fig,varargin)
% ok = saveMapCoord(h_fig)
% ok = saveMapCoord(h_fig,pname,fname)
%
% Save mapped coordinates to a .map file and load them in memory for transformation calculation
%
% h_fig: handle to main figure
% pname: destination folder
% fname: destination file
% ok = execution success (1) or failure (0)

% initialize output
ok = 1;

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;
q = h.map;

% collect processing parameters
nC = p.nChan;

% recover mapped coordinates
coord = zeros([numel(q.pnt)/2 2]);
if ~isempty(q.pnt)
    for i = 1:nC
        coord(i:nC:end,:) = q.pnt(:,2*i-1:2*i);
    end
end
if isempty(coord)
    ok = 0;
    return
end

% organise coordinates in a column-wise fashion
prm{1}(:,1) = 1:nC;
prm{1}(:,2) = nC;
prm{1}(:,3) = zeros(1,nC);
prm{2}(1) = 1;
prm{2}(2) = 2;
coord_org = orgCoordCol(coord, 'rw', prm, nC, q.res_x);

% set reference coordinates for transformation
if nC>1
    p.trsf_coordRef = coord_org;
    isItg = 0;
    
% set coordinates for intensity integration
elseif isempty(p.coordItg)
    p.coordItg = coord_org;
    isItg = 1;
end
p.coord2plot = 2;

% get destination coordinates file
saved = 1;
if ~isempty(varargin)
    pname = varargin{1};
    fname = varargin{2};
    if ~strcmp(pname,'filesep')
        pname = cat(2,pname,filesep);
    end
else
    [o,defName,o] = fileparts(q.refimgfile);
    defName = [setCorrectPath('mapping', h_fig) defName '.map'];
    [fname,pname,o] = uiputfile({'*.map','Mapped coordinates files(*.map)'; ...
        '*.*','All files(*.*)'},'Export coordinates', defName);
end
if ~sum(fname)
    saved = 0;
else
    cd(pname);
    [o,fname,o] = fileparts(fname);
    fname = getCorrName([fname '.map'], pname, h_fig);
    if ~sum(fname)
        saved = 0;
    end
end
if ~saved
    if nC > 1
        p.trsf_coordRef_file = [];
    elseif isItg
        p.coordItg_file = [];
        p.itg_coordFullPth = [];
    end
    
    % save modifications
    h.param.movPr = p;
    guidata(h_fig, h);
    
    % set GUI to proper values and refresh plot
    updateFields(h_fig,'imgAxes');
    
    updateActPan('Reference coordinates loaded but not saved', h_fig, ...
        'process');
    return
end

% save coordinates to file
f = fopen([pname fname], 'Wt');
fprintf(f, 'x\ty\n');
fprintf(f, '%d\t%d\n', coord');
fclose(f);
updateActPan(['Reference coordinates were successfully map and saved to ',...
    'file: ',pname,fname], h_fig, 'success');

% set reference coordinates file for transformation
if nC>1
    p.trsf_coordRef_file = fname;
    
% set coordinates file for intensity integration
elseif isItg
    p.coordItg_file = fname;
    p.itg_coordFullPth = [pname fname];
end

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

