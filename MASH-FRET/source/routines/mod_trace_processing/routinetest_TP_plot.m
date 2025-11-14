function routinetest_TP_plot(h_fig,p,prefix)
% routinetest_TP_plot(h_fig,p,prefix)
%
% Tests different data to plot and axis settings
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

% open default project
disp(cat(2,prefix,'import file ',p.mash_files{p.nL,p.nChan}));
[~,name,~] = fileparts(p.mash_files{p.nL,p.nChan});
pushbutton_openProj_Callback({[p.annexpth,name],p.mash_files{p.nL,p.nChan}},...
    [],h_fig);

% set default parameters
setDefault_TP(h_fig,p);

% expand panel
h_but = getHandlePanelExpandButton(h.uipanel_TP_plot,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end

% test different data plots
disp(cat(2,prefix,'test different data plots...'));
nDat_top = numel(get(h.popupmenu_plotTop,'string'));
nExc_top = numel(get(h.popupmenu_ttPlotExc,'string'));
for dat = 1:nDat_top
    for exc = 1:nExc_top
        set(h.popupmenu_ttPlotExc,'value',exc);
        popupmenu_ttPlotExc_Callback(h.popupmenu_ttPlotExc,[],h_fig);
        set(h.popupmenu_plotTop,'value',dat);
        popupmenu_plotTop_Callback(h.popupmenu_plotTop,[],h_fig);
    end
end
nDat_bot = numel(get(h.popupmenu_plotBottom,'string'));
for dat = 1:nDat_bot
    set(h.popupmenu_plotBottom,'value',dat);
    popupmenu_plotBottom_Callback(h.popupmenu_plotBottom,[],h_fig);
end

% test axis settings
disp(cat(2,prefix,'test axis settings'));
set_TP_xyAxis(~p.fixX0,p.x0,p.clipx,true,p.intlim,h_fig);

pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);

