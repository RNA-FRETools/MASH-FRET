function exportMapCoord(h_fig,varargin)
% exportMapCoord(h_fig)
% exportMapCoord(h_fig,pname,fname)
%
% Export mapped coordinates to a .map file 
%
% h_fig: handle to main figure
% pname: destination folder
% fname: destination file

global pntCoord;

% collect interface parameters
h = guidata(h_fig);
q = h.map;

% collect mapping
nChan = size(q.lim_x,2) - 1;
minN = size(pntCoord{1},1);
for i = 2:nChan
    minN = min([minN size(pntCoord{i},1)]);
end
if minN > 0
    for i = 1:nChan
        q.pnt(1:minN,2*i-1) = pntCoord{i}(1:minN,1) + q.lim_x(i);
        q.pnt(1:minN,2*i) = pntCoord{i}(1:minN,2);
    end
end

% recover mapped coordinates
coord = zeros([numel(q.pnt)/2 2]);
if ~isempty(q.pnt)
    for i = 1:nChan
        coord(i:nChan:end,:) = q.pnt(:,2*i-1:2*i);
    end
end
if isempty(coord)
    return
end

% get destination coordinates file
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
    return
end
cd(pname);
[o,fname,o] = fileparts(fname);
fname = getCorrName([fname '.map'], pname, h_fig);
if ~sum(fname)
    return
end

% save coordinates to file
f = fopen([pname fname], 'Wt');
fprintf(f, 'x\ty\n');
fprintf(f, '%d\t%d\n', coord');
fclose(f);

% display succes
setContPan(['Reference coordinates were successfully saved to file: ',...
    pname,fname], 'success', h_fig);
