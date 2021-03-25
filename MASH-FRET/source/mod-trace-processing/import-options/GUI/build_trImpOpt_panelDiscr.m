function q = build_trImpOpt_panelDiscr(q,p,h_fig)
% q = build_trImpOpt_panelDiscr(q,p,h_fig)
%
% build_trImpOpt_panelDiscr builds panel "State trajectories" in ASCII import option window
%
% q: structure to update with handles to new uicontrols
% p: structure that contains default layout settings
% h_fig: handle to main figure

% defaults
str9 = 'column:';
str10 = 'to';
str0 = 'skip:';
str2 = 'discretized FRET data';

% get parent
h_pan = q.uipanel_discr;

% get dimensions
pospan = get(h_pan,'position');
wtxt6 = getUItextWidth(str9,p.fntun,p.fntsz,'normal',p.tbl);
wtxt7 = getUItextWidth(str10,p.fntun,p.fntsz,'normal',p.tbl);
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz,'normal',p.tbl);
wcb0 = pospan(3) - 2*p.mg;

% build GUI
x = p.mg;
y = p.mg + (p.hedit-p.htxt)/2;

q.text_startColSeq = uicontrol('Style','text','Parent',h_pan,'Units',...
    p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'String',str9,...
    'HorizontalAlignment','left','Position',[x y wtxt6 p.htxt]);

x = x + wtxt6;
y = y - (p.hedit-p.htxt)/2;

q.edit_startColSeq = uicontrol('Style','edit','Parent',h_pan,'Units',...
    p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_startColSeq_Callback,h_fig});

x = x + p.wedit + p.mged;
y = y + (p.hedit-p.htxt)/2;

q.text_stopColSeq = uicontrol('Style','text','Parent',h_pan,'Units',...
    p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'String',str10,...
    'Position',[x y wtxt7 p.htxt]);

x = x + wtxt7;
y = y - (p.hedit-p.htxt)/2;

q.edit_stopColSeq = uicontrol('Style','edit','Parent',h_pan,'Units',...
    p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_stopColSeq_Callback,h_fig});

x = x + p.wedit + p.mged;
y = y + (p.hedit-p.htxt)/2;

q.text_skip = uicontrol('Style','text','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',[x y wtxt0 p.htxt],...
    'String',str0,'HorizontalAlignment','left');

x = x + wtxt0;
y = y - (p.hedit-p.htxt)/2;

q.edit_skip = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y p.wedit p.hedit],'Callback',{@edit_skip_Callback,h_fig});

y = y + p.hedit + p.mg/2;
x = p.mg;

q.checkbox_dFRET = uicontrol('Style','checkbox','Parent',h_pan,'Units',...
    p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y wcb0 p.hcb],'String',str2,'FontAngle','italic','Callback',...
    {@checkbox_dFRET_Callback,h_fig});
