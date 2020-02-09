function pushbutton_SFgo_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

if ~isfield(h, 'movie')
    updateActPan('No graphic file loaded!', h_fig, 'error');
    return
end

% get spotfinder method
meth = p.SF_method;
if meth==1
    return
end

% ask to load average image
if h.movie.framesTot>1
    loadAveIm = questdlg('Load the average image first?');
    if ~strcmp(loadAveIm, 'Yes') || ~strcmp(loadAveIm, 'No')
        return
    end
    
    % import average image
    if strcmp(loadAveIm, 'Yes')
        cd(setCorrectPath('average_images', h_fig));
        if ~loadMovFile(1,'Select a graphic file:',1,h_fig);
            return
        end

        % recover modifications
        h = guidata(h_fig);
        p = h.param.movPr;

        % set video file for intensity integration
        p.itg_movFullPth = [h.movie.path h.movie.file];

        % set frame acquisition time
        p.rate = h.movie.cyctime;
    end
end

% reset results
p.SFres = {};

% set spotfinder parameters
p.SFres{1,1} = [meth p.SF_gaussFit h.movie.frameCurNb];
for i = 1:p.nChan
    p.SFres{1,i+1} = [p.SF_w(i),p.SF_h(i); p.SF_darkW(i),p.SF_darkH(i); ...
        p.SF_intThresh(i),p.SF_intRatio(i)];
end

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% refresh calculations, plot and GUI
updateFields(h_fig, 'imgAxes');
