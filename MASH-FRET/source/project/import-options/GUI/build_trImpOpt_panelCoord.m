function q = build_trImpOpt_panelCoord(q,p,h_fig)
% q = build_trImpOpt_panelCoord(q,p,h_fig)
%
% build_trImpOpt_panelCoord builds panel "Molecule coordinates" in ASCII import option window
%
% q: structure to update with handles to new uicontrols
% p: structure that contains default layout settings
% h_fig: handle to main figure

% default
str0 = 'In traces file';
str1 = 'line:';
str2 = 'Movie width:';
str3 = '...';
str4 = 'External file';
str5 = 'Import options';

% get parent
h_pan = q.uipanel_coord;

% get dimensions
pospan = get(h_pan,'position');
wcb0 = getUItextWidth(str0,p.fntun,p.fntsz,'normal',p.tbl)+p.wbox;
wtxt0 = getUItextWidth(str1,p.fntun,p.fntsz,'normal',p.tbl);
wtxt1 = getUItextWidth(str2,p.fntun,p.fntsz,'normal',p.tbl);
wbut0 = getUItextWidth(str3,p.fntun,p.fntsz,'normal',p.tbl)+p.wbrd;
wedit1 = pospan(3)-p.mg-wbut0-2*p.mg;
wbut1 = getUItextWidth(str4,p.fntun,p.fntsz,'normal',p.tbl)+p.wbox;
wbut2 = getUItextWidth(str5,p.fntun,p.fntsz,'normal',p.tbl)+p.wbrd;

% build GUI
y = p.mg;
x = p.mg;

q.checkbox_inTTfile = uicontrol('Style','checkbox','Parent',h_pan,'Units',...
    p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y wcb0 p.hcb],'String',str0,'Callback',...
    {@checkbox_inTTfile_Callback,h_fig});

x = x + wcb0 + p.mg;
y = y + (p.hcb-p.htxt)/2;

q.text_rowCoord = uicontrol('Style','text','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',[x y wtxt0 p.htxt],...
    'String',str1,'HorizontalAlignment','right');

x = x + wtxt0;
y = y - (p.hedit-p.htxt)/2;

q.edit_rowCoord = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_rowCoord_Callback,h_fig});

y = y - (p.hcb-p.hedit)/2 + p.hcb + p.mg + (p.hedit-p.htxt)/2;
x = p.mg;

q.text_movWidth = uicontrol('Style','text','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',[x y wtxt1 p.htxt],...
    'String',str2,'HorizontalAlignment','left');

x = x + wtxt1;
y = y - (p.hedit-p.htxt)/2;

q.edit_movWidth = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_movWidth_Callback,h_fig});

y = y + p.hedit + p.mg/2;
x = p.mg;

q.pushbutton_impCoordFile = uicontrol('Style','pushbutton','Parent',h_pan,...
    'Units',p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y wbut0 p.hbut],'String',str3,'Callback',...
    {@pushbutton_impCoordFile_Callback,h_fig});

x = x + wbut0 + p.mg;
y = y + (p.hbut-p.hedit)/2;

q.edit_fnameCoord = uicontrol('Style','edit','Parent',h_pan,'Units',...
    p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y wedit1 p.hedit],'ForegroundColor',p.fntclr2,'Callback',...
    {@edit_fnameCoord_Callback,h_fig});

y = y + p.hbut + p.mg/2;
x = p.mg;

q.checkbox_extFile = uicontrol('Style','checkbox','Parent',h_pan,...
    'String',str4,'Units',p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,...
    'Position',[x y wbut1 p.hcb],'Callback',...
    {@checkbox_extFile_Callback,h_fig});

x = pospan(3)-p.mg-wbut2;

q.pushbutton_impCoordOpt = uicontrol('Style','pushbutton','Parent',...
    h_pan,'Units',p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,...
    'Position',[x y wbut2 p.hbut],'String',str5,'Callback',...
    {@pushbutton_impCoordOpt_Callback,h_fig});

