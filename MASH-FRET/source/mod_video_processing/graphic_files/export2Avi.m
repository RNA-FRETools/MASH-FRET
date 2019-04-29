function ok = export2Avi(h_fig, nameMain, pathName)

h = guidata(h_fig);

startFrame = h.param.movPr.mov_start;
lastFrame = h.param.movPr.mov_end;

ok = 1;
intv = 1;

v = VideoWriter(cat(2,pathName,nameMain), 'Uncompressed AVI');
v.FrameRate = 1/h.movie.cyctime;

open(v);

% loading bar parameters--------------------------------------
intrupt = loading_bar('init', h_fig, lastFrame-startFrame+1, ...
    'Export to a *.avi file...');
if ~intrupt

    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
    % ------------------------------------------------------------

    for i = startFrame:intv:lastFrame
        [data ok] = getFrames([h.movie.path h.movie.file], i, ...
            {h.movie.speCursor [h.movie.pixelX h.movie.pixelY] ...
            h.movie.framesTot}, h_fig);
        if ~ok
            return
        end
        img = data.frameCur;
        % Apply background corrections if exist
        if isfield(h.param.movPr, 'bgCorr')
            avBg = h.param.movPr.movBg_one;
            if ~avBg
                img = updateBgCorr(img, h_fig);
            else % Apply only if the bg-corrected frame is displayed
                if avBg == i
                    img = updateBgCorr(img, h_fig);
                end
            end
        end
        
        img_avi = zeros([size(img) 3]);
        img_avi(:,:,1) = img;
        img_avi(:,:,2) = img;
        img_avi(:,:,3) = img;
        img_avi = uint8(255*img_avi/max(max(img)));
        writeVideo(v, img_avi);
        
%         imgAvi = typecast(uint16(img(:)),'uint8');
%         imgAvi = reshape(imgAvi,2,res_y*res_x);
%         imgFin = uint8(zeros(res_y,res_x,3));
%         for r = 1:2
%             imgFin(:,:,r) = uint8(reshape(imgAvi(r,:),res_y,res_x));
%         end
%         writeVideo(v,imgFin);

        % loading bar updating-----------------------------------------
        if ~intrupt
            intrupt = loading_bar('update', h_fig);
        else
            close(v);
            ok = 0;
            return;
        end
        % -------------------------------------------------------------
    end
end
close(v);
loading_bar('close', h_fig);
