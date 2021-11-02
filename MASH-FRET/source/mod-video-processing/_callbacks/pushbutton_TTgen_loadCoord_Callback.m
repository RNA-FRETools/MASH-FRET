function pushbutton_TTgen_loadCoord_Callback(obj, evd, h_fig)
% pushbutton_TTgen_loadCoord_Callback([], [], h_fig)
% pushbutton_TTgen_loadCoord_Callback(coordfile, [], h_fig)
%
% h_fig: handle to main figure
% coordfile: {1-by-2} source folder and source file containing coordinates used in intensity integration

% Last update by MH, 28.3.2019: (1) Fix error when calling orgCoordCol.m with too few input arguments (2) Remove action "Unable to import coordinates" to avoid double action with orgCoordCol

% get parameters
h = guidata(h_fig);
p = h.param;
nChan = p.proj{p.curr_proj}.nb_channel;
res_x = p.proj{p.curr_proj}.movie_dim(1);
curr = p.proj{p.curr_proj}.VP.curr;
impprm = curr.gen_int{2}{3};

% get coordinates file
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
else
    [fname,pname,o] = uigetfile({...
        '*.coord;*.spots;*.map','Coordinates File(*.coord;*.spots;*.map)'; ...
        '*.*', 'All Files (*.*)'},'Select a coordinates file', ...
        setCorrectPath('coordinates', h_fig));
end
if ~sum(fname)
    return
end
cd(pname);

% display process
setContPan('Import single molecule coordinates...','process',h_fig);

% import coordinates form file
setContPan('Load coordinates ...','process',h_fig);
fDat = importdata([pname fname], '\n');

% organize coordinates in a column-wise fashion
coord = orgCoordCol(fDat, 'cw', impprm, nChan, res_x, h_fig);
if isempty(coord) || size(coord, 2)~=(2*nChan)
    return
end

% save coordinates and file for intensity integration
curr.res_crd{4} = coord;
curr.gen_int{2}{2} = [pname fname];
curr.plot{1}(2) = 5;

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% bring tab forefront
h.uitabgroup_VP_plot.SelectedTab = h.uitab_VP_plot_avimg;

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');

% display success
setContPan(cat(2,'Single molecule coordinates successfully imported from ',...
    'file: ',pname,fname),'success',h_fig);

