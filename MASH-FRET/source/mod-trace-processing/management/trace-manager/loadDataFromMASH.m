function ok = loadDataFromMASH(h_fig)

ok = true;

h = guidata(h_fig);
p = h.param.ttPr;
nMol = numel(h.tm.molValid);

% loading bar parameters-----------------------------------------------
err = loading_bar('init',h_fig ,nMol,'Collecting data from MASH ...');
if err
    ok = false;
    return;
end
h = guidata(h_fig); % update:  get current guidata 
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h); % update: set current guidata 
% ---------------------------------------------------------------------

for i = 1:nMol

    [p,opt] = resetMol(i, '', p);

    % get dark coordinates
    p = plotSubImg(i, p, []);

    % correct intensities
    [p,opt2] = updateIntensities(opt,i,p);
    
    % get gamma factors
    if strcmp(opt2, 'gamma') || strcmp(opt2, 'debleach') || ...
        strcmp(opt2, 'denoise') || strcmp(opt2, 'corr') || ...
        strcmp(opt2, 'ttBg') || strcmp(opt2, 'ttPr')
            p = updateGammaFactor(h_fig,i,p);
    end

    % loading bar update-----------------------------------
    err = loading_bar('update', h_fig);
    % -----------------------------------------------------

    if err
        ok = false;
        return;
    end
end
loading_bar('close', h_fig);

h.param.ttPr = p;
guidata(h_fig,h);
    
