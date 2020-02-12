function openItgOpt(but_obj, evd, h_fig)

% Last update by MH, 28.3.2019: Correct parameter saving (in pushbutton_itgOpt_ok_Callback) and import (openItgOpt.m) : if coordinates import option window is called from Trace import options's window, parameters must be saved in/imported from figure_trImpOpt's handle instead of figure_MASH's handle.

h = guidata(h_fig);
switch but_obj
    case h.pushbutton_TTgen_loadOpt
        nChan = h.param.movPr.nChan;
        p = h.param.movPr.itg_impMolPrm;
    case h.trImpOpt.pushbutton_impCoordOpt
        m = guidata(h.figure_trImpOpt);
        nChan = m{1}{1}(7);
        p = m{3}{3};
end

if size(p{1,1},1)<nChan
    for i = (size(p{1,1},1)+1):nChan
        p{1,1} = [p{1,1};p{1,1}(i-1,end)+1 p{1,1}(i-1,end)+2];
    end
end
p{1,1} = p{1,1}(1:nChan,:);

if ~(isfield(h, 'figure_itgOpt') && ishandle(h.figure_itgOpt))
    buildItgOpt(p,but_obj,h_fig);
end

