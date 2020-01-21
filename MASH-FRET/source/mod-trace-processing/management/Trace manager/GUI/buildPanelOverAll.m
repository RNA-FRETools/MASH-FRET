function q = buildPanelOverAll(q,p,h_fig)
% Build panel "Overall plots" and update main structure with handles to new uicontrols
%
% q.uipanel_overall: handle to panel "Overall"
%
% p.posun: position/dimensions units
% p.fntun: font units
% p.fntsz: main font size
% p.mg: main margin
% p.mgbig: large margin
% p.hpop: main popupmenu height
% p.htxt: main text height
% p.hedit: main edit field height
% p.hbut: main buton height
% p.wtxt3: small text width
% p.wedit: main edit field width

% default
xlow = 0;
xnbiv = 200;
xup = 1;
limy = [0 10000];
str0 = 'plot1:';
str1 = 'plot2:';
str2 = 'xbins:';
str3 = 'ybins:';
str4 = 'UPDATE';
str5 = 'TO MASH';
ttstr0 = 'lower interval value';
ttstr1 = 'number of interval';
ttstr2 = 'upper interval value';
ttstr3 = 'lower interval value';
ttstr4 = 'number of interval';
ttstr5 = 'upper interval value';
ttstr6 = 'Update the graphs with new parameters';
ttstr7 = 'Export selection to MASH';

% parents
h_pan = q.uipanel_overall;

% dimensions
pospan = get(h_pan,'Position');
wpop = 3*p.wedit+2*p.mg/2;
wbut = (wpop+p.wtxt3)/2;
haxes = pospan(4) - 2.5*p.mg;
waxes = pospan(3) - p.wtxt3 - wpop - 3*p.mg;
waxes1 = (waxes-2*p.mg)*0.75;
waxes2 = waxes - 2*p.mg - waxes1;

% list strings
str_plot = getStrPlot_overall(h_fig); % added by MH, 25.4.2019

% build GUI
x = p.mg;
y = pospan(4) - 1.5*p.mg - p.hpop;

q.text1 = uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'String',...
    str0,'HorizontalAlignment','center','Position',[x y p.wtxt3 p.htxt],...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'FontWeight','bold');

x = x + p.wtxt3 + p.mg;

% RB 2017-12-15: update str_plot
q.popupmenu_axes1 = uicontrol('Style','popupmenu','Parent',h_pan,'String',...
    str_plot{1},'Units',p.posun,'Position',[x y wpop p.hpop],'Callback',...
    {@popupmenu_axes_Callback, h_fig},'FontUnits',p.fntun,'FontSize',...
    p.fntsz);

x = p.mg;
y = y - p.mg - p.hpop;

q.text2 = uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'String',...
    str1,'HorizontalAlignment','center','Position',[x y p.wtxt3 p.htxt],...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'FontWeight','bold');

x = x + p.wtxt3 + p.mg;

% RB 2017-12-15: update str_plot 
q.popupmenu_axes2 = uicontrol('Style','popupmenu','Parent',h_pan,'Units',...
    p.posun,'String',str_plot{2},'Position',[x y wpop p.hpop],'Callback',...
    {@popupmenu_axes_Callback,h_fig},'FontUnits',p.fntun,'FontSize',...
    p.fntsz);

x = p.mg;
y = y - p.mg - p.hpop;

q.text3 = uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'String',...
    str2,'HorizontalAlignment','center','Position',[x y p.wtxt3 p.htxt],...
    'FontUnits',p.fntun,'FontSize',p.fntsz);

x = x + p.wtxt3 + p.mg;

q.edit_xlim_low = uicontrol('Style','edit','Parent',h_pan,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_lim_low_Callback,h_fig,1},...
    'String',num2str(xlow),'TooltipString',ttstr0);

x = x + p.mg/2 + p.wedit;

q.edit_xnbiv = uicontrol('Style','edit','Parent',h_pan,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_nbiv_Callback,h_fig,1},...
    'String',num2str(xnbiv),'TooltipString',ttstr1);

x = x + p.mg/2 + p.wedit;

q.edit_xlim_up = uicontrol('Style','edit','Parent',h_pan,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_lim_up_Callback,h_fig,1},...
    'String',num2str(xup),'TooltipString',ttstr2);

x = p.mg;
y = y - p.mg/2 - p.hedit;

q.text4 = uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'String',...
    str3,'HorizontalAlignment','center','Position',[x y p.wtxt3 p.htxt],...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Enable','off');

x = x + p.wtxt3 + p.mg;

q.edit_ylim_low = uicontrol('Style','edit','Parent',h_pan,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_lim_low_Callback,h_fig,2},...
    'String','','TooltipString',ttstr3,'Enable','off');

x = x + p.mg/2 + p.wedit;

q.edit_ynbiv = uicontrol('Style','edit','Parent',h_pan,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_nbiv_Callback,h_fig,2},...
    'String','','TooltipString',ttstr4,'Enable','off');

x = x + p.mg/2 + p.wedit;

q.edit_ylim_up = uicontrol('Style','edit','Parent',h_pan,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_lim_up_Callback,h_fig,2},...
    'String','','TooltipString',ttstr5,'Enable','off');

x = p.mg;
y = y - p.mgbig - p.hbut;

q.pushbutton_update = uicontrol('Style','pushbutton','Parent',h_pan,...
    'Units',p.posun,'Position',[x y wbut p.hbut],'String',str4,...
    'TooltipString',ttstr6,'Callback',{@pushbutton_update_Callback,h_fig},...
    'FontUnits',p.fntun,'FontSize',p.fntsz);

x = x + p.mg + wbut;

q.pushbutton_export = uicontrol('Style','pushbutton','Parent',h_pan,...
    'Units',p.posun,'FontWeight','bold','String',str5,'Position',...
    [x y wbut p.hbut],'Callback',{@menu_export_Callback,h_fig},...
    'TooltipString',ttstr7,'FontUnits',p.fntun,'FontSize',p.fntsz);

x = p.mg + p.wtxt3 + p.mg + wpop + p.mg;
y = p.mg;

q.axes_ovrAll_1 = axes('Parent',h_pan,'Units',p.posun,'FontUnits',p.fntun,...
    'FontSize',p.fntsz,'ActivePositionProperty','OuterPosition',...
    'GridLineStyle',':','NextPlot','replacechildren','ButtonDownFcn',...
    {@axes_ovrAll_1_ButtonDownFcn,h_fig});
ylim(q.axes_ovrAll_1,limy);
pos = getRealPosAxes([x y waxes1 haxes],...
    get(q.axes_ovrAll_1,'TightInset'),'traces');
pos(3:4) = pos(3:4) - p.fntsz;
pos(1:2) = pos(1:2) + p.fntsz;
set(q.axes_ovrAll_1,'Position',pos);

x = x + p.mg + waxes1;
y = p.mg;

q.axes_ovrAll_2 = axes('Parent',h_pan,'Units',p.posun,'FontUnits',p.fntun,...
    'FontSize',p.fntsz,'ActivePositionProperty','OuterPosition',...
    'GridLineStyle',':','NextPlot','replacechildren');
ylim(q.axes_ovrAll_2,limy);
pos1 = pos;
pos = getRealPosAxes([x y waxes2 haxes],...
    get(q.axes_ovrAll_2,'TightInset'),'traces'); 
pos([2 4]) = pos1([2 4]);
pos(3) = pos(3) - p.fntsz;
pos(1) = pos(1) + p.fntsz;
set(q.axes_ovrAll_2,'Position',pos);
