function pushbutton_itgOpt_ok_Callback(obj, evd, h_fig, but_obj)

% Last update: 28.3.2019 by MH
% >> Correct parameter saving: if coordinates import option window is 
%    called from trace import options, parameters must be saved in 
%    figure_trImpOpt's handle instead of figure_MASH's handle.

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

for i = 1:nChan
    p{1}(i,1:2) = ...
        [str2num(get(h.itgOpt.edit_cColX(i), 'String')) ...
        str2num(get(h.itgOpt.edit_cColY(i), 'String'))];
end
p{2} = str2num(get(h.itgOpt.edit_nHead, 'String'));

switch but_obj
    case h.pushbutton_TTgen_loadOpt
        h.param.movPr.itg_impMolPrm = p;
        guidata(h_fig, h);
    case h.trImpOpt.pushbutton_impCoordOpt
        m{3}{3} = p;
        guidata(h.figure_trImpOpt,m);
end

close(h.figure_itgOpt);
