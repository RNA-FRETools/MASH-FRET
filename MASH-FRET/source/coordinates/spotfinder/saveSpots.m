function [spots pname fname] = saveSpots(h_fig)
% Save spots coordinates to *.spots file and image of spots to *.png file.

% Requires external functions: getCorrName, setCorrectPath, getFrames,
%                              updateBgCorr, updateSF, updateActPan.
% Last update: 9th of February 2014 by Mélodie C.A.S Hadzic

spots = [];
pname = [];
fname = [];

h = guidata(h_fig);
p = h.param.movPr;
if isfield(p, 'SFres') && isfield(h, 'movie')
    
    [o, nameMov, o] = fileparts(h.movie.file);
    defName = [setCorrectPath('spotfinder', h_fig) nameMov '.spots'];
    [fname,pname,o] = uiputfile({ ...
        '*.spots', 'Coordinates file(*.spots)'; ...
        '*.*', 'All files(*.*)'}, 'Export coordinates', defName);
    
    if ~isempty(fname) && sum(fname)
        [o,fname,o] = fileparts(fname);
        fname_spots = getCorrName([fname '.spots'], pname, h_fig);
        
        if ~isempty(fname) && sum(fname)
            cd(pname);
            [o,fname,o] = fileparts(fname_spots);
            fname_spots = [pname fname '.spots'];
            
            all = p.SF_all;
            if all
                frames = 1:h.movie.framesTot;
            else
                frames = h.movie.frameCurNb;
            end

            spots = [];
            
            % loading bar parameters---------------------------------------
            err = loading_bar('init', h_fig, numel(frames), ...
                'Targetting molecules on all movie frames...');
            if err
                return;
            end
            h = guidata(h_fig);
            h.barData.prev_var = h.barData.curr_var;
            guidata(h_fig, h);
            % -------------------------------------------------------------

            for n = frames
                if numel(frames) > 1 && size(p.SFres,1) >= 1
                    p.SFres = p.SFres(1,1:(1+p.nChan));
                end
                h.param.movPr = p;
                guidata(h_fig, h);
                [dat,ok] = getFrames([h.movie.path h.movie.file], n, ...
                    {h.movie.speCursor, [h.movie.pixelX h.movie.pixelY],...
                    h.movie.framesTot}, h_fig);
                if ~ok
                    return;
                end
                img = dat.frameCur;
                img = updateBgCorr(img, h_fig);
                updateSF(img, true, h_fig);
                err = loading_bar('update', h_fig);
                if err
                    return;
                end
                h = guidata(h_fig);
                p = h.param.movPr;
                for i = 1:p.nChan
                    spots = [spots; [p.SFres{2,i} ...
                        ones(size(p.SFres{2,i},1), 1)*n]];
                end
            end
            
            if ~err
                loading_bar('close', h_fig);
            end

            str_header = 'x\ty\tI\tframe';
            str_frmt = '%d\t%d\t%d\t%d';
            if size(spots,2) > 4
                if p.perSec
                    spots(:,[3,8]) = spots(:,[3,8])/h.movie.cyctime;
                    headUn = '(a.u./s)';
                else
                    headUn = '(a.u.)';
                end
                str_header = ['x\ty\tI' headUn '\tassymetry\twidth\t' ...
                    'height\ttheta\tz-offset' headUn '\tframe'];
                str_frmt = '%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d';
            end
            str_header = strcat(str_header, '\n');
            str_frmt = strcat(str_frmt, '\n');

            f = fopen(fname_spots, 'Wt');
            fprintf(f, str_header);
            fprintf(f, str_frmt, spots');
            fclose(f);
            
            gaussFit = p.SF_gaussFit;
            menuStr = get(h.popupmenu_SF, 'String');
            str_mthd = strcat(' ', menuStr{p.SF_method});
            str_minI = num2str(p.SF_minI(1)); 
            str_maxN = num2str(p.SF_maxN(1));
            str_minDs = num2str(p.SF_minDspot(1));
            str_minDe = num2str(p.SF_minDedge(1));
            
            if gaussFit
                str_mthd = strcat(str_mthd, ' + Gaussian fit');
                str_spotDim = strcat(num2str(p.SF_w(1)), 'x', ...
                    num2str(p.SF_h(1)));
                str_wLim = strcat(' [', num2str(p.SF_minHWHM(1)), ', ', ...
                    num2str(p.SF_maxHWHM(1)), ']');
                str_ass = num2str(p.SF_maxAssy(1));
            end

            if p.SF_method == 4
                str_intThresh = num2str(p.SF_intRatio(1));
            else
                str_intThresh = num2str(p.SF_intThresh(1));
                str_darkDim = strcat(num2str(p.SF_darkW(1)), 'x', ...
                    num2str(p.SF_darkH(1)));
            end
            
            if p.nChan > 1
                for i = 2:p.nChan
                    if p.SF_method == 4
                        str_intThresh = strcat(str_intThresh, ', ', ...
                            num2str(p.SF_intRatio(i)));
                    else
                        str_intThresh = strcat(str_intThresh, ', ', ...
                            num2str(p.SF_intThresh(i)));
                        str_darkDim = strcat(str_darkDim, ', ', ...
                            num2str(p.SF_darkW(i)), 'x', ...
                            num2str(p.SF_darkH(i)));
                    end

                    str_minI = strcat(str_minI, ', ', ...
                        num2str(p.SF_minI(i)));
                    str_maxN = strcat(str_maxN, ', ',...
                        num2str(p.SF_maxN(i)));
                    str_minDs = strcat(str_minDs, ', ', ...
                        num2str(p.SF_minDspot(i)));
                    str_minDe = strcat(str_minDe, ', ', ...
                        num2str(p.SF_minDedge(i)));
                    
                    if gaussFit
                        str_spotDim = strcat(str_spotDim, ', ', ...
                            num2str(p.SF_w(i)), 'x', num2str(p.SF_h(i)));
                        str_wLim = strcat(str_wLim, ' [', ...
                            num2str(p.SF_minHWHM(i)), ', ', ...
                            num2str(p.SF_maxHWHM(i)), ']');
                        str_ass = strcat(str_ass, ', ', ...
                            num2str(p.SF_maxAssy(i)));
                    end
                end
            end
            if p.SF_method == 4
                str_intThresh = strcat( ...
                    'detection intensity threshold = ', str_intThresh);
                str_darkDim = '';
            else
                str_intThresh = strcat( ...
                    'min. detection intensity(cnt/s) = ', str_intThresh);
                str_darkDim = strcat('dark area dimensions(pixels) = ', ...
                    str_darkDim, '\n');
            end
            str_gaussPrm = [];
            if gaussFit
                str_gaussPrm = strcat( ...
                    'spot dimensions(pixels) = ', str_spotDim, '\n', ...
                    '\n2D Gaussian width limits(pixels) = ', str_wLim, ...
                    '\nmax. 2D Gaussian assymetry(%) = ', str_ass);
            end

            updateActPan(strcat('Spotfinder parameters:\n', ...
                'method: ', str_mthd, '\n', ...
                str_intThresh, '\n', ...
                str_darkDim, ...
                'min. intensity(cnt/s) = ', str_minI, '\n', ...
                'max. spot number =', str_maxN, '\n', ...
                'min. inter-spot distance(pixels) = ', str_minDs, '\n', ...
                'min. spot-image edges distance(pixels) = ', str_minDe, ...
                str_gaussPrm), h_fig);
        end
        
    end
end

