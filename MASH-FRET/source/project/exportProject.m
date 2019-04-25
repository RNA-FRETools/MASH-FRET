function s = exportProject(p, fname, h_fig)

h = guidata(h_fig);

s = [];
     
[data,ok] = getFrames(p.itg_movFullPth, 1, [], h_fig);
if ~ok
    return;
end

fCurs = data.fCurs;
res_x = data.pixelX;
res_y = data.pixelY;
nFrames = data.frameLen;
if isfield(h, 'movie') && ~isempty(h.movie.movie)
    fCurs = h.movie.movie;
end

fDat = {p.itg_movFullPth, fCurs, [res_y res_x], nFrames};
[p.coordItg,traces] = create_trace(p.coordItg, p.itg_dim, p.itg_n, fDat);

nExc = p.itg_nLasers;
nCoord = size(p.coordItg,1);
nFrames_min = floor(nFrames/nExc);

I = zeros(nFrames_min, p.nChan*nCoord, nExc);
for i = 1:nExc
    I(:,:,i) = traces(i:nExc:nFrames_min*nExc,:);
end

nFRET = size(p.itg_expFRET,1);
nS = size(p.itg_expS,1);

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
    s.movie_dim = [res_x res_y];
    s.movie_dat = {fCurs, [res_x res_y], nFrames};

    s.coord_file = p.itg_coordFullPth; % coordinates path/file
    s.coord_imp_param = p.itg_impMolPrm; % coordinates import parameters
    s.coord = p.coordItg; % molecule coordinates in all channels
    s.coord_incl = true(1,size(I,2)/p.nChan);
    s.is_coord = 1;
    
    s.proj_file = fname; % project file
    
    s.nb_channel = p.nChan; % nb of channel
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
    s.bool_intensities = true(size(I,1), size(I,2)/p.nChan);
    
    s.colours = p.itg_clr; % plot colours
    
    % added by FS, 24.4.2018
    s.molTag = ones(1,size(I,2)/p.nChan);
    s.molTagNames = {'unlabeled', 'static', 'dynamic'};

end

