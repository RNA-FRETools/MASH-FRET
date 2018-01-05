function pushbutton_addBgCorr_Callback(obj, evd, h)
if isfield(h, 'movie')
    p = h.param.movPr;
    nextMethod = p.movBg_method;
    if nextMethod > 1
        if nextMethod == 17 % image subtraction
            dat = getFile2sub('Pick an image to subtract', h.figure_MASH);
            if isempty(dat)
                return;
            end
            p.bgCorr{size(h.param.movPr.bgCorr,1)+1,1} = nextMethod;
            p.movBg_p{nextMethod,1} = dat;
            
        else
            p.bgCorr{size(p.bgCorr,1)+1,1} = nextMethod;
            nC = p.nChan;
            if nextMethod ~= 17
                for i = 1:nC
                    p.bgCorr{end,i+1} = p.movBg_p{nextMethod,i};
                end
            end
        end
        if p.movBg_one
            p.movBg_one = h.movie.frameCurNb;
        end
    end
    h.param.movPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'imgAxes');
else
    updateActPan('No graphic file loaded!', h.figure_MASH, 'error');
end