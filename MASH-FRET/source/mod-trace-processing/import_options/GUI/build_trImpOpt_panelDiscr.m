function q = build_trImpOpt_panelDiscr(q,p,h_fig)
% q = build_trImpOpt_panelDiscr(q,p,h_fig)
%
% build_trImpOpt_panelDiscr builds panel "State trajectories" in ASCII import option window
%
% q: structure to update with handles to new uicontrols
% p: structure that contains default layout settings
% h_fig: handle to main figure

% defaults
str0 = 'every';
str1 = 'th column.';
str2 = 'discretized FRET data';

% get parent
h_pan = q.uipanel_discr;

% get dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz,'normal',p.tbl);
wtxt1 = getUItextWidth(str1,p.fntun,p.fntsz,'normal',p.tbl);
wcb0 = pospan(3) - 2*p.mg;

% build GUI
y = p.mg + (p.hedit-p.htxt)/2;
x = p.mg;

q.text_every = uicontrol('Style','text','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',[x y wtxt0 p.htxt],...
    'String',str0,'HorizontalAlignment','left');

x = x + wtxt0;
y = y - (p.hedit-p.htxt)/2;

q.edit_thcol = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_thcol_Callback,h_fig});

x = x + p.wedit;
y = y + (p.hedit-p.htxt)/2;

q.text_thcol = uicontrol('Style','text','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',[x y wtxt1 p.htxt],...
    'String',str1,'HorizontalAlignment','left');

y = y + p.hedit + p.mg/2;
x = p.mg;

q.checkbox_dFRET = uicontrol('Style','checkbox','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',[x y wcb0 p.hcb],...
    'String',str2,'Callback',{@checkbox_dFRET_Callback,h_fig},'FontAngle',...
    'italic');
