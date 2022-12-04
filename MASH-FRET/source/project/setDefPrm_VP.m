function def = setDefPrm_VP(proj,p)
% def = setDefPrm_VP(proj)
%
% Set new or adjust project's video processing default parameters to 
% current standard.
%
% proj: project structure
% prm_in: existing video processing parameters
% def: adjusted project's defaults

% defaults
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
 
% initializes fields
p.VP = adjustParam('VP',[],p);
p.VP.defProjPrm = adjustParam('defProjPrm',[],p.VP);
p.VP.defProjPrm = initDefPrmFields_VP(p.VP.defProjPrm);
def = p.VP.defProjPrm;

% get project parameters
nChan = proj.nb_channel;
nMov = numel(proj.movie_file);
L = proj.movie_dat{1}{3};
avimg = proj.aveImg(:,1)';
coordsm = proj.coord;

sub_w = floor(proj.movie_dim{1}(1)/nChan);
coord2plot = 0;
if ~isempty(coordsm)
    coord2plot = 5;
end

% plot
plotprm{1} = [2,0]; % colormap,coord to plot
plotprm{2} = (1:nChan-1)*sub_w; % channel split pixel positions
def.plot = adjustVal(def.plot,plotprm);
def.plot{1}(3) = coord2plot;
def.plot{2} = plotprm{2};

% edit and export video
editprm{1} = {[1,0],... % filter index,apply to current frame only
    repmat(u,[1,nChan]),... % filter parameters
    filtlist,... % external filter list
    {}}; % {nFilt-by-(1+2*nChan)} applied filter and parameters
editprm{2} = [1,L,1]; % starting frame, ending frame and frame interval for video export
def.edit = adjustVal(def.edit,editprm);
def.edit{2}(2) = L;

% molecule coordinates parameters
gen_crd{1} = [1,min([L,100]),1]; % start,end and frame interval for average image calculation
gen_crd{2} = {[1,0],... % SF method, gaussian fit
    repmat([0,1.4,7,7,9,9,0],[nChan,1]),... % SF parameters (int threshold,ratio threshold,spot's width and height(px),fitting area width and height(px),apply to all frames)
    repmat([200,0,0,5,150,0,3],[nChan,1]),... % section rules (max. nb. of spots,min. intensity,min. and max. spot's width(px),max. assymetry,min. interspot distance,min. spot-edge distance)
    cell(1,nChan),... % {1-by-nChan}[Nsf-by-8] SF coord,intensities,assymetries,dimensions,orientation angle,offset
    cell(1,nChan)}; % {1-by-nChan}[Nslct-by-8] selected coord
gen_crd{3} = {{[],'',[1,2]},... % coord to transform,imported file,imported x- and -y columns
    {[],'','rw',... % reference coord, imported file, import mode
        {[((1:nChan)'+1),nChan*ones(nChan,1),zeros(nChan,1)],[1,2]},... % ref. coord file row-wise import options
        {reshape((1:2*nChan),[nChan 2]) 1},... % ref. coord file column-wise import options
        cell(1,nMov)},... % reference image file
    {[],4,''},... % transformation,transformation type,imported file
    []}; % transformed coordinates
def.gen_crd = adjustVal(def.gen_crd,gen_crd);
def.gen_crd{1}(2) = min([L,100]);

% intensity integration
gen_int{1} = {''}; % used video file
gen_int{2} = {coordsm,{''},{reshape(1:2*nChan,2,nChan)' 1}}; % used coord., coord file, import options
gen_int{3} = [5,8]; % area dimensions,nb. of brightest pixels
gen_int{4} = [1 1 0 0 0 0 0 0]; % export file options
def.gen_int = adjustVal(def.gen_int,gen_int);

% calculated/imported coordinates
def.res_crd{1} = cell(1,nMov); % spots coordinates
def.res_crd{2} = []; % transformation
def.res_crd{3} = []; % reference coordinates
def.res_crd{4} = coordsm; % single moelcule coordinates

% plot images
% res_plot: {1-by-3} images to plot with:
%  res_plot{1}: {1-by-nMov} current video frames
%  res_plot{2}: {1-by-nMov} average image
%  res_plot{3}: {1-by-2} images for transformation
%   res_plot{3}{1}: reference image
%   res_plot{3}{2}: transformed image
def.res_plot{1} = cell(1,nMov);
def.res_plot{2} = avimg;
def.res_plot{3} = cell(1,nMov);
