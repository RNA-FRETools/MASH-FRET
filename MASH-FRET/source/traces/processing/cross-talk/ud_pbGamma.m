% update photobleaching based gamma correction
% adapted from ud_bleach.m
% last updated: FS, 12.1.2018

function ud_pbGamma(h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    p_panel = p.proj{proj}.curr{mol}{5};
    
    % cutoff parameter
    acc = p_panel{4}(2);
    start = p_panel{5}(acc,5);
    cutOff = p_panel{5}(acc,6);
    prm = p_panel{5}(acc,2:4);
    
    % in frames or in seconds
    perSec = p.proj{proj}.fix{2}(4);
    perPix = p.proj{proj}.fix{2}(5);
    fixIt = p.proj{proj}.fix{2}(6);
    inSec = p.proj{proj}.fix{2}(7);
    rate = p.proj{proj}.frame_rate;
    
    if inSec
        start = start*rate;
        cutOff = cutOff*rate;
        prm(2:3) = prm(2:3)*rate;
    end
    if perSec
        prm(1) = prm(1)/rate;
    end
    if perPix
        nPix = p.proj{proj}.pix_intgr(2);
        prm(1) = prm(1)/nPix;
    end
    
    set(h.checkbox_photobl_fixStart, 'Value', fixIt);
    set(h.checkbox_photobl_insec, 'Value', inSec);
    set(h.edit_photobl_start, 'String', num2str(start));
    if fixIt
        set(h.edit_photobl_start, 'Enable', 'inactive');
    else
        set(h.edit_photobl_start, 'Enable', 'on');
    end
    
    % update edit fields of the cutoff parameters 
    set(h.gpo.edit_pbGamma_stop, 'String', num2str(cutOff));
    set(h.gpo.edit_pbGamma_threshold, 'String', num2str(prm(1)));
    set(h.gpo.edit_pbGamma_extraSubstract, 'String', num2str(prm(2)));
    set(h.gpo.edit_pbGamma_minCutoff, 'String', num2str(prm(3)));
    
    % update the toolstrings depending on the x-axis unit (frames/s)
    if inSec
        set(h.gpo.edit_pbGamma_extraSubstract, 'TooltipString', ...
            'Extra time to subtract (s)');
        set(h.gpo.edit_pbGamma_minCutoff, 'TooltipString', ...
            'Min. cutoff time (s)');
    else
        set(h.gpo.edit_pbGamma_extraSubstract, 'TooltipString', ...
            'Extra frames to subtract');
        set(h.gpo.edit_pbGamma_minCutoff, 'TooltipString', 'Min. cutoff frame');
    end
    
end
