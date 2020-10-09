function q = build_trImpOpt_panelFactors(q,p,h_fig)
% q = build_trImpOpt_panelFactors(q,p,h_fig)
%
% build_trImpOpt_panelFactors builds panel "Correction factors" in ASCII import option window
%
% q: structure to update with handles to new uicontrols
% p: structure that contains default layout settings
% h_fig: handle to main figure

% default
str0 = '...';
str1 = 'Beta factors file';
str2 = 'Gamma factors file';

% parent
h_pan = q.uipanel_factors;

% dimensions
pospan = get(h_pan,'position');
wbut0 = getUItextWidth(str0,p.fntun,p.fntsz,'normal',p.tbl) + p.wbrd;
wedit0 = pospan(3)-2*p.mg-wbut0-p.mg;
wcb0 = pospan(3)-2*p.mg;

y = p.mg;
x = p.mg;

q.pushbutton_impBetFile = uicontrol('Style','pushbutton','Parent',h_pan,...
    'Units',p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y wbut0 p.hbut],'String',str0,'Callback',...
    {@pushbutton_impBetFile_Callback,h_fig});

x = x + wbut0 + p.mg;

q.edit_fnameBet = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'ForegroundColor',p.fntclr2,...
    'Position',[x y wedit0 p.hedit],'Callback',...
    {@edit_fnameBet_Callback,h_fig});

y = y + p.hbut + p.mg/2;
x = p.mg;

q.checkbox_impBet = uicontrol('Style','checkbox','Parent',h_pan,'Units',...
    p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y wcb0 p.hcb],'String',str1,'Callback',...
    {@checkbox_impBet_Callback,h_fig});


y = y + p.hcb + p.mg;

q.pushbutton_impGamFile = uicontrol('Style','pushbutton','Parent',h_pan,...
    'Units',p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y wbut0 p.hbut],'String',str0,'Callback',...
    {@pushbutton_impGamFile_Callback,h_fig});

x = x + wbut0 + p.mg;

q.edit_fnameGam = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'ForegroundColor',p.fntclr2,...
    'Position',[x y wedit0 p.hedit],'Callback',...
    {@edit_fnameGam_Callback,h_fig});

y = y + p.hbut + p.mg/2;
x = p.mg;

q.checkbox_impGam = uicontrol('Style','checkbox','Parent',h_pan,'Units',...
    p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y wcb0 p.hcb],'String',str2,'Callback',...
    {@checkbox_impGam_Callback,h_fig});
