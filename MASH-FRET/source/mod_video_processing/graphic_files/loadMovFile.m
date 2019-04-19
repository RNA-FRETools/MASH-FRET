function ok = loadMovFile(n, txt, setMovParam, h_fig)
% Load a new graphic file from MovAnalysis window: store graphical data and
% parameters and update MovAnalysis fields
%
% n = frame number to store or 'all frames'
% txt = text display on the browser
% h_fig = handle to the main figure
%
% Requires external functions: updateActPan, loadFrame, updateImgAxes.

ok = 0;

if ~iscell(txt)
    [fname, pname, o] = uigetfile({ ...
        '*.sif;*.sira;*.tif;*.gif;*.png;*.spe;*.pma;*.crd;*.spots;*.coord;*.avi', ...
        ['Supported Graphic File Format' ...
        '(*.sif,*.sira,*.tif,*.gif,*.png,*.spe,*.pma,*.crd,*.spots,*.coord,*.avi)']; ...
        '*.*', 'All File Format(*.*)'}, txt);
else
    pname = txt{1}; % ex: C:\Users\MASH\Documents\MATLAB\
    fname = txt{2}; % ex: movie.sif
end

if ~isempty(fname) && sum(fname)
    cd(pname);
    
    h = guidata(h_fig);
    if isfield(h, 'axes_movie')
        set(h.axes_movie, 'NextPlot', 'replace');
    end
    
    updateActPan(['Loading file ' fname ' from path :\n', pname], h_fig);
    
    % remove previous movie data
    if isfield(h, 'movie')
        h = rmfield(h, 'movie');
    end
    
    [data ok] = getFrames([pname fname], n, [], h_fig);
    
    if ~ok
        return;
    end
    
    [o, o, fExt] = fileparts(fname);
    switch fExt
        case '.sif'
            fExt = 'sif';
        case '.gif'
            fExt = 'gif';
        case '.png'
            fExt = 'png';
        case '.tif'
            fExt = 'tif';
        case '.TIF'
            fExt = 'tif';
        case '.spe'
            fExt = 'spe'; 
        case '.sira'
            fExt = 'sira';
        case '.pma'
            fExt = 'pma';
        case '.avi'
            fExt = 'avi';
        case '.crd'
            fExt = 'crd';
        case '.coord'
            fExt = 'coord';
        case '.spots'
            fExt = 'spots';
        otherwise
            updateActPan('File format not supported.', h_fig, 'error');
            return;
    end
    
    % Store useful movie data in hanldes.movie variable
    h.param.movPr.SFres = {};
    h.param.movPr.coordTrsf = [];
    h.param.movPr.coordTrsf_file = [];
    h.param.movPr.coordItg = [];
    h.param.movPr.coordItg_file = [];
    h.param.movPr.itg_movFullPth = [];
    h.param.movPr.itg_coordFullPth = [];
    
    h.movie.format = fExt;
    h.movie.file = fname;
    h.movie.path = pname;
    h.movie.framesTot = data.frameLen;
    if ~strcmp(n, 'all')
        h.movie.frameCurNb = n;
    else
        h.movie.frameCurNb = 1;
    end
    h.movie.cyctime = data.cycleTime;
    h.param.movPr.rate = data.cycleTime;
    h.movie.movie = data.movie;
    h.movie.frameCur = data.frameCur; % image data of input (displayed) frame
    h.movie.pixelX = data.pixelX; % width of the movie
    h.movie.pixelY = data.pixelY; % height of the movie
    h.movie.speCursor = data.fCurs; % cursor position in the file where movie data begin
    n_channel = str2num(get(h.edit_nChannel, 'String'));
    sub_w = floor(h.movie.pixelX/n_channel);
    h.movie.split = (1:n_channel-1)*sub_w;
    
    h.param.movPr.mov_start = 1;
    h.param.movPr.mov_end = h.movie.framesTot;
    h.param.movPr.ave_start = 1;
    h.param.movPr.ave_stop = h.movie.framesTot;
    
    h.param.movPr.SFres = {};
        
    guidata(h_fig, h);
    
    if setMovParam
        % If the movie is loaded from the Movie_analysis window, fields are set
        % to their correct value
        txt_split = [];
        for i = 1:size(h.movie.split,2)
            txt_split = [txt_split ' ' num2str(h.movie.split(i))];
        end
        set(h.text_split, 'String', ['Channel splitting: ' txt_split]);
        set(h.text_frameEnd, 'String', num2str(h.movie.framesTot));
        set(h.text_frameCurr, 'String', '1');
        set(h.edit_aveImg_end, 'String', num2str(h.movie.framesTot));
        set(h.edit_startMov, 'String', '1');
        set(h.edit_endMov, 'String', num2str(h.movie.framesTot));
        set(h.text_movW, 'String', num2str(h.movie.pixelX));
        set(h.text_movH, 'String', num2str(h.movie.pixelY));
        set(h.edit_movFile, 'String', h.movie.file);
        set(h.edit_rate, 'String', num2str(h.movie.cyctime), 'Enable', ...
            'on');
        
        % Update slider properties & position     
        if h.movie.framesTot <= 1
            set(h.slider_img, 'Visible', 'off');
        else
            set(h.slider_img, 'Value', 1);
            set(h.slider_img, 'SliderStep', [1/h.movie.framesTot 0.1], ...
                'Min', 1, 'Max', h.movie.framesTot, 'Value', 1, ...
                'Visible', 'on');
        end
        updateImgAxes(h_fig);
        
    end
    
    updateActPan('File loaded!', h_fig, 'success');
    ok = 1;
end
