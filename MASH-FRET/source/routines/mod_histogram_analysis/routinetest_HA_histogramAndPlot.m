function routinetest_HA_histogramAndPlot(h_fig,p,prefix)
% routinetest_HA_histogramAndPlot(h_fig,p,prefix)
%
% Tests data list and histogram building
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_HA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

setDefault_HA(h_fig,p);

h = guidata(h_fig);

% test different data
disp(cat(2,prefix,'test data list...'));
nDat = numel(get(h.popupmenu_thm_tpe,'string'));
for dat = 1:nDat
    set(h.popupmenu_thm_tpe,'value',dat);
    popupmenu_thm_tpe_Callback(h.popupmenu_thm_tpe,[],h_fig);
end

% test different molecule subgroups
disp(cat(2,prefix,'test molecule subgroups...'));
nTag = numel(get(h.popupmenu_thm_tag,'string'));
for tag = 1:nTag
    set(h.popupmenu_thm_tag,'value',tag);
    popupmenu_thm_tag_Callback(h.popupmenu_thm_tag,[],h_fig);
end

% test option "overflow"
disp(cat(2,prefix,'test option "overflow"...'));
histPrm = p.histPrm;
histPrm(4) = false;
set_HA_histplot(p.histDat,p.histTag,histPrm,h_fig);
set(h_fig,'currentaxes',h.axes_hist1);
exportAxes({[p.dumpdir,filesep,p.exp_overflow,'_0.png']},[],h_fig);

histPrm(4) = true;
set_HA_histplot(p.histDat,p.histTag,histPrm,h_fig);
set(h_fig,'currentaxes',h.axes_hist1);
exportAxes({[p.dumpdir,filesep,p.exp_overflow,'_1.png']},[],h_fig);

pushbutton_thm_rmProj_Callback(h.pushbutton_thm_rmProj,[],h_fig);
