function defprm = setDefPrm_VP(proj,p,img)
% def = setDefPrm_VP(proj,p,img)
%
% Set new or adjust project's simulation default parameters to current
% standard.
%
% p: video processing interface's defaults
% proj: project structure
% img: current video frame
% def: adjusted project's defaults

% defaults
perSec = true;
u = {[0 0] % image filter parameters
     [3 0]
     [3 0]
     [3 0]
     [3 1]
     [3 200]
     [200 0]
     [3 0.99]
     [0.5 0]
     [1500 0]
     [0 2]
     [0 50]
     [0 0.5]
     [0 0]
     [0 0]
     [3 1]
     [0 0]
     [1 0]
     [0 0]};
filtlist = {'','gauss','mean','median','ggf','lwf','gwf','outlier',...
    'histotresh','simpletresh'};

% retrieve existing default parameters
if ~isfield(p.VP, 'defProjPrm')
    p.VP.defProjPrm = [];
end
defprm = p.VP.defProjPrm;

% get project parameters
nChan = proj.nb_channel;
sub_w = floor(proj.movie_dim(1)/nChan);

% plot
def{1}{1} = img; % currently displayed video frame
def{1}{2} = [perSec,1]; % IC per second, colormap
def{1}{3} = (1:nChan-1)*sub_w; % channel split pixel positions

% edit and export video
def{2}{1} = {[1,0],... % filter index,apply to current frame only
    repmat(u,[1,nChan]),... % filter parameters
    filtlist,... % external filter list
    {}}; % applied filter list
def{2}{2} = [1,1]; % starting and ending video frame for export

% molecule coordinates
def{3}{1} = [1,proj.movie_dat{3},1]; % start,end and frame interval for average image calculation
def{3}{2} = {[1,false],... % SF method, gaussian fit
    repmat([0,1.4,7,7,9,9,0],[nChan,1]),... % SF parameters (int threshold,ratio threshold,spot's width and height(px),fitting area width and height(px),apply to all frames)
    repmat([200,0,0,5,150,0,3],[nChan,1]),... % section rules (max. nb. of spots,min. intensity,min. and max. spot's width(px),max. assymetry,min. interspot distance,min. spot-edge distance)
    {},... % SF coord
    {}}; % selected coord
def{3}{3} = {{[],'',[1,2]},... % coord to transform,imported file,imported x- and -y columns
    {[],'','rw',... % reference coord, imported file, import mode
        {[((1:nChan)'+1),nChan*ones(nChan,1),zeros(nChan,1)],[1,2]},... % ref. coord file row-wise import options
        {reshape((1:2*nChan),[nChan 2]) 1}},... % ref. coord file column-wise import options
    {[],1,'',[256,256]},... % transformation,transformation type,imported file,transformation dimensions
    []}; % transformed coordinates

% intensity integration
def{4}{1} = {'',... % used video file
    '',... % used coordinates file
    {reshape(1:2*nChan,2,nChan)' 1}}; % coordinates import options
def{4}{2} = [5,8,1]; % area dimensions,nb. of brightest pixels,averaging intensity
def{4}{3} = [1 1 0 0 0 0 0 0]; % export file options

% check and correct inconsistensies in structure
defprm = adjustVal(defprm,def);
