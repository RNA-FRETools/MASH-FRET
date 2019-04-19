function [img_ave ok] = createAveIm(param, corr, h_fig)
% Create the average image for all frames obtained at donor excitation
% (first cell) and for all frames obtained at acceptor excitation (second
% cell)

startFrame = param.start; % start data
stopFrame = param.stop; % stop data
iv = param.iv; % interval averaged
fullname = param.file; % path + file
fDat = param.extra; % file data for accelerate reading
resX = fDat{2}(1);
resY = fDat{2}(2);
frameLength = fDat{3};
ok = 0;

if (stopFrame<=frameLength && startFrame>=1)
    img_ave = zeros(resY,resX);
    realLength = numel(startFrame:iv:stopFrame);
    
    if ~isempty(h_fig)
        % loading bar parameters-------------------------------------------
        intrupt = loading_bar('init', h_fig, realLength, ...
            'Build average image...');
        if intrupt
            return;
        end
        h = guidata(h_fig);
        h.barData.prev_var = h.barData.curr_var;
        guidata(h_fig, h);
        % -----------------------------------------------------------------
    end

    for i = startFrame:iv:stopFrame
        [data ok] = getFrames(fullname, i, param.extra, h_fig);
        if ~ok
            return;
        end
        imgNext = data.frameCur;
        if corr && isfield(h.param.movPr, 'bgCorr') && ~isempty(h_fig)
            avBg = h.param.movPr.movBg_one;
            if ~avBg
                imgNext = updateBgCorr(imgNext, h_fig);
            else % Apply only if the bg-corrected frame is displayed
                if avBg == i
                    imgNext = updateBgCorr(imgNext, h_fig);
                end
            end
        elseif (corr && isfield(h.param.movPr, 'bgCorr')) && isempty(h_fig)
            disp(['Background calculation impossible: MASH figure ' ...
                'handle empty.']);
        end
        img_ave = img_ave + single(imgNext)/realLength;
        
        if ~isempty(h_fig)
            % loading bar update-------------------------------------------
            intrupt = loading_bar('update', h_fig);
            if intrupt
                ok = 0;
                return;
            end
            % -------------------------------------------------------------
        end
    end
    
    if ~isempty(h_fig)
        loading_bar('close', h_fig);
    end
    
else
    if ~isempty(h_fig)
        updateActPan('Input parameters inconsitents.', h_fig, 'error');
    else
        disp('Input parameters inconsitents.');
    end
end

