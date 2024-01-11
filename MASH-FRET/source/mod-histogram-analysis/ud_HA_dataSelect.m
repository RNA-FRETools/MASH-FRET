function ud_HA_dataSelect(h_fig)
% ud_HA_dataSelect(h_fig)
%
% Set properties of data selection uicontrols to proper values
%
% h_fig: handle to main figure

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end
% collect experiment settings
proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);
tagNames = p.proj{proj}.molTagNames;
colorlist = p.proj{proj}.molTagClr;

% build data type list
str_pop = getStrPopHAdat(p.proj{proj});
set(h.popupmenu_thm_tpe, 'String', str_pop, 'Value', tpe);

% build tag list
str_pop = getStrPopTags(tagNames,colorlist);
if ~strcmp(str_pop{1},'no default tag')
    str_pop = cat(2,'all molecules',str_pop);
end
set(h.popupmenu_thm_tag, 'String', str_pop, 'Value', tag);
