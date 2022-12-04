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

if isMov
    if strcmp(laser,'all')
        % loop uses less memory than "mean"
        for t = 1:vinfo{3}
            aveimg{1} = aveimg{1}+double(h.movie.movie(:,:,t))/vinfo{3};
            for exc = 1:nExc
                if (exc~=nExc && mod(t,nExc)==exc) || ...
                        (exc==nExc && mod(t,nExc)==0)
                    aveimg{1+exc} = aveimg{1+exc}+....
                        nExc*double(h.movie.movie(:,:,t))/vinfo{3};
                end
            end
        end
    else
        % loop uses less memory than "mean"
        if laser==0
            for t = 1:vinfo{3}
                aveimg = aveimg+double(h.movie.movie(:,:,t))/vinfo{3};
            end
        else
            for t = laser:nExc:vinfo{3}
                aveimg = aveimg+nExc*double(h.movie.movie(:,:,t))/vinfo{3};
            end
        end
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
        [dat,ok] = getFrames(vfile,t,vinfo,h_fig,false);
        if ~ok
            return
        end
        if t==1
            vinfo = {dat.fCurs,vinfo{2},vinfo{3}};
        end
        
        if strcmp(laser,'all')
            aveimg{1} = aveimg{1}+double(dat.frameCur)/vinfo{3};
        elseif laser==0
            aveimg = aveimg+double(dat.frameCur)/vinfo{3};
        end

        for exc = 1:nExc
            if strcmp(laser,'all') && ((exc~=nExc && mod(t,nExc)==exc) || ...
                    (exc==nExc && mod(t,nExc)==0))
                aveimg{exc+1} = aveimg{exc+1}+nExc*double(dat.frameCur)/...
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

