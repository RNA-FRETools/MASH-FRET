function set_HA_histplot(dat,tag,prm,h_fig)
% set_HA_histplot(dat,tag,prm,h_fig)
%
% Set Histogram plot settings
%
% dat: index in list of data to histogram and plot
% tag: index in list of molecule subgroup to histogram and plot
% prm: [1-by-4] histogram settings
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

set(h.popupmenu_thm_tpe,'value',dat);
popupmenu_thm_tpe_Callback(h.popupmenu_thm_tpe,[],h_fig);

set(h.popupmenu_thm_tag,'value',tag);
popupmenu_thm_tag_Callback(h.popupmenu_thm_tag,[],h_fig);

set(h.edit_thm_xlim1,'string',num2str(prm(1)));
edit_thm_xlim1_Callback(h.edit_thm_xlim1,[],h_fig);

set(h.edit_thm_xbin,'string',num2str(prm(2)));
edit_thm_xbin_Callback(h.edit_thm_xbin,[],h_fig);

set(h.edit_thm_xlim2,'string',num2str(prm(3)));
edit_thm_xlim2_Callback(h.edit_thm_xlim2,[],h_fig);

set(h.checkbox_thm_ovrfl,'value',prm(4));
checkbox_thm_ovrfl_Callback(h.checkbox_thm_ovrfl,[],h_fig);

