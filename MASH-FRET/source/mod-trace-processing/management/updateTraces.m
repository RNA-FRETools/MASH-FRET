function p = updateTraces(h_fig, opt1, mol, p, axes)

% Last update: by MH, 10.1.2020
% >> search factor correction in 6th parameter cell

proj = p.curr_proj;

if isempty(p.proj)
    return
end

% display process
if strcmp(opt1, 'subImg')
    setContPan('Process current sub-images...','process',h_fig);
else
    setContPan('Process current traces...','process',h_fig);
end

% update images
if ~(~isempty(axes) && isfield(axes, 'axes_molImg'))
    axes_molImg = [];
else
    axes_molImg = axes.axes_molImg;
end

% reset traces according to changes in parameters
[p, opt2] = resetMol(mol, opt1, p);

p = plotSubImg(mol, p, axes_molImg);

if strcmp(opt1, 'subImg')
    h = guidata(h_fig);
    h.param = p;
    
    % display success
    setContPan('Sub-images are up to date!','success',h_fig);
    
    return
end

[p,opt2] = updateIntensities(opt2,mol,p,h_fig);

if strcmp(opt2, 'gamma') || strcmp(opt2, 'debleach') || ...
        strcmp(opt2, 'denoise') || strcmp(opt2, 'cross') || ...
        strcmp(opt2, 'ttBg') || strcmp(opt2, 'ttPr')
    p = updateGammaFactor(h_fig,mol,p);
end

% modified by MH, 12.1.2020
p = updateStateSequences(h_fig, mol, p);
% if strcmp(opt2, 'DTA') || strcmp(opt2, 'gamma') || ...
%         strcmp(opt2, 'debleach') || strcmp(opt2, 'denoise') || ...
%         strcmp(opt2, 'cross') || strcmp(opt2, 'ttBg') || ...
%         strcmp(opt2, 'ttPr')
%     p = updateStateSequences(h_fig, mol, p);
% end

% modified by MH, 12.1.2020
if ~isempty(axes)
    plotData(mol, p, axes, p.proj{proj}.TP.prm{mol}, 1);
end
% if (strcmp(opt2, 'plot') || strcmp(opt2, 'gamma') || ...
%         strcmp(opt2, 'DTA') || strcmp(opt2, 'debleach') || ...
%         strcmp(opt2, 'denoise') || strcmp(opt2, 'cross') || ...
%         strcmp(opt2, 'ttBg') || strcmp(opt2, 'ttPr')) && ~isempty(axes)
%     plotData(mol, p, axes, p.proj{proj}.prm{mol}, 1);
% end

% cancelled by MH, 11.1.2020: split to respective functions
% p.proj{proj}.def.mol = p.proj{proj}.prm{mol};
% p.proj{proj}.curr{mol} = p.proj{proj}.prm{mol};

if strcmp(p.curr_mod(proj),'TP')
    setContPan('Traces are up to date!','success',h_fig);
end

