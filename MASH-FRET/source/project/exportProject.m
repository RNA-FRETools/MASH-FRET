function s = exportProject(p,fname,h_fig)

%% Last update by MH, 24.4.2019
% >> fetch default tag names and colors in interface's defaults
%    (default_param.ini)
%
% update by MH, 24.4.2019
% >> modify molecule tag names by removing label 'unlabelled'
% >> modify molecule tag structure to allow multiple tags per molecule, by 
%    using the first dimension for molecule idexes and the second dimension 
%    for label indexes 
% >> add tag's default colors to project
%%

h = guidata(h_fig);

% initializes project stucture
s = [];

% collect video file parameters
fDat{1} = p.itg_movFullPth;
fDat{2}{1} = h.movie.speCursor;
if isfield(h, 'movie') && ~isempty(h.movie.movie)
    fDat{2}{2} = h.movie.movie;
else
    fDat{2}{2} = [];
end
fDat{3} = [h.movie.pixelY,h.movie.pixelX];
fDat{4} = h.movie.framesTot;

% build traces
[p.coordItg,traces] = create_trace(p.coordItg,p.itg_dim,p.itg_n,fDat);

nChan = p.nChan;
nExc = p.itg_nLasers;
nCoord = size(p.coordItg,1);
L = h.movie.framesTot;

% correct ill-defined project parameters
if nChan==1
    p.itg_expFRET = [];
    p.itg_expS = [];
end
if nExc==1
    p.itg_expS = [];
end
nFRET = size(p.itg_expFRET,1);
nS = size(p.itg_expS,1);

% initializes intensity matrix
L_min = floor(L/nExc);
I = zeros(L_min,nChan*nCoord,nExc);
for i = 1:nExc
    I(:,:,i) = traces(i:nExc:L_min*nExc,:);
end

if ~isempty(I)
    s.date_creation = datestr(now);
    s.date_last_modif = s.date_creation;
    
    figname = get(h_fig, 'Name');
    a = strfind(figname, 'MASH-FRET ');
    b = a + numel('MASH-FRET ');
    vers = figname(b:end);
    s.MASH_version = vers;
    
    s.movie_file = p.itg_movFullPth; % movie path/file
    s.is_movie = 1;
    s.movie_dim = [h.movie.pixelX h.movie.pixelY];
    s.movie_dat = {h.movie.speCursor,[h.movie.pixelX h.movie.pixelY],L};

    s.coord_file = p.itg_coordFullPth; % coordinates path/file
    s.coord_imp_param = p.itg_impMolPrm; % coordinates import parameters
    s.coord = p.coordItg; % molecule coordinates in all channels
    s.coord_incl = true(1,size(I,2)/nChan);
    s.is_coord = 1;
    
    s.proj_file = fname; % project file
    
    s.nb_channel = nChan; % nb of channel
    s.frame_rate = p.rate;
    s.exp_parameters = p.itg_expMolPrm; % user-defined parameters
    s.pix_intgr = [p.itg_dim p.itg_n]; % intgr. area dim. + nb of intgr pix
    s.cnt_p_sec = p.perSec; % intensities in counts per second
    s.cnt_p_pix = p.itg_ave; % intensities in counts per pixels
    s.excitations = p.itg_wl(1:nExc); % laser wavelengths (chron. order)
    s.nb_excitations = nExc;
    s.FRET = p.itg_expFRET;
    s.S = p.itg_expS;
    s.chanExc = p.chanExc;
    s.labels = p.labels;
    
    s.intensities = I;
    s.intensities_bgCorr = nan(size(I));
    s.intensities_crossCorr = nan(size(I));
    s.intensities_denoise = nan(size(I));
    s.intensities_DTA = nan(size(I));
    s.FRET_DTA = nan(size(I,1), nCoord*nFRET);
    s.S_DTA = nan(size(I,1), nCoord*nS);
    s.bool_intensities = true(size(I,1), size(I,2)/nChan);
    
    s.colours = p.itg_clr; % plot colours
    
    % added by FS, 24.4.2018
    % modified by MH, 24.4.2019: remove label 'unlabelled', use second 
    % dimension for label indexes and first dimension for molecule idexes
%     s.molTag = ones(1,size(I,2)/nChan);
%     s.molTagNames = {'unlabeled', 'static', 'dynamic'};
    s.molTagNames = p.defTagNames;
    s.molTag = false((size(I,2)/nChan),numel(s.molTagNames));
    
    % added by MH, 24.4.2019
    s.molTagClr = p.defTagClr;

end

