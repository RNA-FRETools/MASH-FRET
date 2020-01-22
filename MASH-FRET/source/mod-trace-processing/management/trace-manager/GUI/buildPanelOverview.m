function q = buildPanelOverview(q,p,h_fig)
% Build panel "Overview" and update main structure with handles to new uicontrols

% q.uipanel_overview: handle to panel "Overview"
%
% p.posun: position units
% p.fntun: font units
% p.fntsz: main font size
% p.mg: main margin
% p.mgbig: large margin
% p.wedit: main edit field width
% p.hbut: main button height
% p.htxt: main text height

% defaults
fact = 5;
wsld = 20; % slider bar x-dimension
arrow_up = repmat([0.92 0.92 0.92 0.92 0.92 0.92 0 0.92 0.92 0.92 0.92 0.92;
    0.92 0.92 0.92 1    1    0    0 0    0.92 0.92 0.92 0.92;
    0.92 0.92 1    1    0    0    0 0    0    0.92 0.92 0.92;
    0.92 1    1    0    0    0    0 0    0    0    0.92 0.92;
    1    1    0    0    0    0    0 0    0    0    0    0.85;
    1    0    0    0    0    0    0 0    0    0    0    0;
    1    1    1    1    1    1    1 1    1    1    1    0.85],[1,1,3]);
str0 = 'selection';
str1 = 'tags';
str2 = {'current','all','none','inverse','add [tag]','add not [tag]',...
    'remove [tag]','remove not [tag]'};
str3 = 'Apply';
str4 = 'Untag all';
str5 = 'Tag selection';
str6 = 'define a new tag';
str7 = 'Set color';
str8 = 'Delete';
str9 = 'disp:';
ttstr0 = 'Refine selection';
ttstr1 = 'Clear tags from molecules';
ttstr2 = 'Tag selected molecules';
ttstr3 = 'Select a tag to apply to the moelcule selection';
ttstr4 = 'Select a tag to configure';
ttstr5 = 'Set color of sleected tag';
ttstr6 = 'Delete selected tag';
ttstr7 = 'Hide overall panel';
ttstr8 = 'Number of molecule per view';

% parent
h_pan = q.uipanel_overview;

% list strings
str_lst = colorTagNames(h_fig);

% dimensions
pospan = get(h_pan,'position');
wpop2 = getUItextWidth(str2{1},p.fntun,p.fntsz,'normal',p.tbl) + p.warr;
wpop3 = getUItextWidth(str_lst{1},p.fntun,p.fntsz,'normal',p.tbl) + p.warr;
wbut2 = getUItextWidth(str3,p.fntun,p.fntsz,'normal',p.tbl) + p.wbrd;
wbut3 = getUItextWidth(str4,p.fntun,p.fntsz,'normal',p.tbl) + p.wbrd;
wbut4 = getUItextWidth(str5,p.fntun,p.fntsz,'normal',p.tbl) + p.wbrd;
wedit2 = getUItextWidth(str6,p.fntun,p.fntsz,'normal',p.tbl) + p.wbrd;
wbut5 = getUItextWidth(str7,p.fntun,p.fntsz,'normal',p.tbl) + p.wbrd;
wbut6 = getUItextWidth(str8,p.fntun,p.fntsz,'normal',p.tbl) + p.wbrd;
wtxt2 = getUItextWidth(str9,p.fntun,p.fntsz,'normal',p.tbl);
wbut7 = p.wedit;
mgtool = (pospan(3)-p.mg-wpop2-p.mg/fact-wpop3-p.mg/fact-wbut2-wbut3-...
    p.mg/fact-wbut4-p.mg/fact-wpop3-wedit2-p.mg/fact-wpop3-p.mg/fact-...
    wbut5-p.mg/fact-wbut6-wtxt2-p.wedit-p.mg/2-wbut7-p.mg)/3;
h_sld = pospan(4) - 1.5*p.mg - p.htxt - p.hpop - p.mg;

% "reduce panel" userdata
dat.arrow = flip(arrow_up,1);% close
dat.open = 1;
dat.tooltip = 'Show overall panel';% close
dat.visible = 'off';

% sliding bar steps and visibility
N = numel(q.molValid);
if N<p.defNperPage
    N_disp = N;
else
    N_disp = p.defNperPage;
end
if N<=N_disp || N_disp==0
    sbstep0 = 1;
    sbstep1 = 1;
    sbmin = 0;
    sbmax = 1;
    sbvis = 'off';
else
    sbvis = 'on';
    sbmin = 1;
    sbmax = N-N_disp+1;
    sbstep0 = 1/(N-N_disp);
    sbstep1 = N_disp/(N-N_disp);
end

x = p.mg;
y = pospan(4) - 1.5*p.mg - p.htxt;
    
% added by MH, 24.4.2019
q.text_selection = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str0,'position',[x,y,wpop2,p.htxt],'fontunits',p.fntun, ...
    'fontsize', p.fntsz);

x = x+wpop2+p.mg/fact;

q.text_selectTags = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str1,'position',[x,y,wpop3,p.htxt],'fontunits',p.fntun, ...
    'fontsize', p.fntsz,'enable','off');

x = p.mg;
y = y-p.hpop;

% added by MH, 24.4.2019
q.popupmenu_selection = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'position',[x,y,wpop2,p.hpop],'fontunits',p.fntun,...
    'fontsize', p.fntsz,'string',str2,'value',1,'callback',...
    {@popupmenu_selection_Callback,h_fig});

x = x+wpop2+p.mg/fact;

% added by MH, 22.1.2020
q.popupmenu_selectTags = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'position',[x,y,wpop3,p.hpop],'fontunits',p.fntun,...
    'fontsize', p.fntsz,'string',str_lst,'value',1,'enable','off');

x = x+wpop3+p.mg/fact;
y = y+(p.hpop-p.hbut)/2;

q.pushbutton_select = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'string',str3,'position',[x y wbut2 p.hbut],...
    'tooltipString',ttstr0,'fontunits',p.fntun,'fontsize',p.fntsz,...
    'callback',{@pushbutton_select_Callback,h_fig},'enable','off');

x = x+wbut2+mgtool;

q.pushbutton_untagAll = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'string',str4,'position',[x y wbut3 p.hbut],...
    'tooltipString',ttstr1,'fontunits',p.fntun,'fontsize',p.fntsz,...
    'callback',{@pushbutton_untagAll_Callback,h_fig});

x = x+wbut3+p.mg/fact;

q.pushbutton_addSelectTag = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'string',str5,'position',[x y wbut4 p.hbut],...
    'tooltipString',ttstr2,'fontunits',p.fntun,'fontsize',p.fntsz,...
    'callback',{@pushbutton_addSelectTag_Callback,h_fig},'enable','off');

x = x+wbut4+p.mg/fact;
y = y+p.hpop;

q.text_addSelectTags = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'string',str1,'position',[x,y,wpop3,p.htxt],'fontunits',...
    p.fntun,'fontsize', p.fntsz);

y = y-p.hpop;

q.popupmenu_addSelectTag = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'position',[x,y,wpop3,p.hpop],'fontunits',p.fntun,...
    'fontsize', p.fntsz,'string',str_lst,'value',1,'tooltipstring',ttstr3,...
    'callback',{@popupmenu_addSelectTag_Callback,h_fig});

x = x+wpop3+mgtool;
y = y+(p.hbut-p.hedit)/2;

% edit box to define a molecule tag, added by FS, 24.4.2018
q.edit_molTag = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'String',str6,'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y wedit2 p.hedit],'Callback',{@edit_addMolTag_Callback,h_fig});

x = x+wedit2+p.mg/fact;
y = y-(p.hpop-p.hedit)/2+p.hpop;

q.text_molTag = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'string',str1,'position',[x,y,wpop3,p.htxt],'fontunits',...
    p.fntun,'fontsize', p.fntsz);

y = y-p.hpop;

% popup menu to select molecule tag, added by FS, 24.4.2018
% add callback, MH 24.4.2019
q.popup_molTag = uicontrol('Style','popup','Parent',h_pan,'Units',p.posun, ...
    'String',str_lst,'Position',[x y wpop3 p.hbut],'TooltipString',ttstr4, ...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Callback',...
    {@popup_molTag_Callback,h_fig});

x = x+wpop3+p.mg/fact;
y = y+(p.hpop-p.hbut)/2;

% added by MH, 24.4.2019
q.pushbutton_tagClr = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'string',str7,'position',[x y wbut5 p.hbut],...
    'tooltipstring',ttstr5,'fontunits',p.fntun,'fontsize',p.fntsz,...
    'callback',{@pushbutton_tagClr_Callback,h_fig},'enable','off');

x = x+wbut5+p.mg/fact;

% popup menu to select molecule tag, added by FS, 24.4.2018
q.pushbutton_deleteMolTag = uicontrol('Style','pushbutton','Parent',h_pan,...
    'Units',p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'String',str8,...
    'Position',[x y wbut6 p.hbut],'TooltipString',ttstr6,'Callback',...
    {@pushbutton_deleteMolTag_Callback,h_fig},'enable','off');

x = pospan(3)-p.mg-wbut7;

q.pushbutton_reduce = uicontrol('Style','pushbutton','Parent',h_pan,...
    'Units',p.posun,'Position',[x y wbut7 p.hbut],'CData',arrow_up,...
    'TooltipString',ttstr7,'Callback',{@pushbutton_reduce_Callback,h_fig},...
    'userdata',dat);

x = x-p.mg/2-p.wedit;
y = y+(p.hbut-p.hedit)/2;

q.edit_nbTotMol = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'Position',[x y p.wedit p.hedit],'String',num2str(p.defNperPage),...
    'TooltipString',ttstr8,'Callback',{@edit_nbTotMol_Callback,h_fig});

x = x-wtxt2;
y = y+(p.hedit-p.htxt)/2;

q.textNmol = uicontrol('Style','text','Parent',h_pan,'Units',p.posun,...
    'String',str9,'HorizontalAlignment','right','Position',...
    [x y wtxt2 p.htxt],'FontUnits',p.fntun,'FontSize',p.fntsz);

x = pospan(3) - p.mg - wsld;
y = p.mg;

q.slider = uicontrol('Style','slider','Parent',h_pan,'Units',p.posun,...
    'Position',[x y wsld h_sld],'Value',sbmax,'Max',sbmax,'Min',...
    sbmin,'Callback',{@slider_Callback,h_fig},'SliderStep',...
    [sbstep0 sbstep1],'Visible',sbvis);

