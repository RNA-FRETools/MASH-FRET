function q = buildPanelRanges(q,p,h_fig)
% Build panel "Ranges" and update main structure with handles to new uicontrols

% q.uipanel_range: handle to panel "Ranges"
%
% p.posun: position units
% p.fntun: font units
% p.fntsz: main font size
% p.mg: main margin
% p.mgbig: large margin
% p.htxt: main text height
% p.hedit: main edit field height
% p.wedit: main edit field width
% p.wtxt3: small text width
% p.hpop: main popupmenu height
% p.hbut: main button height

% defaults
xlow = 0;
xup = 1;
ylow = 0;
yup = 1;
conf1 = 50;
conf2 = 100;
str0 = 'Range bounds:';
str1 = 'xlow';
str2 = 'xup';
str3 = 'ylow';
str4 = 'yup';
str5 = 'Select trace if:';
str6 = {'at least','at most','between'};
str7 = 'and';
str8 = {'percents of the trace','data points'};
str9 = 'are included in the range.';
str10 = 'subgroup size: 0 molecule';
str11 = 'Save subgroup';
str12 = 'Molecule subgroups:';
str13 = {'no range'};
str14 = 'Dismiss subgroup';
str15 = 'Subgroup tags:';
str16 = 'Tag';
str17 = {'no tag'};
str18 = 'Untag';
str19 = 'APPLY TAG TO MOLECULES';
ttstr0 = 'Select a condition';
ttstr1 = 'Select a condition';
ttstr2 = 'Save range';
ttstr3 = 'Select a range';
ttstr4 = 'Delete selected subgroup';

% parents
h_pan = q.uipanel_range;

% dimensions
pospan = get(h_pan,'position');
wlst = pospan(3)-2*p.mg;
hlst = 3*p.htxt + 2*p.hedit + 1.5*p.mg;
wpop = 3*p.wedit+2*p.mg/2;

% lists strings
str_pop = colorTagNames(h_fig);

x = p.mg;
y = pospan(4) - 1.5*p.mg - p.htxt;

q.text5 = uicontrol('style','text','parent',h_pan,'units',p.posun,'string',...
    str0,'position',[x,y,2*p.wedit+p.mg/2,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'horizontalalignment','left','fontweight','bold');

y = y - p.mg - p.htxt - p.hedit;

q.edit_xrangeLow = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'string',num2str(xlow),'position',[x,y,p.wedit,p.hedit],'fontunits',...
    p.fntun,'fontsize',p.fntsz,'callback',{@edit_xrangeLow_Callback,h_fig});

y = y + p.hedit;

q.text_xrangeLow = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str1,'position',[x,y,p.wedit,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'horizontalalignment','center');

y = y - p.hedit;
x = x + p.wedit + p.mg/2;

q.edit_xrangeUp = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'string',num2str(xup),'position',[x,y,p.wedit,p.hedit],'fontunits',...
    p.fntun,'fontsize',p.fntsz,'callback',{@edit_xrangeUp_Callback,h_fig});

y = y + p.hedit;

q.text_xrangeUp = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str2,'position',[x,y,p.wedit,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'horizontalalignment','center');

y = y - p.hedit;
x = x + p.wedit + p.mg;

q.edit_yrangeLow = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'string',num2str(ylow),'position',[x,y,p.wedit,p.hedit],'fontunits',...
    p.fntun,'fontsize',p.fntsz,'callback',{@edit_yrangeLow_Callback,h_fig},...
    'enable','off');

y = y + p.hedit;

q.text_yrangeLow = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str3,'position',[x,y,p.wedit,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'horizontalalignment','center','enable','off');

y = y - p.hedit;
x = x + p.wedit + p.mg/2;

q.edit_yrangeUp = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'string',num2str(yup),'position',[x,y,p.wedit,p.hedit],'fontunits',...
    p.fntun,'fontsize',p.fntsz,'callback',{@edit_yrangeUp_Callback,h_fig},...
    'enable','off');

y = y + p.hedit;

q.text_yrangeUp = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str4,'position',[x,y,p.wedit,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'horizontalalignment','center','enable','off');

x = p.mg;
y = y - p.hedit - p.mg - p.htxt;

q.text_conf1 =  uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'position',[x,y,pospan(3)-2*p.mg,p.htxt],'string',...
    str5,'fontsize',p.fntsz,'horizontalalignment','left');

y = y - p.mg - p.htxt;

q.popupmenu_cond = uicontrol('style','popupmenu','parent',h_pan,'units',...
    p.posun,'position',[x,y,0.5*wpop,p.hpop],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'string',str6,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_cond_Callback,h_fig});

x = x + 0.5*wpop + p.mg/2;

q.edit_conf1 = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'position',[x,y,p.wedit,p.hedit],'fontunits',p.fntun,'fontsize',...
    p.fntsz,'string',num2str(conf1),'callback',{@edit_conf_Callback,h_fig});

x = x + p.wedit;
y = y + (p.hedit-p.htxt)/2;

q.text_and = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'position',[x,y,p.wtxt3,p.htxt],'fontunits',p.fntun,'fontsize',p.fntsz,...
    'string',str7,'horizontalalignment','center','enable','off');

x = x + p.wtxt3;
y = y - (p.hedit-p.htxt)/2;

q.edit_conf2 = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'position',[x,y,p.wedit,p.hedit],'fontunits',p.fntun,'fontsize',...
    p.fntsz,'string',num2str(conf2),'callback',{@edit_conf_Callback,h_fig},...
    'enable','off');

x = p.mg;
y = y - p.mg - p.hpop;

q.popupmenu_units = uicontrol('style','popupmenu','parent',h_pan,'units',...
    p.posun,'position',[x,y,pospan(3)-2*p.mg,p.hpop],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'string',str8,'tooltipstring',ttstr1,'callback',...
    {@popupmenu_units_Callback,h_fig});

y = y - p.mg - p.htxt;

q.text_conf2 =  uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'position',[x,y,pospan(3)-2*p.mg,p.htxt],'fontunits',p.fntun,'fontsize',...
    p.fntsz,'string',str9,'horizontalalignment','left');

y = y - p.mgbig - p.htxt;

q.text_Npop = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'position',[x,y,pospan(3)-2*p.mg,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'string',str10,'horizontalalignment','left',...
    'fontweight','bold');

y = y - p.mg - p.hbut;

q.pushbutton_saveRange = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz,'position',...
    [x,y,wlst,p.hbut],'string',str11,'tooltipstring',ttstr2,'callback',...
    {@pushbutton_saveRange_Callback,h_fig},'enable','off');

y = y - p.mgbig - p.hedit;

q.text_pop = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'position',[x,y,pospan(3)-2*p.mg,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'string',str12,'horizontalalignment','left',...
    'fontweight','bold','enable','off');

x = p.mg;
y = y - p.mg - hlst;

q.listbox_ranges = uicontrol('style','listbox','parent',h_pan,'units',...
    p.posun,'position',[x,y,wlst,hlst],'fontunits',p.fntun,'fontsize',...
    p.fntsz,'string',str13,'tooltipstring',ttstr3,'enable','off','callback',...
    {@listbox_ranges_Callback,h_fig});

y = y - p.mg - p.hbut;

q.pushbutton_dismissRange = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'string',str14,'tooltipstring',ttstr4,'position',...
    [x,y,wlst,p.hbut],'fontunits',p.fntun,'fontsize',p.fntsz,'callback',...
    {@pushbutton_dismissRange_Callback,h_fig},'enable','off');

y = y - p.mgbig - p.hedit;

q.text_tag = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'position',[x,y,pospan(3)-2*p.mg,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'string',str15,'horizontalalignment','left',...
    'fontweight','bold','enable','off');

y = y - p.mg - p.hbut;

q.pushbutton_addTag2pop = uicontrol('style','pushbutton','Parent',h_pan,...
    'units',p.posun,'position',[x y p.wedit p.hbut],'string',str16,...
    'callback',{@pushbutton_addTag2pop_Callback,h_fig},'enable','off');

x = x + p.wedit + p.mg;

q.popupmenu_defTagPop = uicontrol('style','popup','parent',h_pan,'units',...
    p.posun,'enable','off','position',[x y pospan(3)-3*p.mg-p.wedit p.hpop],...
    'string',str_pop);

x = p.mg;
y = y - p.mg - hlst;

q.listbox_popTag = uicontrol('style','listbox','parent',h_pan,'units',...
    p.posun,'enable','off','position',[x y pospan(3)-2*p.mg hlst],'string',...
    str17);

y = y - p.mg - p.hbut;

q.pushbutton_remPopTag = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'enable','off','position',[x y pospan(3)-2*p.mg p.hbut],...
    'string',str18,'callback',{@pushbutton_remPopTag_Callback,h_fig});

hbut = y-2*p.mg;
y = p.mg;

q.pushbutton_applyTag = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'position',[x y pospan(3)-2*p.mg hbut],'string',...
    str19,'callback',{@pushbutton_applyTag_Callback,h_fig},'fontweight',...
    'bold','enable','off');

