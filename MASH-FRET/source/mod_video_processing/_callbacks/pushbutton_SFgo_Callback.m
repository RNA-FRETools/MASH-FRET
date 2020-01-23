function pushbutton_SFgo_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.movPr;

if ~isfield(h, 'movie')
    updateActPan('No graphic file loaded!', h_fig, 'error');
    return
end

nextMethod = p.SF_method;
if nextMethod>1 && h.movie.framesTot>1
    loadAveIm = questdlg('Load the average image first?');
    if ~strcmp(loadAveIm, 'Yes')
        return
    end

    cd(setCorrectPath('average_images', h_fig));
    if ~loadMovFile(1,'Select a graphic file:',1,h_fig);
        return
    end
    
    h = guidata(h_fig);
    h.param.movPr.itg_movFullPth = [h.movie.path h.movie.file];
    h.param.movPr.rate = h.movie.cyctime;
    p = h.param.movPr;
    guidata(h_fig, h);
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
