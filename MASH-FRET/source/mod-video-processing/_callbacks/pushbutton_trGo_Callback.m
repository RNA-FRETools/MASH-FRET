function pushbutton_trGo_Callback(obj, evd, h_fig)
% pushbutton_trGo_Callback([],[],h_fig)
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param;
viddim = p.proj{p.curr_proj}.movie_dim;
nChan = p.proj{p.curr_proj}.nb_channel;
curr = p.proj{p.curr_proj}.VP.curr;
def = p.proj{p.curr_proj}.VP.def;
coord2tr = curr.res_crd{1};
tr = curr.res_crd{2};
nMov = numel(viddim);

% control number of channels
if nChan<=1 || nChan>3
    setContPan('This functionality is available for 2 or 3 channels only.',...
        'error',h_fig);
    return
end

% control coordinates
if isequal(coord2tr,def.res_crd{1})
    setContPan(['No coordinates detected. Please start a Spot Finder ',...
        'procedure or or import spots coordinates.'],'error',h_fig);
    return
end

% control transformation
if isempty(tr)
    setContPan(['No transformation detected. Please calculate or import a ',...
        'transformation.'],'error',h_fig);
    return
end

% display process
setContPan('Transform coordinates...','process',h_fig);

% transform coordinates
q.res_x = zeros(1,nMov);
q.res_y = zeros(1,nMov);
for mov = 1:nMov
    q.res_x(mov) = viddim{mov}(1);
    q.res_y(mov) = viddim{mov}(2);
end
q.nChan = nChan;
q.spotDmin = ones(1,nChan);
q.edgeDmin = ones(1,nChan);
coordtr = applyTrafo(tr,coord2tr,q,h_fig);
if isempty(coordtr)
    return
end

% save transformed coordinates
curr.res_crd{4} = coordtr;

% reset single molecule coordinates file
curr.gen_int{2}{2} = '';

% set coordinates to plot
curr.plot{1}(2) = 4;

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
p.proj{p.curr_proj}.VP.prm.gen_crd{3} = curr.gen_crd{3};
p.proj{p.curr_proj}.VP.prm.res_crd = curr.res_crd;
h.param = p;
guidata(h_fig, h);

% bring average image plot tab front
bringPlotTabFront('VPave',h_fig);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');

% display success
setContPan('Coordinates were successfully transformed!','success',h_fig);
