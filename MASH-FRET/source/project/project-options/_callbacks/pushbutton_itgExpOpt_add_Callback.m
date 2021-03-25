function pushbutton_itgExpOpt_add_Callback(obj, evd, but_obj, h_fig)
h = guidata(h_fig);
name_str = get(h.itgExpOpt.edit_newName, 'String');
units_str = get(h.itgExpOpt.edit_newUnits, 'String');
maxN = 10;
if ~isempty(name_str) && length(name_str) <= maxN && ...
        length(units_str) <= maxN
    p = guidata(h.figure_itgExpOpt);
    str_chan = get(h.itgExpOpt.popupmenu_dyeChan,'String');
    nChan = size(str_chan,1);
    str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
    nExc = size(str_exc,1)-1;

    p{1} = [p{1}; {name_str '' units_str}];
  
    guidata(h.figure_itgExpOpt, p);
    guidata(h_fig,h);
    buildWinOpt(p, nExc, nChan, but_obj, h_fig);
else
    updateActPan(['Parameter name must not be empty and parameter name' ...
        'and units must contain ' num2str(maxN) ' characters at max.'], ...
        h_fig, 'error');
end