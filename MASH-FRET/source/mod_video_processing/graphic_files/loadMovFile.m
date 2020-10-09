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
    [fname,pname,o] = uigetfile({cat(2,'*.sif;*.sira;*.tif;*.gif;*.png;',...
        '*.spe;*.pma;*.crd;*.spots;*.coord;*.avi'), ...
        ['Supported Graphic File Format',cat(2,'(*.sif,*.sira,*.tif,',...
        '*.gif,*.png,*.spe,*.pma,*.crd,*.spots,*.coord,*.avi)')]; ...
        '*.*','All File Format(*.*)'},txt);
else
    pname = txt{1}; % ex: C:\Users\MASH\Documents\MATLAB\
    fname = txt{2}; % ex: movie.sif
end

if ~isempty(fname) && sum(fname)
    
    updateActPan(['Loading file ' fname ' from path :\n', pname], h_fig);
    cd(pname);
    
    % collect data from figure
    h = guidata(h_fig);

    % remove previous video data
    h.movie.movie = [];
    
    % reset video processing parameters
    h.param.movPr.SFres = {};
    h.param.movPr.coordTrsf = [];
    h.param.movPr.coordTrsf_file = [];
    h.param.movPr.coordItg = [];
    h.param.movPr.coordItg_file = [];
    h.param.movPr.itg_movFullPth = [];
    h.param.movPr.itg_coordFullPth = [];
    
    % save changes
    guidata(h_fig,h);
    
    % get video data
    [data,ok] = getFrames([pname fname], n, [], h_fig, true);
    if ~ok
        return;
    end
    
    % recover possibly refilled video data if previously allocated
    h = guidata(h_fig);
    
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

    % store movie parameters
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
    
    if ~(isfield(h.movie,'movie') && ~isempty(h.movie.movie))
        h.movie.movie = data.movie;
    end
    
    if isfield(h.movie,'movie') && ~isempty(h.movie.movie)
        set(h.pushbutton_VP_freeMem,'backgroundcolor',[1,0.6,0.6]);
    else
        set(h.pushbutton_VP_freeMem,'backgroundcolor',...
            get(h.pushbutton_VP_freeMem,'userdata'));
    end
    
    h.movie.frameCur = data.frameCur; % image data of input (displayed) frame
    h.movie.pixelX = data.pixelX; % width of the movie
    h.movie.pixelY = data.pixelY; % height of the movie
    h.movie.speCursor = data.fCurs; % cursor position in the file where movie data begin
    n_channel = str2num(get(h.edit_nChannel, 'String'));
    sub_w = floor(h.movie.pixelX/n_channel);
    h.movie.split = (1:n_channel-1)*sub_w;
    
    % store video processing parameters
    h.param.movPr.mov_start = 1;
    h.param.movPr.mov_end = h.movie.framesTot;
    h.param.movPr.ave_start = 1;
    h.param.movPr.ave_stop = h.movie.framesTot;

    guidata(h_fig, h);
    
    % update VP fields if specified as such
    if setMovParam
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
    end
    
    updateActPan('File loaded!', h_fig, 'success');
    ok = 1;
end
