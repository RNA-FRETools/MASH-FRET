function [data,ok] = readBf(fullFname, n, fDat, h_fig, useMov)

% defaults
ok = 1;
cycleTime = 1; % arbitrary time delay between each frame
data = [];
movie = [];
exc = [];
isMov = 0; % no movie variable was defined before (no memory is allocated)
nbit = 4; % 4: single, 8: double

% control video data
if ~isempty(h_fig)
    h = guidata(h_fig);
    if isFullLengthVideo(fullFname,h_fig)
        isMov = 2; % the movie variable exist and contain the video file data
    elseif isfield(h,'movie') && isfield(h.movie,'movie') && ...
            isempty(h.movie.movie)
        isMov = 1; % the movie variable exist and is free (free memory already allocated)
    end
end
if ~useMov
    isMov = 0;
end

% identify already-opened loading bar
islb = isfield(h,'barData');

if isempty(fDat)
    % get video dimensions
    bfInitLogging();
    r = bfGetReader(fullFname, 0);
    
    frameLen = r.getImageCount(); % video length
    img = bfGetPlane(r, 1);

    pixelY = size(img,2); % height of the movie after 90° rotation
    pixelX = size(img,1); % width of the movie after 90° rotation
    
    % get sampling time and laser order
    txt_exc = '';
    try
        [props,excord] = readBf_props(fullFname);
        t_str = props(contains(props(:,1),...
            regexpPattern('^(Value #)[0-9]*$')),2);
        u_str = props(contains(props(:,1),...
            regexpPattern('^(Units #)[0-9]*$')),2);
        exc_str = props(contains(props(:,1),...
            regexpPattern('^(Channel name #)[0-9]*$')),2);
        
        t = NaN(frameLen,1);
        for l = 1:frameLen
            s_fact = getSecondsFromString(u_str{l,1});
            t(l) = str2num(t_str{l,1})*s_fact;
        end
        t = sort(t);
        cycleTime = t(2)-t(1);
        txt = num2str(cycleTime);
        
        nExc = numel(exc_str);
        for l = 1:nExc
            if contains(exc_str{l},'TIRF')
                exc = cat(2,exc,str2num(exc_str{l}(1:end-length('TIRF'))));
            end
        end
        if ~isempty(exc) && numel(exc)==numel(excord)
            exc = exc(excord);
            txt_exc = 'Lasers = ';
            for l = 1:numel(exc)
                if l==1
                    txt_exc = cat(2,txt_exc,num2str(exc(l)),'nm');
                else
                    txt_exc = cat(2,txt_exc,', ',num2str(exc(l)),'nm');
                end
            end
        else
            exc = [];
        end
        
    catch err
        disp('/!\ unable to read sampling time from file.')
        txt = ['arbitrary ' num2str(cycleTime)];
    end
    
    [~,~,fext] = fileparts(fullFname);
    if ~isempty(h_fig)
        updateActPan(['Bioformat (*',fext,')\n' ...
            'Cycle time = ' txt 's-1\n' ...
            'Movie dimensions = ' num2str(pixelX) 'x' num2str(pixelY) ...
            ' pixels\n' ...
            'Movie length = ' num2str(frameLen) ' frames\n' ...
            txt_exc], h_fig);
    else
        fprintf(['\nBioformat (*',fext,')\n' ...
            'Cycle time = ' txt 's-1\n' ...
            'Movie dimensions = ' num2str(pixelX) 'x' num2str(pixelY) ...
            ' pixels\n' ...
            'Movie length = ' num2str(frameLen) ' frames\n' ...
            txt_exc]);
    end
else
    pixelX = fDat{2}(1);
    pixelY = fDat{2}(2);
    frameLen = fDat{3};
end

% get video frames
if strcmp(n,'all')
    if (isMov==0 || isMov==1) && ~memAlloc(pixelX*pixelY*(frameLen+1)*nbit)
        str = cat(2,'Out of memory: MASH is obligated to load the video ',...
            'one frame at a time to function\nThis will slow down all ',...
            'operations requiring video data, including the creation of ',...
            'time traces.');
        if ~isempty(h_fig)
            setContPan(str,'warning',h_fig);
        else
            fprintf([str,'\n']);
        end

        [data,ok] = readBf(fullFname,1,fDat,h_fig,0);
        frameCur = data.frameCur;

    else
        if ~islb 
            if loading_bar('init',h_fig, frameLen,...
                'Import BF video...')
                ok = 0;
                return
            end
            h = guidata(h_fig);
            h.barData.prev_var = h.barData.curr_var;
            guidata(h_fig, h);
        else
            setContPan('Import BF video...','',h_fig);
        end
        
        if ~exist('r','var')
            bfInitLogging();
            r = bfGetReader(fullFname, 0);
        end
        if isMov==0
            % allocate new memory
            movie = repmat(single(0),pixelY,pixelX,frameLen);
            for i = 1:frameLen
                img = bfGetPlane(r, i);
                if size(img,3)>1
                    img = sum(img,3);
                end
                movie(:,:,i) = single(img');   
                
                if ~islb && loading_bar('update', h_fig)
                    ok = 0;
                    return
                end
            end
            frameCur = movie(:,:,1);
            
        else
            % re-use previously allocated memory
            h.movie.movie = repmat(single(0),pixelY,pixelX,frameLen);

            for i = 1:frameLen
                img = bfGetPlane(r, i);
                if size(img,3)>1
                    img = sum(img,3);
                end
                h.movie.movie(:,:,i) = single(img');
                if ~islb && loading_bar('update', h_fig)
                    ok = 0;
                    return
                end
            end
            guidata(h_fig,h);
            frameCur = h.movie.movie(:,:,1);
        end
        if ~islb && ~isempty(h_fig)
            loading_bar('close', h_fig);
        end
    end
    
else
    if isMov==2
        frameCur = h.movie.movie(:,:,n);
    else
        if ~exist('r','var')
            bfInitLogging();
            r = bfGetReader(fullFname, 0);
        end
        frameCur = bfGetPlane(r, n)';
        if size(frameCur,3)>1
            frameCur = sum(frameCur,3);
        end
        movie = [];
    end
end

if exist('r','var')
    r.close();
end
 
data = struct('cycleTime', cycleTime, ...
              'pixelY', pixelY, ...
              'pixelX', pixelX, ...
              'frameLen', frameLen, ...
              'fCurs', [], ...
              'frameCur', frameCur, ...
              'movie', movie);
if ~isempty(exc)
    data.lasers = exc;
end
        
