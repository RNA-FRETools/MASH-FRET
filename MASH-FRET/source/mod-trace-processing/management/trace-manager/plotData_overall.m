function plotData_overall(h_fig)

% Last update by MH, 21.1.2020
% >> adapt plot to any 2D histogram and associated changes in data
%  organization
%
% update by MH, 24.4.2019
% >> correct plot clearing before plotting multiple traces on the same 
%    graph
% 
% update: by RB, 3.1.2018
% >> indizes/colour bug solved
%
% update: by RB, 15.12.2017
% >> implement FRET-S-histograms in plot2
%
%

warning('off','MATLAB:hg:EraseModeIgnored');

h = guidata(h_fig);

plot1 = get(h.tm.popupmenu_axes1,'value');
plot2x = get(h.tm.popupmenu_axes2x,'value');
plot2y = get(h.tm.popupmenu_axes2y,'value')-1;
is2D = plot2y>0;

dat1 = get(h.tm.axes_ovrAll_1,'userdata');

cla(h.tm.axes_ovrAll_1);
cla(h.tm.axes_ovrAll_2);
cla(h.tm.axes_traceSort);

% if molecule selection is empty, abort
dat3 = get(h.tm.axes_histSort,'userdata');
if ~sum(dat3.slct)
    return
end

plotData_conctrace(h.tm.axes_ovrAll_1,plot1,h_fig);
plotData_conctrace(h.tm.axes_traceSort,plot1,h_fig);
drawMask_slct(h_fig);

% MH 2020-01-21: allow any 2D histogram in plot2
% RB 2017-12-15: implement FRET-S-histograms in plot2
if ~is2D
    
    [P,iv] = getHistTM(dat1.trace{plot2x},dat1.lim(plot2x,:),...
        dat1.niv(plot2x));
    
    bar(h.tm.axes_ovrAll_2,iv,P,'facecolor',dat1.color{plot2x},...
        'edgecolor', dat1.color{plot2x});

    xlabel(h.tm.axes_ovrAll_2, dat1.ylabel{plot2x});
    ylabel(h.tm.axes_ovrAll_2, 'freq. count');
%     ylabel(h.tm.axes_ovrAll_2, dat2.ylabel{plot2x}); % RB 2018-01-04:

    xlim(h.tm.axes_ovrAll_2, dat1.lim(plot2x,:));
    ylim(h.tm.axes_ovrAll_2, 'auto');
    
else  % draw FRET-S histogram
    [P_2D,iv_2D] = getHistTM([dat1.trace{plot2x},dat1.trace{plot2y}],...
        [dat1.lim(plot2x,:);dat1.lim(plot2y,:)],...
        [dat1.niv(plot2x),dat1.niv(plot2y)]);
    
    imagesc(iv_2D{1},iv_2D{2},P_2D,'parent', h.tm.axes_ovrAll_2);
    if sum(sum(P_2D))
        set(h.tm.axes_ovrAll_2,'clim',[min(min(P_2D)) max(max(P_2D))]);
    else
        set(h.tm.axes_ovrAll_2,'clim',[0 1]);
    end

    xlabel(h.tm.axes_ovrAll_2, dat1.ylabel{plot2x});
    ylabel(h.tm.axes_ovrAll_2, dat1.ylabel{plot2y});

    xlim(h.tm.axes_ovrAll_2, dat1.lim(plot2x,:));
    ylim(h.tm.axes_ovrAll_2, dat1.lim(plot2y,:));
end

% display histogram parameters
set(h.tm.edit_xlim_low,'string',num2str(dat1.lim(plot2x,1)),'enable','on');
set(h.tm.edit_xlim_up,'string',num2str(dat1.lim(plot2x,2)),'enable','on');
set(h.tm.edit_xnbiv,'string',num2str(dat1.niv(plot2x)),'enable','on');

if is2D
    set(h.tm.edit_ylim_low,'string',num2str(dat1.lim(plot2y,1)),'enable',...
        'on');
    set(h.tm.edit_ylim_up,'string',num2str(dat1.lim(plot2y,2)),'enable',...
        'on');
    set(h.tm.edit_ynbiv,'string',num2str(dat1.niv(plot2y)),'enable','on');
    set(h.tm.text4,'enable','on');
    
else
    set(h.tm.edit_ylim_low,'string','','enable','off');
    set(h.tm.edit_ylim_up,'string','','enable','off');
    set(h.tm.edit_ynbiv,'string','','enable','off');
    set(h.tm.text4,'enable','off');
end

