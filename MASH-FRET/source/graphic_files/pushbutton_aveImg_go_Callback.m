function pushbutton_aveImg_go_Callback(obj, evd, h)
set(h.edit_aveImg_iv, 'String', h.param.movPr.ave_iv, ...
    'BackgroundColor', [1 1 1]);
set(h.edit_aveImg_start, 'String', h.param.movPr.ave_start, ...
    'BackgroundColor', [1 1 1]);
set(h.edit_aveImg_end, 'String', h.param.movPr.ave_stop, ...
    'BackgroundColor', [1 1 1]);
if isfield(h, 'movie')
    param.start = h.param.movPr.ave_start;
    param.stop = h.param.movPr.ave_stop;
    param.iv = h.param.movPr.ave_iv;
    param.file = [h.movie.path h.movie.file];
    param.extra{1} = h.movie.speCursor;
    param.extra{2} = [h.movie.pixelX h.movie.pixelY]; 
    param.extra{3} = h.movie.framesTot;
    
    [img_ave ok] = createAveIm(param, 1, h.figure_MASH);
    
    if ~ok
        return;
    end
    
    [o, nameMov, o] = fileparts(h.movie.file);
    defName = [setCorrectPath('average_images', h.figure_MASH) nameMov ...
        '_ave'];
    [fname,pname,o] = uiputfile({ ...
        '*.sira', 'SIRA Graphic File Format(*.sira)'; ...
        '*.png', 'Portable Network Graphics(*.png)'; ...
        '*.tif', 'Tagged Image File Format(*.tif)'; ...
        '*.*', 'All files(*.*)'}, ...
        'Export average image', defName);
    
    if ~isempty(fname) && sum(fname)
        cd(pname);
        [o,name,fext] = fileparts(fname);
        if ~sum(double(strcmp(fext, {'.png' '.tif' '.sira'})))
            fname = [name '.png'];
        end
        fname = getCorrName(fname, pname, h.figure_MASH);
        h = guidata(h.figure_MASH);
        
        if strcmp(fext, '.png')
            imwrite(uint16(65535*(img_ave-min(min(img_ave)))/ ...
                (max(max(img_ave))-min(min(img_ave)))), [pname fname], ...
                'png', 'BitDepth', 16, 'Description', ...
                [num2str(h.movie.cyctime) ' ' num2str(max(max(img_ave)))...
                ' ' num2str(min(min(img_ave)))]);
            
        elseif strcmp(fext, '.tif')
            min_img = min(min(round(img_ave)));
            if min_img >= 0
                min_img = 0;
            end
            img_16 = uint16(round(img_ave)+abs(min_img));
            imwrite(img_16, [pname fname], 'tif', 'WriteMode', ...
                'overwrite', 'Description', ...
                sprintf('%d\t%d', h.movie.cyctime, min_img));
            
        elseif strcmp(fext, '.sira')
            f = fopen([pname fname], 'w');
            if f == -1
                updateActPan(['Enable to open file ' fname], ...
                    h.figure_MASH);
                return;
            else
                figname = get(h.figure_MASH, 'Name');
                vers = figname(length('MASH smFRET '):end);
                fprintf(f, ['MASH smFRET exported binary graphic ' ...
                    'Version: %s\r'], vers);
                fwrite(f, double(h.movie.cyctime), 'double');
                fwrite(f, single(h.movie.pixelX), 'single');
                fwrite(f, single(h.movie.pixelY), 'single');
                fwrite(f, single(1), 'single');
                min_img = min(min(img_ave));
                if min_img >= 0
                    min_img = 0;
                end
                img_ave = single(img_ave+abs(min_img));
                imgBin = [reshape(img_ave,1,h.movie.pixelY* ...
                    h.movie.pixelX) single(abs(min_img))];
                fwrite(f, imgBin, 'single');
                fclose(f);
            end
        end
        
        updateActPan(['The average image (' num2str(param.start) ':' ...
            num2str(param.iv) ':' num2str(param.stop) ...
            ') has been saved to file: ' fname '\nin folder: ' pname], ...
            h.figure_MASH, 'success');
    end
end