function aveimg = calcAveImg(laser,vfile,vinfo,nExc,h_fig)
% aveimg = calcAveImg(laser,vfile,vinfo,nExc,h_fig)
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
% aveimg: average images:
%  if argument 'laser' is a frame index, aveimg is a matrix
%  if argument 'laser' is 'all', aveimg is a {1-by-nExc+1} with 
%    aveImg{1} being the average over all laser illuminations

% control full-length video
isMov = isFullLengthVideo(h_fig);

% control loadingbar
h = guidata(h_fig);
isLb = isfield(h,'barData');

% initializes image
if strcmp(laser,'all')
    aveimg = cell(1,nExc+1);
    for l = 1:(nExc+1)
        aveimg{l} = zeros(flip(vinfo{2}));
    end
else
    aveimg = zeros(flip(vinfo{2}));
end

if isMov
    if strcmp(laser,'all')
        aveimg{1} = mean(h.movie.movie,3);
        for l = 1:nExc
            aveimg{l+1} = mean(h.movie.movie(:,:,l:nExc:end),3);
        end
    else
        aveimg = mean(h.movie.movie(:,:,laser:nExc:end),3);
    end
else
    % open loading bar
    if ~isLb && loading_bar('init',h_fig,vinfo{3},...
            'Calculate average images...')
        return
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
    
    % calculate average images
    for t = 1:vinfo{3}
        [dat,ok] = getFrames(vfile,t,vinfo,h_fig,true);
        if ~ok
            return
        end
        if strcmp(laser,'all')
            aveimg{1} = aveimg{1}+double(dat.frameCur)/vinfo{3};
        end

        for l = 1:nExc
            if strcmp(laser,'all') && ((l~=nExc && mod(t,nExc)==l) || ...
                    (l==nExc && mod(t,nExc)==0))
                aveimg{l+1} = aveimg{l+1}+nExc*double(dat.frameCur)/...
                    vinfo{3};

            elseif ~strcmp(laser,'all') && ...
                    ((laser~=nExc && mod(t,nExc)==laser) || ...
                    (laser==nExc && mod(t,nExc)==0))
                aveimg = aveimg+nExc*double(dat.frameCur)/vinfo{3};
            end
        end
        if ~isLb && loading_bar('update',h_fig)
            return
        end
    end
    if ~isLb
        loading_bar('close',h_fig);
    end
end

