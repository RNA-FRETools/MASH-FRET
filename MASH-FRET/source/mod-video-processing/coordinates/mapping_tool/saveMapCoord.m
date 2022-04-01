function ok = saveMapCoord(h_fig)
% ok = saveMapCoord(h_fig)
%
% Import mapped coordinates for transformation calculation
%
% h_fig: handle to main figure
% ok = execution success (1) or failure (0)

% initialize output
ok = 0;

% collect interface parameters
h = guidata(h_fig);
p = h.param;
q = h.map;
curr = p.proj{p.curr_proj}.VP.curr;

if ~isempty(q.lim_x)
    nChan = size(q.lim_x,2)-1;
else
    nChan = numel(q.refimgfile);
end

% recover mapped coordinates
coord = q.pnt;
if isempty(coord)
    return
end

% set reference coordinates for transformation
curr.res_crd{3} = coord;
curr.plot{1}(2) = 2;

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% display succes
setContPan(['Reference coordinates were successfully imported for',...
    'transformation'], 'success', h_fig);

ok = 1;
