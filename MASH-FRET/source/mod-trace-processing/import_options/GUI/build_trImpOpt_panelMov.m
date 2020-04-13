function q = build_trImpOpt_panelMov(q,p,h_fig)
% q = build_trImpOpt_panelMov(q,p,h_fig)
%
% build_trImpOpt_panelMov builds panel "Single moelcule video" in ASCII import option window
%
% q: structure to update with handles to new uicontrols
% p: structure that contains default layout settings
% h_fig: handle to main figure

% default
str0 = '...';
str1 = 'Video file';

% get parent
h_pan = q.uipanel_mov;

% get dimensions
pospan = get(h_pan,'position');
wbut0 = getUItextWidth(str0,p.fntun,p.fntsz,'normal',p.tbl) + p.wbrd;
wedit0 = pospan(3)-2*p.mg-wbut0-p.mg;
wcb0 = pospan(3)-2*p.mg;

y = p.mg;
x = p.mg;

q.pushbutton_impMovFile = uicontrol('Style','pushbutton','Parent',h_pan,...
    'Units',p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y wbut0 p.hbut],'String',str0,'Callback',...
    {@pushbutton_impMovFile_Callback,h_fig});

x = x + wbut0 + p.mg;
y = y + (p.hbut-p.hedit)/2;

q.edit_fnameMov = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',[x y wedit0 p.hedit],...
    'ForegroundColor',p.fntclr2,'Callback',{@edit_fnameMov_Callback,h_fig});

y = y + p.hbut + p.mg/2;
x = p.mg;

q.checkbox_impMov = uicontrol('Style','checkbox','Parent',h_pan,'Units',...
    p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y wcb0 p.hcb],'String',str1,'Callback',...
    {@checkbox_impMov_Callback,h_fig});


