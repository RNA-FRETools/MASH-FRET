function pushbutton_addS_Callback(obj, evd, h_fig)
h = guidata(h_fig);
fret = get(h.itgExpOpt.popupmenu_Spairs, 'Value');
p = guidata(h.figure_itgExpOpt);

if size(p{3},1)==0
    return
end

don = p{3}(fret,1);
acc = p{3}(fret,2);
    
if don==acc || (size(p{4},1)>0 && ~isempty(find(p{4}(:,1)==don & ...
        p{4}(:,2)==acc,1)))
    return
    
elseif p{6}(don)==0
    updateActPan(['The stoichiometry can not be calculated: excitation ',...
        'wavelength specific to ' p{7}{2}{don} ' is not defined.'], h_fig,...
        'error');
    return
elseif p{6}(acc)==0
    updateActPan(['The stoichiometry can not be calculated: excitation ',...
        'wavelength specific to ' p{7}{2}{acc} ' is not defined.'], h_fig,...
        'error');
    return
end

p{4} = cat(1,p{4},[don,acc]);
guidata(h.figure_itgExpOpt,p);
ud_sPanel(h_fig);
l = size(p{4},1);
set(h.itgExpOpt.listbox_Scalc, 'Value', l);