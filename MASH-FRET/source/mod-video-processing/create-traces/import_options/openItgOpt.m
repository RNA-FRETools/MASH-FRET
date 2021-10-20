function openItgOpt(but_obj, evd, h_fig)

% Last update by MH, 28.3.2019: Correct parameter saving (in pushbutton_itgOpt_ok_Callback) and import (openItgOpt.m) : if coordinates import option window is called from Trace import options's window, parameters must be saved in/imported from figure_trImpOpt's handle instead of figure_MASH's handle.

h = guidata(h_fig);
p = h.param;
switch but_obj
    case h.pushbutton_TTgen_loadOpt
        nChan = p.proj{p.curr_proj}.nb_channel;
        impprm = p.proj{p.curr_proj}.VP.curr.gen_int{2}{3};
    case h.trImpOpt.pushbutton_impCoordOpt
        m = guidata(h.figure_trImpOpt);
        nChan = m{1}{1}(7);
        impprm = m{3}{3};
end

if size(impprm{1,1},1)<nChan
    for i = (size(impprm{1,1},1)+1):nChan
        impprm{1,1} = [impprm{1,1};impprm{1,1}(i-1,end)+1 impprm{1,1}(i-1,end)+2];
    end
end
impprm{1,1} = impprm{1,1}(1:nChan,:);

if ~(isfield(h, 'figure_itgOpt') && ishandle(h.figure_itgOpt))
    buildItgOpt(impprm,but_obj,h_fig);
end

