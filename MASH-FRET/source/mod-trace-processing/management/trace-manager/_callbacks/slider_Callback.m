function slider_Callback(obj,evd,h_fig)

% Last update by MH, 24.4.2019
% >> cancel change in popupmenu's background color: no need as width and 
%    height were downscaled to regular dimensions and the line color is
%    given by the checkbox
% >> allow molecule tagging even if the molecule unselected
%
% Last update: by FS, 24.4.2018
% >> deactivate the label popupmenu if the molecule is not selected
%
%

% defaults
clrOffset = 0.85;
clrFactor = 0.05;

h = guidata(h_fig);
nMol = numel(h.tm.molValid);

pos_slider = round(get(obj, 'Value'));
max_slider = get(obj, 'Max');

prev_topMol = str2num(get(h.tm.checkbox_molNb(1),'String'));
if prev_topMol==(max_slider-pos_slider+1)
    return;
end

nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
if nb_mol_disp > nMol
    nb_mol_disp = nMol;
end

for i = 1:nb_mol_disp
    
    mol = max_slider - pos_slider + i;
    clr = clrFactor*repmat(mod(mol,2),1,3) + clrOffset;
    
    set(h.tm.checkbox_molNb(i),'String',num2str(mol),'Value',...
        h.tm.molValid(mol),'BackgroundColor',clr);


    % added by FS, 24.4.2018
    % cancelled by MH, 24.4.2019
%     str_lst = colorTagNames(h_fig);
%     if h.tm.molTag(max_slider-pos_slider+i) > length(str_lst)
%         val = 1;
%     else
%         val = h.tm.molTag(max_slider-pos_slider+i);
%     end
%     set(h.tm.popup_molNb(i), 'String', ...
%         str_lst, 'Value', ...
%         val, 'BackgroundColor', ...
%         0.05*[mod(max_slider-pos_slider+i,2) ...
%         mod(max_slider-pos_slider+i,2) ...
%         mod(max_slider-pos_slider+i,2)]+0.85);

    % deactivate the popupmenu if the molecule is not selected
    % added by FS, 24.4.2018
    % cancelled by MH, 24.4.2019: allow labelling even if not selected
%     if h.tm.molValid(max_slider-pos_slider+i) == 0
%         set(h.tm.popup_molNb(i), 'Enable', 'off')
%     else
%         set(h.tm.popup_molNb(i), 'Enable', 'on')
%     end
end

update_taglist_OV(h_fig,nb_mol_disp);
drawMask_slct(h_fig)
plotDataTm(h_fig);

