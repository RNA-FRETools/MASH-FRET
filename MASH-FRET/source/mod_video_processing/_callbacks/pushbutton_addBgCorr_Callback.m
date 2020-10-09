function pushbutton_addBgCorr_Callback(obj, evd, h_fig)
h = guidata(h_fig);
if isfield(h, 'movie')
    p = h.param.movPr;
    nextMethod = p.movBg_method;
    if nextMethod > 1
        if nextMethod == 17 % image subtraction
            dat = getFile2sub('Pick an image to subtract', h_fig);
            if isempty(dat)
                return;
            end
            p.bgCorr{size(h.param.movPr.bgCorr,1)+1,1} = nextMethod;
            p.movBg_p{nextMethod,1} = dat;
            
        else
            if sum(double(nextMethod == [2 5:10])) && ~exist('FilterArray')
                setContPan(cat(2,'This filter can not be used: problem ',...
                    'with mex compilation.'),'error',h_fig);
                return;
            end
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
    guidata(h_fig, h);
    updateFields(h_fig, 'imgAxes');
else
    updateActPan('No graphic file loaded!', h_fig, 'error');
end