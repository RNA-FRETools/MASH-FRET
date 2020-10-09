function openItgFileOpt(obj, evd, h_fig)
% Open a window to modify file options for export of raw traces
% "obj" >> handle of pushbutton from which the function has been called
% "evd" >> eventdata structure of the pushbutton from which the function
%          has been called (usually empty)
% "h" >> main data structure stored in figure_MASH's handle

% Last update: 4th of February 2019 by M�lodie Hadzic
% --> created function from scratch

h = guidata(h_fig);
pMov = h.param.movPr;

if ~(isfield(pMov,'itg_movFullPth') && ~isempty(pMov.itg_movFullPth))
    set(h.edit_movItg,'BackgroundColor',[1 0.75 0.75]);
    updateActPan('No movie loaded.',h_fig,'error');
    return
end
if ~(isfield(pMov, 'coordItg') && ~isempty(pMov.coordItg))
        set(h.edit_itg_coordFile,'BackgroundColor',[1,0.75,0.75]);
        updateActPan('No coordinates loaded.',h_fig,'error');
    return
end

buildItgFileOpt(h_fig);
