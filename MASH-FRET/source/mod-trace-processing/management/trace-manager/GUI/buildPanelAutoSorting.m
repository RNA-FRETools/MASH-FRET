function q = buildPanelAutoSorting(q,p,h_fig)
% Build panel "Auto-sorting" including panel "Ranges" and update main structure with handles to new uicontrols

% q.uipanel_autoSorting: handle to panel "Auto-sorting"
%
% p.posun: position units
% p.fntun: font units
% p.fntsz: font size
% p.mg: main margin
% p.wedit: mais edit field width
% p.hedit: main edit fiels height
% p.wtxt3: small edit field width
% p.htxt: main text height
% p.hpop: main popupmenu height
% p.wtxt1: medium text width

% defaults
limy = [0 10000];
ylbl1 = 'counts per s. per pix.';
xlbl1 = 'time (s)';
axttl1 = 'concatenated traces for molecule selection at last update';
ylbl2 = 'freq. counts';
xlbl2 = 'counts per s. per pix.';
axttl2 = '1D-histogram for molecule selection at last update';
ttl0 = 'Data';
ttl1 = 'Range';
ttl2 = 'Tags';

% parents
h_pan = q.uipanel_autoSorting;

% dimensions
pospan = get(h_pan,'position');
posfig = get(q.figure_traceMngr,'position');
wpop = 3*p.wedit+2*p.mg/2;
wpan = 0.5*wpop + 2*p.wedit + p.wtxt3 + 2.5*p.mg;
hpan1 = p.mgbig+2*(p.htxt+p.hpop+p.mg/2+p.htxt+p.hedit+p.mg);
hpan2 = p.mgbig+p.htxt+p.hedit+p.mg+p.htxt+p.mg/2+p.hpop+p.mg/2+p.hpop+...
    p.mg/2+p.htxt+p.mgbig+p.htxt+p.mg+p.hbut+p.mg;
hpan3 = pospan(4)-2*p.mg-hpan1-p.mg-hpan2-p.mg-2*p.mg;
waxes = posfig(3) - wpan - 3*p.mg;
haxes1 = (pospan(4)-4*p.mg)*0.8;
haxes2 = pospan(4)-4*p.mg-haxes1-p.mg;

% list strings
str_plot = getStrPlot_overall(h_fig);

x = 2*p.mg;
y = pospan(4)-2*p.mg-hpan1;

q.uipanel_data = uipanel('parent',h_pan,'units',p.posun,'position',...
    [x y wpan hpan1],'title',ttl0,'fontunits',p.fntun,'fontsize',p.fntsz);
q = buildPanelData(q,p,h_fig);

y = y-p.mg-hpan2;

q.uipanel_range = uipanel('parent',h_pan,'units',p.posun,'position',...
    [x y wpan hpan2],'title',ttl1,'fontunits',p.fntun,'fontsize',p.fntsz);
q = buildPanelRanges(q,p,h_fig);

y = y-p.mg-hpan3;

q.uipanel_tags = uipanel('parent',h_pan,'units',p.posun,'position',...
    [x y wpan hpan3],'title',ttl2,'fontunits',p.fntun,'fontsize',p.fntsz);
q = buildPanelTags(q,p,h_fig);

x = x + wpan + p.mg;

q.axes_traceSort = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz,'activepositionproperty','outerposition',...
    'gridlineStyle',':','nextPlot','replacechildren');
ylim(q.axes_traceSort,limy);
ylabel(q.axes_traceSort,ylbl1);
xlabel(q.axes_traceSort,xlbl1);
t = title(q.axes_traceSort,axttl1,'units',p.posun);
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



