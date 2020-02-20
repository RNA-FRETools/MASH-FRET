function routinetest_TP_plot(h_fig,p,prefix)
% routinetest_TP_plot(h_fig,p,prefix)
%
% Tests different data to plot and axis settings
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

setDefault_TP(h_fig,p);

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

% tes axis settings
disp(cat(2,prefix,'test axis settings'));
nDat_bot = numel(get(h.popupmenu_plotBottom,'string'));
for dat = 1:nDat_bot
    set(h.popupmenu_plotBottom,'value',dat);
    popupmenu_plotBottom_Callback(h.popupmenu_plotBottom,[],h_fig);
end

set_TP_xyAxis(~p.perSec,~p.perPix,~p.inSec,~p.fixX0,p.x0,h_fig);

pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);

