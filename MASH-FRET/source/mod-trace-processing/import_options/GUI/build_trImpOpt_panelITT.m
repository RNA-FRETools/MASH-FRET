function q = build_trImpOpt_panelITT(q,p,h_fig)
% q = build_trImpOpt_panelITT(q,p,h_fig)
%
% build_trImpOpt_panelITT builds panel "Intensity-time traces" in ASCII import option window
%
% q: structure to update with handles to new uicontrols
% p: structure that contains default layout settings
% h_fig: handle to main figure

% default
str0 = 'Wavelength:';
str1 = {'Select a laser'};
str2 = 'exc. 9';
str3 = 'nm';
str4 = 'nb. of excitations:';
str5 = '(row-wise)';
str6 = 'nb. of channels:';
str7 = '(column-wise)';
str8 = 'Time data';
str9 = 'column:';
str10 = 'to';
str11 = '(0 = end)';
str12 = 'row:';
str13 = 'Intensity data:';

% get parent
h_pan = q.uipanel_ITT;

% get dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz,'normal',p.tbl);
wpop0 = getUItextWidth(str2,p.fntun,p.fntsz,'normal',p.tbl) + p.warr;
wtxt1 = getUItextWidth(str3,p.fntun,p.fntsz,'normal',p.tbl);
wtxt2 = getUItextWidth(str4,p.fntun,p.fntsz,'normal',p.tbl);
wtxt3 = getUItextWidth(str5,p.fntun,p.fntsz,'normal',p.tbl);
wtxt5 = getUItextWidth(str7,p.fntun,p.fntsz,'normal',p.tbl);
wcb0 = getUItextWidth(str8,p.fntun,p.fntsz,'normal',p.tbl) + p.wbox;
wtxt6 = getUItextWidth(str9,p.fntun,p.fntsz,'normal',p.tbl);
wtxt7 = getUItextWidth(str10,p.fntun,p.fntsz,'normal',p.tbl);
wtxt8 = getUItextWidth(str11,p.fntun,p.fntsz,'normal',p.tbl);
wtxt9 = pospan(3)-2*p.mg;

% build GUI
y = p.mg+(p.hpop-p.htxt)/2;
x = p.mg;

uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'FontUnits',...
    p.fntun,'FontSize',p.fntsz,'String',str0,'HorizontalAlignment','left',...
    'Position',[x y wtxt0 p.htxt]);

x = x + wtxt0;
y = y-(p.hpop-p.htxt)/2;

q.popupmenu_exc = uicontrol('Style','popupmenu','Parent',h_pan,'Units',...
    p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y wpop0 p.hpop],'String',str1,'Callback',...
    {@popupmenu_exc_Callback,h_fig});

x = x + wpop0 + p.mg/2;
y = y+(p.hpop-p.hedit)/2;

q.edit_wl = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_wl_Callback,h_fig});

x = x + p.wedit;
y = y+(p.hedit-p.htxt)/2;

uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'FontUnits',...
    p.fntun,'FontSize',p.fntsz,'String',str3,'HorizontalAlignment','left',...
    'Position',[x y wtxt1 p.htxt]);

y = y - (p.hpop-p.htxt)/2 + p.hpop + p.mg/2 + (p.hedit-p.htxt)/2;
x = p.mg;

uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'FontUnits',...
    p.fntun,'FontSize',p.fntsz,'String',str4,'HorizontalAlignment','left',...
    'Position',[x y wtxt2 p.htxt]);

x = x + wtxt2;
y = y - (p.hedit-p.htxt)/2;

q.edit_nbExc = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_nbExc_Callback,h_fig});

x = x + p.wedit;
y = y + (p.hedit-p.htxt)/2;

uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'FontUnits',...
    p.fntun,'FontSize',p.fntsz,'String',str5,'HorizontalAlignment','right',...
    'Position',[x y wtxt3 p.htxt]);

y = y - (p.hedit-p.htxt)/2 + p.hedit + p.mg/2 + (p.hedit-p.htxt)/2;
x = p.mg;

uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'FontUnits',...
    p.fntun,'FontSize',p.fntsz,'String',str6,'HorizontalAlignment','left',...
    'Position',[x y wtxt2 p.htxt]);

x = x + wtxt2;
y = y - (p.hedit-p.htxt)/2;

q.edit_nbChan = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_nbChan_Callback,h_fig});

x = x + p.wedit;
y = y + (p.hedit-p.htxt)/2;

uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'FontUnits',...
    p.fntun,'FontSize',p.fntsz,'String',str7,'HorizontalAlignment','right',...
    'Position',[x y wtxt5 p.htxt]);

y = y  - (p.hedit-p.htxt)/2 + p.hedit + p.mg;
x = p.mg;

q.checkbox_timeCol = uicontrol('Style','checkbox','Parent',h_pan,'Units',...
    p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'String',str8,...
    'Position',[x y wcb0 p.hcb],'FontAngle','italic','Callback',...
    {@checkbox_timeCol_Callback,h_fig});

x = x + wcb0 + p.mg;
y = y + (p.hcb-p.htxt)/2;

q.text_timeCol = uicontrol('Style','text','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'String',str9,...
    'HorizontalAlignment','left','Position',[x y wtxt6 p.htxt]);

x = x + wtxt6;
y = y - (p.hedit-p.htxt)/2;

q.edit_timeCol = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_timeCol_Callback,h_fig});

y = y + (p.hcb-p.hedit)/2 + p.hcb + p.mg + (p.hedit-p.htxt)/2;
x = p.mg;

uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'FontUnits',...
    p.fntun,'FontSize',p.fntsz,'String',str9,'HorizontalAlignment','left',...
    'Position',[x y wtxt6 p.htxt]);

x = x + wtxt6;
y = y - (p.hedit-p.htxt)/2;

q.edit_startColI = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_startColI_Callback,h_fig});

x = x + p.wedit;
y = y + (p.hedit-p.htxt)/2;

uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'FontUnits',...
    p.fntun,'FontSize',p.fntsz,'String',str10,'Position',...
    [x y wtxt7 p.htxt]);

x = x + wtxt7;
y = y - (p.hedit-p.htxt)/2;

q.edit_stopColI = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_stopColI_Callback,h_fig});

x = x + p.wedit + p.mg;
y = y + (p.hedit-p.htxt)/2;

uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'FontUnits',...
    p.fntun,'FontSize',p.fntsz,'String',str11,'HorizontalAlignment','left',...
    'Position',[x y wtxt8 p.htxt]);

y = y + p.hedit + p.mg/2;
x = p.mg;

uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'FontUnits',...
    p.fntun,'FontSize',p.fntsz,'String',str12,'HorizontalAlignment','left',...
    'Position',[x y wtxt6 p.htxt]);

y = y - (p.hedit-p.htxt)/2;
x = x + wtxt6;

q.edit_startRow = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_startRow_Callback,h_fig});

y = y + (p.hedit-p.htxt)/2;
x = x + p.wedit;

uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'FontUnits',...
    p.fntun,'FontSize',p.fntsz,'String',str10,'Position',...
    [x y wtxt7 p.htxt]);

y = y - (p.hedit-p.htxt)/2;
x = x + wtxt7;

q.edit_stopRow = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_stopRow_Callback,h_fig});

y = y + (p.hedit-p.htxt)/2;
x = x + p.wedit + p.mg;

uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'FontUnits',...
    p.fntun,'FontSize',p.fntsz,'String',str11,'HorizontalAlignment','left',...
    'Position',[x y wtxt8 p.htxt]);

y = y - (p.hedit-p.htxt)/2 + p.hedit + p.mg/2;
x = p.mg;

uicontrol('Style','text','Parent',h_pan,'Units',p.posun,'FontUnits',...
    p.fntun,'FontSize',p.fntsz,'String',str13,'HorizontalAlignment','left',...
    'Position',[x y wtxt9 p.htxt],'FontAngle','italic');
