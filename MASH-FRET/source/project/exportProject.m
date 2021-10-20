function proj = exportProject(fname,h_fig)

% update by MH, 24.4.2019: fetch default tag names and colors in interface's defaults (default_param.ini)
% update by MH, 24.4.2019: (1) modify molecule tag names by removing label 'unlabelled' (2) modify molecule tag structure to allow multiple tags per molecule, by using the first dimension for molecule idexes and the second dimension for label indexes (3) add tag's default colors to project

h = guidata(h_fig);
p = h.param;
proj = p.proj{p.curr_proj};
nChan = proj.nb_channel;
nExc = proj.nb_excitations;
L = proj.movie_dat{3};
curr = proj.VP.curr;
coordsm = curr.gen_int{2}{1};
pxdim = curr.gen_int{3}(1);
npix = curr.gen_int{3}(2);
avecnt = curr.gen_int{3}(3);
coordfile = curr.gen_int{2}{2};
impprm = curr.gen_int{2}{3};
persec = curr.plot{1}(1);

% collect video file parameters
fDat{1} = proj.movie_file;
fDat{2}{1} = proj.movie_dat{1};
if isFullLengthVideo(h_fig)
    fDat{2}{2} = h.movie.movie;
else
    fDat{2}{2} = [];
end
fDat{3} = proj.movie_dim;
fDat{4} = L;

% build traces
[coordsm,traces] = create_trace(coordsm,pxdim,npix,fDat);

% get dimensions
nCoord = size(coordsm,1);
nFRET = size(proj.FRET,1);
nS = size(proj.S,1);

% initializes intensity matrix
L_min = floor(L/nExc);
I = zeros(L_min,nChan*nCoord,nExc);
for i = 1:nExc
    I(:,:,i) = traces(i:nExc:L_min*nExc,:);
end

if nFRET>0
    defES = cell(1,nFRET);
else
    defES = {};
end

if ~isempty(I)
    proj.date_last_modif = datestr(now);
    proj.coord_file = coordfile; % coordinates path/file
    proj.coord_imp_param = impprm; % coordinates import parameters
    proj.coord = coordsm; % molecule coordinates in all channels
    proj.coord_incl = true(1,size(I,2)/nChan);
    proj.is_coord = 1;
    
    proj.proj_file = fname; % project file

    proj.pix_intgr = [pxdim npix]; % intgr. area dim. + nb of intgr pix
    proj.cnt_p_sec = persec; % intensities in counts per second
    proj.cnt_p_pix = avecnt; % intensities in counts per pixels
  
    proj.intensities = I;
    proj.intensities_bgCorr = nan(size(I));
    proj.intensities_crossCorr = nan(size(I));
    proj.intensities_denoise = nan(size(I));
    proj.ES = defES;
    proj.intensities_DTA = nan(size(I));
    proj.FRET_DTA = nan(size(I,1), nCoord*nFRET);
    proj.S_DTA = nan(size(I,1), nCoord*nS);
    proj.bool_intensities = true(size(I,1), size(I,2)/nChan);
    
    % added by FS, 24.4.2018
    % modified by MH, 24.4.2019: remove label 'unlabelled', use second 
    % dimension for label indexes and first dimension for molecule idexes
%     s.molTag = ones(1,size(I,2)/nChan);
%     s.molTagNames = {'unlabeled', 'static', 'dynamic'};
    proj.molTag = false((size(I,2)/nChan),numel(proj.molTagNames));
    
end

