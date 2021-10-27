function [data,ok] = readTif_OME(fullFname, n, fDat, h_fig, useMov)

% defaults
ok = 1;
cycleTime = 1; % arbitrary time delay between each frame
data = [];
movie = [];
exc = [];

h = guidata(h_fig);
isMov = 0; % no movie variable was defined before (no memory is allocated)
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

if isempty(fDat)
    % get video infos
    fCurs = imfinfo(fullFname); % information array of .tif file
    frameLen = numel(fCurs); % number total of frames    
    txt = ['arbitrary ' num2str(cycleTime)];
    txt_exc = '';
    if isfield(fCurs(1,1),'ImageDescription')
        descr = fCurs(1,1).ImageDescription;
        [cycleTime,lord,exc] = getTIFOME_metadata(descr);
        if ~isempty(cycleTime) && ~isnan(cycleTime)
            txt = num2str(cycleTime);
        end
        if ~isempty(exc)
            txt_exc = 'Lasers = ';
            for l = 1:numel(exc)
                if l==1
                    txt_exc = cat(2,txt_exc,num2str(exc(l)),'nm');
                else
                    txt_exc = cat(2,txt_exc,', ',num2str(exc(l)),'nm');
                end
            end
            txt_exc = cat(2,txt_exc,'\n');
        end
    end
    pixelY = fCurs(1,1).Width; % height of the movie after 90° rotation
    pixelX = fCurs(1,1).Height; % width of the movie after 90° rotation
    
    if ~isempty(h_fig)
        updateActPan(['Tagged Image File Format(*.tiff)\n' ...
            'Cycle time = ' txt 's-1\n' ...
            'Movie dimensions = ' num2str(pixelX) 'x' num2str(pixelY) ...
            ' pixels\n' ...
            'Movie length = ' num2str(frameLen) ' frames\n' ...
            txt_exc], h_fig);
    else
        fprintf(['\nTagged Image File Format(*.tiff)\n' ...
            'Cycle time = ' txt 's-1\n' ...
            'Movie dimensions = ' num2str(pixelX) 'x' num2str(pixelY) ...
            ' pixels\n' ...
            'Movie length = ' num2str(frameLen) ' frames\n' ...
            txt_exc]);
    end
else
    fCurs = fDat{1}{1};
    lord = fDat{1}{2};
    frameLen = fDat{3};
    pixelX = fDat{2}(1);
    pixelY = fDat{2}(2);
end

if strcmp(n,'all')
    if (isMov==0 || isMov==1) && ~memAlloc(pixelX*pixelY*(frameLen+1)*4)
        str = cat(2,'Out of memory: MASH is obligated to load the video ',...
            'one frame at a time to function\nThis will slow down all ',...
            'operations requiring video data, including the creation of ',...
            'time traces.');
        if ~isempty(h_fig)
            setContPan(str,'warning',h_fig);
        else
            fprintf([str,'\n']);
        end

        [data,ok] = readTif_OME(fullFname,1,fDat,h_fig,0);
        frameCur = data.frameCur;

    else
        if loading_bar('init',h_fig, frameLen,...
                'Import movie frames from file...')
            ok = 0;
            return
        end
        h = guidata(h_fig);
        h.barData.prev_var = h.barData.curr_var;
        guidata(h_fig, h);
        
        if isMov==0
            % allocate new memory
            movie = zeros(pixelY,pixelX,frameLen);
            for i = 1:frameLen
                movie(:,:,i) = double(imread(fullFname,'Index',i,'Info',...
                    fCurs))';   
                
                if loading_bar('update', h_fig)
                    ok = 0;
                    return
                end
            end
            movie = movie(:,:,lord);
            frameCur = movie(:,:,1);
            
        else
            % re-use previously allocated memory
            h.movie.movie = zeros(pixelY,pixelX,frameLen);

            for i = 1:frameLen
                img = double(imread(fullFname,'Index',i,'Info',fCurs));
                if size(img,3)>1
                    img = sum(img,3);
                end
                h.movie.movie(:,:,lord==i) = img';
                if loading_bar('update', h_fig)
                    ok = 0;
                    return
                end
            end
            guidata(h_fig,h);
            frameCur = h.movie.movie(:,:,1);
        end
        if ~isempty(h_fig)
            loading_bar('close', h_fig);
        end
    end
    
else
    if isMov==2
        frameCur = h.movie.movie(:,:,n);
    else
        frameCur = double(imread(fullFname,'Index',lord(n),'Info',fCurs))';
        if size(frameCur,3)>1
            frameCur = sum(frameCur,3);
        end
        movie = [];
    end
end
 
data = struct('cycleTime', cycleTime, ...
              'pixelY', pixelY, ...
              'pixelX', pixelX, ...
              'frameLen', frameLen, ...
              'frameCur', frameCur, ...
              'movie', movie);
data.fCurs = {fCurs,lord};
if ~isempty(exc)
    data.lasers = exc;
end
        
