function set_TA_TDP(dat,tag,prm,h_fig)
% set_TA_TDP(dat,tag,prm,h_fig)
%
% Set Transition density plot settings
%
% dat: index in list of data to plot in TDP
% tag: index in list of molecule subgroup to plot in TDP
% prm: [1-by-8] TDP settings
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

set(h.popupmenu_TDPdataType,'value',dat);
popupmenu_TDPdataType_Callback(h.popupmenu_TDPdataType,[],h_fig);

set(h.popupmenu_TDPtag,'value',tag);
popupmenu_TDPtag_Callback(h.popupmenu_TDPtag,[],h_fig);

set(h.edit_TDPmin,'string',num2str(prm(1)));
edit_TDPmin_Callback(h.edit_TDPmin,[],h_fig);

set(h.edit_TDPbin,'string',num2str(prm(2)));
edit_TDPbin_Callback(h.edit_TDPbin,[],h_fig);

set(h.edit_TDPmax,'string',num2str(prm(3)));
edit_TDPmax_Callback(h.edit_TDPmax,[],h_fig);

set(h.checkbox_TDP_statics,'value',prm(4));
checkbox_TDP_statics_Callback(h.checkbox_TDP_statics,[],h_fig);

set(h.checkbox_TDP_onecount,'value',prm(5));
checkbox_TDP_onecount_Callback(h.checkbox_TDP_onecount,[],h_fig);

set(h.checkbox_TDPignore,'value',prm(6));
checkbox_TDPignore_Callback(h.checkbox_TDPignore,[],h_fig);

set(h.checkbox_TDPgconv,'value',prm(7));
checkbox_TDPgconv_Callback(h.checkbox_TDPgconv,[],h_fig);

set(h.checkbox_TDPnorm,'value',prm(8));
checkbox_TDPnorm_Callback(h.checkbox_TDPnorm,[],h_fig);

