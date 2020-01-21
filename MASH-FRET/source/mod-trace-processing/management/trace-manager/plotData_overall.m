function plotData_overall(h_fig)

% Last update by MH, 24.4.2019
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
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);

plot1 = get(h.tm.popupmenu_axes1,'value');
plot2 = get(h.tm.popupmenu_axes2,'value');

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat2 = get(h.tm.axes_ovrAll_2,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');

cla(h.tm.axes_ovrAll_1);
cla(h.tm.axes_ovrAll_2);
cla(h.tm.axes_traceSort);

if ~sum(dat3.slct)
    return;
end

disp('plot data ...');

plotData_conctrace(h.tm.axes_ovrAll_1,plot1,h_fig);
plotData_conctrace(h.tm.axes_traceSort,plot1,h_fig);
drawMask_slct(h_fig);

% RB 2017-12-15: implement FRET-S-histograms in plot2
if plot2 <= nChan*nExc+nFRET+nS
    bar(h.tm.axes_ovrAll_2, dat2.iv{plot2}, dat2.hist{plot2},'facecolor',...
        dat1.color{plot2},'edgecolor', dat1.color{plot2});

    xlabel(h.tm.axes_ovrAll_2, dat2.xlabel{plot2});
    ylabel(h.tm.axes_ovrAll_2, dat2.ylabel{plot2}); % RB 2018-01-04:

    xlim(h.tm.axes_ovrAll_2, [dat1.lim{plot2}(1),dat1.lim{plot2}(2)]);
    ylim(h.tm.axes_ovrAll_2, 'auto');
    
else  % draw FRET-S histogram
    cla(h.tm.axes_ovrAll_2);
    %lim = [-0.2 1.2; -0.2,1.2];
    imagesc(dat1.lim{plot2}(1,:),dat1.lim{plot2}(2,:),dat2.hist{plot2},...
        'parent', h.tm.axes_ovrAll_2);
    if sum(sum(dat2.hist{plot2}))
        set(h.tm.axes_ovrAll_2,'clim',[min(min(dat2.hist{plot2})) ...
            max(max(dat2.hist{plot2}))]);
    else
        set(h.tm.axes_ovrAll_2,'clim',[0 1]);
    end

    xlabel(h.tm.axes_ovrAll_2, dat2.xlabel{plot2});
    ylabel(h.tm.axes_ovrAll_2, dat2.ylabel{plot2});

    xlim(h.tm.axes_ovrAll_2, dat1.lim{plot2}(1,:));
    ylim(h.tm.axes_ovrAll_2, dat1.lim{plot2}(2,:));
end

% display histogram parameters
set(h.tm.edit_xlim_low,'string',num2str(dat1.lim{plot2}(1,1)));
set(h.tm.edit_xlim_up,'string',num2str(dat1.lim{plot2}(1,2)));
set(h.tm.edit_xnbiv,'string',num2str(dat1.niv(plot2,1)));
if plot2 > nChan*nExc+nFRET+nS
    set(h.tm.edit_ylim_low,'string',num2str(dat1.lim{plot2}(2,1)),'enable',...
        'on');
    set(h.tm.edit_ylim_up,'string',num2str(dat1.lim{plot2}(2,2)),'enable',...
        'on');
    set(h.tm.edit_ynbiv,'string',num2str(dat1.niv(plot2,2)),'enable','on');
    set(h.tm.text4,'enable','on');
else
    set(h.tm.edit_ylim_low,'string','','enable','off');
    set(h.tm.edit_ylim_up,'string','','enable','off');
    set(h.tm.edit_ynbiv,'string','','enable','off');
    set(h.tm.text4,'enable','off');
end

