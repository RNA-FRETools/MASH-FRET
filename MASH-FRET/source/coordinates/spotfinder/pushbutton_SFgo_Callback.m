function pushbutton_SFgo_Callback(obj, evd, h)
h_fig = h.figure_MASH;
h = guidata(h_fig);
p = h.param.movPr;

if isfield(h, 'movie')
    nextMethod = p.SF_method;
    if nextMethod>1 && h.movie.framesTot>1
        loadAveIm = questdlg('Load the average image first?');
        if strcmp(loadAveIm, 'Yes')
            cd(setCorrectPath('average_images', h_fig));
            loadMovFile(1, 'Select a graphic file:', 1, h_fig);
            h = guidata(h_fig);
            p = h.param.movPr;
        elseif strcmp(loadAveIm, 'Cancel')
            return;
        end
    end
    if ~(isfield(h, 'movie') && isfield(h.movie, 'frameCur') && ...
            ~isempty(h.movie.frameCur))
        return;
    end

    p.SFres = {};
    
    if nextMethod > 1
        p.SFres{1,1} = [nextMethod p.SF_gaussFit h.movie.frameCurNb];
    end

    if ~isempty(p.SFres)
        nC = h.param.movPr.nChan;
        for i = 1:nC
            p.SFres{1,i+1} = [p.SF_w(i), p.SF_h(i); p.SF_darkW(i), ...
                p.SF_darkH(i); p.SF_intThresh(i) p.SF_intRatio(i)];
        end
    end
    h.param.movPr = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'imgAxes');
    
else
    updateActPan('No graphic file loaded!', h_fig, 'error');
end