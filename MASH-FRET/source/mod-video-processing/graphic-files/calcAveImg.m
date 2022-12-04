function aveimg = calcAveImg(laser,vfile,vinfo,nExc,h_fig,varargin)
% aveimg = calcAveImg(laser,vfile,vinfo,nExc,h_fig)
% aveimg = calcAveImg(laser,vfile,vinfo,nExc,h_fig,frames)
%
% Calculate laser-specific average images
%
% laser: first frame index of specific laser illumination, or 'all' to calculate the average over all laser illuminations
% vfile: full path to video file
% vinfo: {1-by-3} video info:
%  vinfo{1}: position in file where to read pixel values
%  vinfo{2}: x and y pixel dimensions
%  vinfo{3}: video length
% nExc: if argument 'laser' is set to 'all' nExc is the number of alternating lasers
% h_fig: handle to main figure
% frames: video frame indexes 
% aveimg: average images:
%  if argument 'laser' is an index, aveimg is a matrix
%  if argument 'laser' is 'all', aveimg is a {1-by-nExc+1} with 
%    aveImg{1} being the average over all laser illuminations
%    aveImg{1+exc} being the average over frames illuminated by laser with
%     index exc

h = guidata(h_fig);

% control full-length video
isMov = isFullLengthVideo(vfile,h_fig);

% control loadingbar
isLb = isfield(h,'barData');

% initializes image
if strcmp(laser,'all')
    aveimg = cell(1,nExc+1);
    for exc = 1:(nExc+1)
        aveimg{exc} = zeros(flip(vinfo{2}));
    end
else
    aveimg = zeros(flip(vinfo{2}));
end

% get frame indexes
if ~isempty(varargin)
    frames = varargin{1};
else
    frames = 1:vinfo{3};
end

% calculate average images
if isMov
    if strcmp(laser,'all')
        % loop uses less memory than "mean"
        L = zeros(1,nExc+1);
        for t = frames
            aveimg{1} = aveimg{1}+double(h.movie.movie(:,:,t));
            L(1) = L(1)+1;
            for exc = 1:nExc
                if (exc~=nExc && mod(t,nExc)==exc) || ...
                        (exc==nExc && mod(t,nExc)==0)
                    aveimg{1+exc} = aveimg{1+exc}+....
                        nExc*double(h.movie.movie(:,:,t));
                    L(1+exc) = L(1+exc)+1;
                end
            end
        end
        aveimg{1} = aveimg{1}/L(1);
        for exc = 1:nExc
            aveimg{1+exc} = aveimg{1+exc}/L(1+exc);
        end
        
    else
        % loop uses less memory than "mean"
        if laser==0
            for t = frames
                aveimg = aveimg+double(h.movie.movie(:,:,t));
            end
            aveimg = aveimg/numel(frames);
        else
            L = 0;
            for t = frames
                if (laser~=nExc && mod(t,nExc)==laser) || ...
                        (laser==nExc && mod(t,nExc)==0)
                    aveimg = aveimg+double(h.movie.movie(:,:,t));
                    L = L+1;
                end
            end
            aveimg = aveimg/L;
        end
    end
    
else
    % open loading bar
    if ~isLb && loading_bar('init',h_fig,numel(frames),...
            'Calculate average images...')
        return
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
    
    % calculate average images
    L = zeros(1,nExc+1);
    for t = frames
        [dat,ok] = getFrames(vfile,t,vinfo,h_fig,false);
        if ~ok
            return
        end
        if t==1
            vinfo = {dat.fCurs,vinfo{2},vinfo{3}};
        end
        
        L(1) = L(1)+1;
        if strcmp(laser,'all')
            aveimg{1} = aveimg{1}+double(dat.frameCur);
        elseif laser==0
            aveimg = aveimg+double(dat.frameCur);
        end

        for exc = 1:nExc
            if strcmp(laser,'all') && ((exc~=nExc && mod(t,nExc)==exc) || ...
                    (exc==nExc && mod(t,nExc)==0))
                aveimg{exc+1} = aveimg{exc+1}+double(dat.frameCur);
                L(exc+1) = L(exc+1)+1;

            elseif ~strcmp(laser,'all') && ...
                    ((laser~=nExc && mod(t,nExc)==laser) || ...
                    (laser==nExc && mod(t,nExc)==0))
                aveimg = aveimg+double(dat.frameCur);
                L(exc+1) = L(exc+1)+1;
            end
        end
        if ~isLb && loading_bar('update',h_fig)
            return
        end
    end
    if strcmp(laser,'all')
        aveimg{1} = aveimg{1}/L(1);
        for exc = 1:nExc
            aveimg{1+exc} = aveimg{1+exc}/L(1+exc);
        end
    elseif laser==0
        aveimg = aveimg/L(1);
    else
        aveimg = aveimg/L(laser);
    end
    if ~isLb
        loading_bar('close',h_fig);
    end
end

