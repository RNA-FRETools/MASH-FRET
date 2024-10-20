function pushbutton_tagClr_Callback(obj,evd,h_fig)
% pushbutton_tagClr_Callback([],[],h_fig)
% pushbutton_tagClr_Callback(clr,[],h_fig)
%
% Defines the tag color.
% pushbutton_tagClr_Callback can be called from MASH-FRET's GUI or from a test routine.
% When called from a script routine, the color in defined in input, otherwise, MATLAB's color picker is used. 
%
% h_fig: handle to main figure
% clr: {1-by-1} [1-by-3] RGB color (numbers between 0 and 1)

% Created by MH, 24.4.2019
%
%

h = guidata(h_fig);

% control empty tag
tag = get(h.tm.popup_molTag,'value');
str_pop = get(h.tm.popup_molTag, 'string');
if strcmp(str_pop{tag},'no default tag') || ...
        strcmp(str_pop{tag},'select tag')
    return
else
     tag = tag-1;
end

% control color value
if iscell(obj)
    rgb = obj{1};
else
    rgb = uisetcolor('Select a tag color');
end
if numel(rgb)==1
    return
end

rgb = round(255*rgb);
clr_str = rgb2hex(rgb);

% save color
h.tm.molTagClr{tag} = cat(2,'#',clr_str);
guidata(h_fig,h);

% update color in molecule tag listboxes and popups
n_mol_disp = str2num(get(h.tm.edit_nbTotMol,'string'));

update_taglist_OV(h_fig,n_mol_disp);
update_taglist_AS(h_fig);
update_taglist_VV(h_fig);

% update edit field background color
popup_molTag_Callback(h.tm.popup_molTag,[],h_fig);

