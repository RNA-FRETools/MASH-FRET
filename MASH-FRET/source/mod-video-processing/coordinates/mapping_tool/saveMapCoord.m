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
nChan = p.proj{p.curr_proj}.nb_channel;
curr = p.proj{p.curr_proj}.VP.curr;

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

% organise coordinates in a column-wise fashion
prm{1}(:,1) = 1:nChan;
prm{1}(:,2) = nChan;
prm{1}(:,3) = zeros(1,nChan);
prm{2}(1) = 1;
prm{2}(2) = 2;
coord_org = orgCoordCol(coord, 'rw', prm, nChan, q.res_x);

% set reference coordinates for transformation
curr.res_crd{3} = coord_org;
curr.plot{1}(3) = 2;

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% display succes
setContPan(['Reference coordinates were successfully imported for',...
    'transformation'], 'success', h_fig);

ok = 1;
