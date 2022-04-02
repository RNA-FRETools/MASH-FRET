function proj = exportProject(h_fig)
% proj = exportProject(h_fig)
%
% Builds project's structure using data generated in VP
%
% h_fig: handle to main figure
% proj: project's structure

% update by MH, 24.4.2019: fetch default tag names and colors in interface's defaults (default_param.ini)
% update by MH, 24.4.2019: (1) modify molecule tag names by removing label 'unlabelled' (2) modify molecule tag structure to allow multiple tags per molecule, by using the first dimension for molecule idexes and the second dimension for label indexes (3) add tag's default colors to project

h = guidata(h_fig);
p = h.param;
proj = p.proj{p.curr_proj};
nChan = proj.nb_channel;
nExc = proj.nb_excitations;
vidfile = proj.movie_file;
viddat = proj.movie_dat;
viddim = proj.movie_dim;
curr = proj.VP.curr;
coordsm0 = curr.res_crd{4};
pxdim = curr.gen_int{3}(1);
npix = curr.gen_int{3}(2);
coordfile = curr.gen_int{2}{2};
impprm = curr.gen_int{2}{3};

L = viddat{1}{3};

nMov = numel(vidfile);
multichanvid = nMov==1;

if ~multichanvid
    idcoord = cell(1,nMov);
    coordsm_mv = cell(1,nMov);
    traces_mv = cell(1,nMov);
    excl = false(1,size(coordsm0,1));
end
for mov = 1:nMov

    % load full-length video data in memory if possible
    if ~isFullLengthVideo(vidfile{mov},h_fig)
        h.movie.movie = [];
        h.movie.file = '';
        guidata(h_fig,h);
        [dat,ok] = getFrames(vidfile{mov},'all',viddat{mov},h_fig,true);
        if ~ok
            return
        end
        h = guidata(h_fig);
        if ~isempty(dat.movie)
            h.movie.movie = dat.movie;
            h.movie.file = vidfile{mov};
            guidata(h_fig,h);
            h = guidata(h_fig);
        elseif ~isempty(h.movie.movie)
            h.movie.file = vidfile{mov};
            guidata(h_fig,h);
            h = guidata(h_fig);
        end
    end

    % collect video file parameters
    fDat{1} = vidfile{mov};
    fDat{2}{1} = viddat{mov}{1};
    if isFullLengthVideo(vidfile{mov},h_fig)
        fDat{2}{2} = h.movie.movie;
    else
        fDat{2}{2} = [];
    end
    fDat{3} = viddim{mov};
    fDat{4} = viddat{mov}{3};

    % build traces
    if multichanvid
        [coordsm,traces] = create_trace(coordsm0,pxdim,npix,fDat);
    else
        [coordsm_mv{mov},traces_mv{mov}] = create_trace(...
            coordsm0(:,2*mov-1:2*mov),pxdim,npix,fDat);
        ncoord = size(coordsm_mv{mov},1);
        idcoord{mov} = zeros(1,ncoord);
        for c = 1:ncoord
            idcoord{mov}(c) = find(...
                coordsm0(:,2*mov-1)==coordsm_mv{mov}(c,1) & ...
                coordsm0(:,2*mov)==coordsm_mv{mov}(c,2));
        end
        for c = 1:size(coordsm0,1)
            excl(c) = excl(c) | ~any(idcoord{mov}==c);
        end
    end
end
if ~multichanvid
    traces = [];
    for mov = 1:nMov
        excl_mv = false(1,size(coordsm_mv{mov},1));
        for c = 1:size(coordsm0,1)
           if excl(c) && any(idcoord{mov}==c)
               excl_mv(idcoord{mov}==c) = true;
           end
        end
        coordsm_mv{mov}(excl_mv,:) = [];
        traces_mv{mov}(:,excl_mv) = [];
        traces = cat(3,traces,traces_mv{mov});
    end
    traces = permute(traces,[1,3,2]);
    traces = ...
        reshape(traces,[size(traces,1),size(traces,2)*size(traces,3)]);
    coordsm = coordsm0(~excl,:);
end

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
    
    proj.proj_file = ''; % project file

    proj.pix_intgr = [pxdim npix]; % intgr. area dim. + nb of intgr pix
  
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

