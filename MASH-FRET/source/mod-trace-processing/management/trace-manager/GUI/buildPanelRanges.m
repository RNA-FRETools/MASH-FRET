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
fact = 5;
xlow = 0;
xup = 1;
ylow = 0;
yup = 1;
conf1 = 50;
conf2 = 100;
str0 = 'xlow';
str1 = 'xup';
str2 = 'ylow';
str3 = 'yup';
str4 = 'Select trace if:';
str5 = {'at least','at most','between'};
str6 = 'and';
str7 = {'percents of the trace','data points'};
str8 = 'are included in the range.';
str10 = 'subgroup size: 0 molecule';
str11 = 'Save range';
ttstr0 = 'Select a condition';
ttstr1 = 'Select a condition';
ttstr2 = 'Export range to panel "Tags"';

% parents
h_pan = q.uipanel_range;

% dimensions
pospan = get(h_pan,'position');
wpop = 3*p.wedit+2*p.mg/2;
wtxt4 = pospan(3)-2*p.mg;

x = p.mg;
y = pospan(4)-p.mgbig-p.htxt;

q.text_xrangeLow = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str0,'position',[x,y,p.wedit,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'horizontalalignment','center');

x = x+p.wedit+p.mg/fact;

q.text_xrangeUp = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str1,'position',[x,y,p.wedit,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'horizontalalignment','center');

x = x+p.wedit+p.mg;

q.text_yrangeLow = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str2,'position',[x,y,p.wedit,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'horizontalalignment','center','enable','off');

x = x+p.wedit+p.mg/fact;

q.text_yrangeUp = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str3,'position',[x,y,p.wedit,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'horizontalalignment','center','enable','off');

x = p.mg;
y = y-p.hedit;

q.edit_xrangeLow = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'string',num2str(xlow),'position',[x,y,p.wedit,p.hedit],'fontunits',...
    p.fntun,'fontsize',p.fntsz,'callback',{@edit_xrangeLow_Callback,h_fig});

x = x+p.wedit+p.mg/fact;

q.edit_xrangeUp = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'string',num2str(xup),'position',[x,y,p.wedit,p.hedit],'fontunits',...
    p.fntun,'fontsize',p.fntsz,'callback',{@edit_xrangeUp_Callback,h_fig});

x = x+p.wedit+p.mg;

q.edit_yrangeLow = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'string',num2str(ylow),'position',[x,y,p.wedit,p.hedit],'fontunits',...
    p.fntun,'fontsize',p.fntsz,'callback',{@edit_yrangeLow_Callback,h_fig},...
    'enable','off');

x = x+p.wedit+p.mg/fact;

q.edit_yrangeUp = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'string',num2str(yup),'position',[x,y,p.wedit,p.hedit],'fontunits',...
    p.fntun,'fontsize',p.fntsz,'callback',{@edit_yrangeUp_Callback,h_fig},...
    'enable','off');

x = p.mg;
y = y-p.mg-p.htxt;

q.text_conf1 =  uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'position',[x,y,wtxt4,p.htxt],'string',str4,...
    'fontsize',p.fntsz,'horizontalalignment','left');

y = y-p.mg/2-p.hpop;

q.popupmenu_cond = uicontrol('style','popupmenu','parent',h_pan,'units',...
    p.posun,'position',[x,y,0.5*wpop,p.hpop],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'string',str5,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_cond_Callback,h_fig});

x = x+0.5*wpop+p.mg/2;
y = y+(p.hpop-p.hedit)/2;

q.edit_conf1 = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'position',[x,y,p.wedit,p.hedit],'fontunits',p.fntun,'fontsize',...
    p.fntsz,'string',num2str(conf1),'callback',{@edit_conf_Callback,h_fig});

x = x+p.wedit;
y = y+(p.hedit-p.htxt)/2;

q.text_and = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'position',[x,y,p.wtxt3,p.htxt],'fontunits',p.fntun,'fontsize',p.fntsz,...
    'string',str6,'horizontalalignment','center','enable','off');

x = x+p.wtxt3;
y = y-(p.hedit-p.htxt)/2;

q.edit_conf2 = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'position',[x,y,p.wedit,p.hedit],'fontunits',p.fntun,'fontsize',...
    p.fntsz,'string',num2str(conf2),'callback',{@edit_conf_Callback,h_fig},...
    'enable','off');

x = p.mg;
y = y-(p.hpop-p.hedit)/2-p.mg/2-p.hpop;

q.popupmenu_units = uicontrol('style','popupmenu','parent',h_pan,'units',...
    p.posun,'position',[x,y,wtxt4,p.hpop],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'string',str7,'tooltipstring',ttstr1,'callback',...
    {@popupmenu_units_Callback,h_fig});

y = y-p.mg/2-p.htxt;

q.text_conf2 =  uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'position',[x,y,wtxt4,p.htxt],'fontunits',p.fntun,'fontsize',...
    p.fntsz,'string',str8,'horizontalalignment','left');

y = y-p.mgbig-p.htxt;

q.text_Npop = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'position',[x,y,wtxt4,p.htxt],'fontunits',p.fntun,...
    'fontsize',p.fntsz,'string',str10,'horizontalalignment','left',...
    'fontweight','bold');

y = y-p.mg-p.hbut;

q.pushbutton_saveRange = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz,'position',...
    [x,y,wtxt4,p.hbut],'string',str11,'tooltipstring',ttstr2,'callback',...
    {@pushbutton_saveRange_Callback,h_fig},'enable','off');


