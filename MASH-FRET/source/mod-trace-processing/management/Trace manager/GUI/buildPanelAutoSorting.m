function q = buildPanelAutoSorting(q,p,h_fig)
% Build panel "Auto-sorting" including panel "Ranges" and update main structure with handles to new uicontrols

% q.uipanel_autoSorting: handle to panel "Auto-sorting"
%
% p.posun
% p.fntun
% p.fntsz
% p.mg
% p.wedit
% p.hedit
% p.wtxt3
% p.htxt
% p.pop
% p.wtxt1

% defaults
limy = [0 10000];
ud = 1;
ylbl1 = 'counts per s. per pix.';
xlbl1 = 'time (s)';
axttl1 = 'concatenated traces for molecule selection at last update';
ylbl2 = 'freq. counts';
xlbl2 = 'counts per s. per pix.';
axttl2 = '1D-histogram for molecule selection at last update';
str0 = 'Select data:';
str1 = 'Select calculation:';
str2 = {'original time traces','means','minima','maxima','medians',...
    'state trajectories'};
str3 = 'Histogram:';
str4 = 'x min';
str5 = 'x max';
str6 = 'nbins';
str7 = 'y min';
str8 = 'y max';
str9 = 'nbins';
ttl0 = 'Ranges';
ttstr0 = 'Select the data to histogram';
ttstr1 = 'Select the calculated value to histogram';
ttstr2 = 'Lower bound of x-axis';
ttstr3 = 'Upper bound of x-axis';
ttstr4 = 'Number of binning intervals in x-axis';
ttstr5 = 'Lower bound of y-axis';
ttstr6 = 'Upper bound of y-axis';
ttstr7 = 'Number of binning intervals in y-axis';

% parents
h_pan = q.uipanel_autoSorting;

% dimensions
pospan = get(h_pan,'position');
posfig = get(q.figure_traceMngr,'position');
wpop = 3*p.wedit+2*p.mg/2;
wpan = 0.5*wpop + 2*p.wedit + p.wtxt3 + 2.5*p.mg;
hpan = pospan(4)-p.hpop-p.htxt-4*p.mg;
waxes = posfig(3) - wpan - 3*p.mg;
haxes1 = (hpan-p.mg)*0.8;
haxes2 = hpan-p.mg-haxes1;

% list strings
str_plot = getStrPlot_overall(h_fig);
str_pop = getStrPlot_overall(h_fig);

x = 2*p.mg;
y = 2*p.mg;

q.uipanel_range = uipanel('parent',h_pan,'units',p.posun,'position',...
    [x y wpan hpan],'title',ttl0,'fontunits',p.fntun,'fontsize',p.fntsz);
q = buildPanelRanges(q,p,h_fig);

x = x + wpan + p.mg;

q.axes_traceSort = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz,'activepositionproperty','outerposition',...
    'gridlineStyle',':','nextPlot','replacechildren');
ylim(q.axes_traceSort,limy);
ylabel(q.axes_traceSort,ylbl1);
xlabel(q.axes_traceSort,xlbl1);
t = title(q.axes_traceSort,axttl1);
pos = getRealPosAxes([x,y,waxes,haxes2], ...
    get(q.axes_traceSort,'TightInset'),'traces'); 
pos(3) = pos(3) - p.fntsz;
pos(1) = pos(1) + p.fntsz;
set(q.axes_traceSort,'Position',pos);
pos_t = get(t,'extent');
set(t,'position',[(pos_t(3)+pos(3)-pos_t(3)-wpop)/2,pos_t(2)]);

y = pos(2) + pos(4) + p.mg/2;
x = pos(1) + pos(3) - wpop;

q.popupmenu_AS_plot1 = uicontrol('style','popupmenu','parent',h_pan,...
    'string',str_plot{1},'units',p.posun,'position',[x y wpop p.hpop],...
    'callback',{@popupmenu_axes_Callback,h_fig},'fontunits',p.fntun,...
    'fontsize',p.fntsz);

x = wpan + 3*p.mg;
y = haxes2 + 3*p.mg;

q.axes_histSort = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz,'activepositionproperty','outerposition',...
    'gridlineStyle',':','nextPlot','replacechildren','buttondownfcn',...
    {@axes_histSort_ButtonDownFcn,h_fig});
ylim(q.axes_histSort,limy);
ylabel(q.axes_histSort,ylbl2);
xlabel(q.axes_histSort,xlbl2);
title(q.axes_histSort,axttl2);
pos = getRealPosAxes([x,y,waxes,haxes1], ...
    get(q.axes_histSort,'TightInset'),'traces'); 
pos(3) = pos(3) - p.fntsz;
pos(1) = pos(1) + p.fntsz;
set(q.axes_histSort,'Position',pos);

x = 2*p.mg;
y = y + haxes1 + p.mg;

q.text_selectData = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'position',[x,y,p.wtxt1,p.htxt],'fontunits',p.fntun,'fontsize',p.fntsz,...
    'string',str0,'fontweight','bold','horizontalalignment','left');

x = x + p.wtxt1 + p.mg;

q.popupmenu_selectData = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'position',[x,y,wpop,p.hpop],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'string',str_pop{2},'tooltipstring',ttstr0,...
    'callback',{@popupmenu_selectData_Callback,h_fig});
 
x = x + wpop + 2*p.mg;

q.text_selectCalc = uicontrol('style','text','parent',h_pan,'string',str1,...
    'position',[x,y,p.wtxt2,p.htxt],'fontunits',p.fntun,'fontsize',p.fntsz,...
    'fontweight','bold','horizontalalignment','left');
 
x = x + p.wtxt2 + p.mg;
 
q.popupmenu_selectCalc = uicontrol('style','popupmenu','parent',...
    h_pan,'units',p.posun,'string',str2,'tooltipstring',ttstr1,'position',...
    [x,y,wpop,p.hpop],'fontunits',p.fntun,'fontsize',p.fntsz,'callback',...
    {@popupmenu_selectData_Callback,h_fig},'userdata',ud);

x = x + wpop + 2*p.mg;

q.text_histogram = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str3,'position',[x,y,p.wtxt1,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'fontweight','bold','horizontalalignment','left');

x = x + p.wtxt1 + p.mg;

q.edit_xlow = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'position',[x,y,p.wedit,p.hedit],'fontunits',p.fntun,'fontsize',p.fntsz,...
    'string','','tooltipstring',ttstr2,'callback',...
    {@edit_xlow_Callback,h_fig});

y = y + p.hedit;

q.text_xlow = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str4,'position',[x,y,p.wedit,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'horizontalalignment','center');

x = x + p.wedit + p.mg/5;
y = y - p.hedit;

q.edit_xup = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'position',[x,y,p.wedit,p.hedit],'fontunits',p.fntun,'fontsize',...
    p.fntsz,'string','','tooltipstring',ttstr3,'callback',...
    {@edit_xup_Callback,h_fig});

y = y + p.hedit;

q.text_xup = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str5,'position',[x,y,p.wedit,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'horizontalalignment','center');

x = x + p.wedit + p.mg/5;
y = y - p.hedit;

q.edit_xniv = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'string','','tooltipstring',ttstr4,'position',[x,y,p.wedit,p.hedit],...
    'fontunits',p.fntun,'fontsize',p.fntsz,'callback',...
    {@edit_xniv_Callback,h_fig});

y = y + p.hedit;

q.text_xniv = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str6,'position',[x,y,p.wedit,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'horizontalalignment','center');

x = x + p.wedit + p.mg;
y = y - p.hedit;

q.edit_ylow = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'string','','tooltipstring',ttstr5,'position',[x,y,p.wedit,p.hedit],...
    'fontunits',p.fntun,'fontsize',p.fntsz,'callback',...
    {@edit_ylow_Callback,h_fig},'enable','off');

y = y + p.hedit;

q.text_ylow = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str7,'position',[x,y,p.wedit,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'horizontalalignment','center','enable','off');

x = x + p.wedit + p.mg/5;
y = y - p.hedit;

q.edit_yup = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'string','','tooltipstring',ttstr6,'position',[x,y,p.wedit,p.hedit],...
    'fontunits',p.fntun,'fontsize',p.fntsz,'callback',...
    {@edit_yup_Callback,h_fig},'enable','off');

y = y + p.hedit;

q.text_yup = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str8,'position',[x,y,p.wedit,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'horizontalalignment','center','enable','off');

x = x + p.wedit + p.mg/5;
y = y - p.hedit;

q.edit_yniv = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'string','','tooltipstring',ttstr7,'position',[x,y,p.wedit,p.hedit],...
    'fontunits',p.fntun,'fontsize',p.fntsz,'enable','off','callback',...
    {@edit_yniv_Callback,h_fig});

y = y + p.hedit;

q.text_yniv = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str9,'position',[x,y,p.wedit,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'horizontalalignment','center','enable','off');

