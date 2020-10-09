function pushbutton_editParam_Callback(obj, evd, h_fig, varargin)
% pushbutton_editParam_Callback([],[],h_fig)
%
% h_fig: handle to main figure

% Last update: by MH, 3.4.2019: manage error that occurs after changing FRET and stoichiometry calculations in project options: adapt fix value of bottom trace plot popupmenu to popupmenu's string size (last possible option: "all" or "all FRET" etc.)

h = guidata(h_fig);
if isempty(h.param.ttPr.proj)
    return
end

setContPan('Edit project parameters...','process',h_fig);

openItgExpOpt(h.pushbutton_editParam, evd, h_fig);

