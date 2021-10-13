function def = setDefPrm_VP(proj,p,img)
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

% recover VP interface at last save
if ~isfield(p, 'defProjPrm')
    p.defProjPrm = [];
end
def = p.defProjPrm;
nChan = proj.nb_channel;

% plot
def.curr_img = img; 
def.perSec = adjustParam('perSec', 1, def);
def.cmap = adjustParam('cmap', 1, def);
sub_w = floor(proj.movie_dim(1)/nChan);
def.split = (1:nChan-1)*sub_w;

% edit and export video
def.movBg_p = adjustParam('movBg_p', repmat(u,[1,nChan]), def);
def.movBg_method = adjustParam('movBg_method', 1, def);
def.movBg_myfilter = {'','gauss','mean','median','ggf','lwf','gwf','outlier',...
    'histotresh','simpletresh'};
def.movBg_one = adjustParam('movBg_one', 0, def);
def.mov_start = 1;
def.mov_end = 1;
def.bgCorr = {};

% molecule coordinates
def.ave_start = 1;
def.ave_stop = proj.movie_dat{3};
def.ave_iv = 1;

def.SF_method = adjustParam('SF_method', 1, def);
def.SF_gaussFit = adjustParam('SF_gaussFit', 0, def);
def.SF_intThresh = adjustParam('SF_intThresh', zeros(1,nChan), def);
def.SF_minI = adjustParam('SF_minI', def.SF_intThresh, def);
def.SF_w = adjustParam('SF_w', 7*ones(1,nChan), def);
def.SF_h = adjustParam('SF_h', 7*ones(1,nChan), def);
def.SF_darkW = adjustParam('SF_darkW', 9*ones(1,nChan), def);
def.SF_darkH = adjustParam('SF_darkH', 9*ones(1,nChan), def);
def.SF_all = adjustParam('SF_all', 0, def);
def.SF_maxN = adjustParam('SF_maxN', 200*ones(1,nChan), def);
def.SF_minHWHM = adjustParam('SF_minHWHM', zeros(1,nChan), def);
def.SF_maxHWHM = adjustParam('SF_maxHWHM', 5*ones(1,nChan), def);
def.SF_maxAssy = adjustParam('SF_maxAssy', 150*ones(1,nChan), def);
def.SF_minDspot = adjustParam('SF_minDspot', 0*ones(1,nChan), def);
def.SF_minDedge = adjustParam('SF_minDedge', 3*ones(1,nChan), def);
def.SF_intRatio = adjustParam('SF_intRatio', 1.4*ones(1,nChan), def);
def.SFres = {};
def.SFprm = cell(1,1+nChan);
def.SFprm{1} = [def.SF_method def.SF_gaussFit 1];
for i = 1:nChan
    def.SFprm{i+1} = [def.SF_w(i),def.SF_h(i); def.SF_darkW(i),def.SF_darkH(i); ...
        def.SF_intThresh(i),def.SF_intRatio(i)];
end
def.coordMol = [];
def.coordMol_file = [];

def.trsf_coordRef = [];
def.trsf_coordRef_file = [];
def.trsf_tr = [];
def.trsf_tr_file = [];
def.trsf_refImp_mode = adjustParam('trsf_refImp_mode', 'rw', def);
def.trsf_refImp_rw = adjustParam('trsf_refImp_rw', {[((1:nChan)' + 1) ...
    nChan*ones(nChan,1) zeros(nChan,1)] [1 2]}, def);
def.trsf_refImp_cw = adjustParam('trsf_refImp_cw', {...
    reshape((1:2*nChan), [nChan 2]) 1}, def);
def.trsf_type = adjustParam('tr_type', 1, def);
def.trsf_coordImp = adjustParam('trsf_coordImp', [1 2], def);
def.trsf_coordLim = adjustParam('trsf_coordLim', [256 256], def);
def.coordTrsf = [];
def.coordTrsf_file = [];
def.coordItg = [];
def.coordItg_file = [];
def.coord2plot = 0; %1:SF, 2:ref, 3:to transform, 4:transformed, 5:for trace

% intensity integration
def.itg_movFullPth = [];
def.itg_coordFullPth = [];
def.itg_impMolPrm = adjustParam('itg_impMolPrm', ...
    {reshape(1:2*nChan,2,nChan)' 1}, def);
def.itg_dim = adjustParam('itg_dim', 3, def);
def.itg_n = adjustParam('itg_n', def.itg_dim^2, def);
def.itg_ave = adjustParam('itg_ave', 1, def);
def.itg_expMolFile = adjustParam('itg_expMolFile',[1 1 0 0 0 0 0 0],def);
