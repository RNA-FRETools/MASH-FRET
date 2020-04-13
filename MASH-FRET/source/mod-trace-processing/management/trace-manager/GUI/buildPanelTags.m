function q = buildPanelTags(q,p,h_fig)

% defaults
wlst = 60;
fact = 5;
str0 = 'Subgroups';
str1 = {'no subgroup'};
str2 = 'Dismiss';
str3 = 'Subgroup tags';
str4 = {'no tag'};
str5 = 'Remove tag';
str6 = 'Tag';
str7 = 'TAG MOLECULES';
ttstr0 = 'Select a subgroup';
ttstr1 = 'Remove subgroup from subgroup list';
ttstr2 = 'Tag selected subgroup';
ttstr3 = 'Remove selected tag from tag list';
ttstr4 = 'Tag molecules of the selected subgroup with the corresponding tags';

% parents
h_pan = q.uipanel_tags;

% dimensions
pospan = get(h_pan,'position');
hlst = pospan(4)-p.mgbig-p.htxt-2*p.mg/2-p.hbut-p.mg;
wbut2 = pospan(3)-p.mg-wlst-2*p.mg;
wbut3 = getUItextWidth(str6,p.fntun,p.fntsz,'normal',p.tbl)+p.wbrd;
wpop2 = wbut2-wbut3-p.mg/fact;
hbut2 = 2*p.hbut;
hlst2 = hlst-p.hpop-p.mg-p.mg/2-p.hbut-p.mg-hbut2;

% lists strings
str_pop = colorTagNames(h_fig);

x = p.mg;
y = pospan(4)-p.mgbig-p.htxt;

q.text_pop = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'position',[x,y,wlst,p.htxt],'fontunits',p.fntun,'fontsize',p.fntsz,...
    'string',str0,'enable','off');

x = p.mg;
y = y-p.mg/2-hlst;

q.listbox_ranges = uicontrol('style','listbox','parent',h_pan,'units',...
    p.posun,'position',[x,y,wlst,hlst],'fontunits',p.fntun,'fontsize',...
    p.fntsz,'string',str1,'tooltipstring',ttstr0,'enable','off','callback',...
    {@listbox_ranges_Callback,h_fig});

y = y-p.mg/2-p.hbut;

q.pushbutton_dismissRange = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'string',str2,'tooltipstring',ttstr1,'position',...
    [x,y,wlst,p.hbut],'fontunits',p.fntun,'fontsize',p.fntsz,'callback',...
    {@pushbutton_dismissRange_Callback,h_fig},'enable','off');

x = x+wlst+p.mg;
y = pospan(4)-p.mgbig-p.htxt;

q.text_rangesTag = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'enable','off','position',[x y wbut2 p.htxt],'string',str3);

y = y-p.mg/2-p.hpop;

q.popupmenu_defTagPop = uicontrol('style','popup','parent',h_pan,'units',...
    p.posun,'enable','off','position',[x y wpop2 p.hpop],'string',str_pop);

x = x+wpop2+p.mg/fact;
y = y+(p.hpop-p.hbut)/2;

q.pushbutton_addTag2pop = uicontrol('style','pushbutton','Parent',h_pan,...
    'units',p.posun,'position',[x y wbut3 p.hbut],'string',str6,...
    'callback',{@pushbutton_addTag2pop_Callback,h_fig},'enable','off', ...
    'tooltipstring',ttstr2);

x = p.mg+wlst+p.mg;
y = y-(p.hpop-p.hbut)/2-p.mg-hlst2;

q.listbox_popTag = uicontrol('style','listbox','parent',h_pan,'units',...
    p.posun,'enable','off','position',[x y wbut2 hlst2],'string',str4);

y = y-p.mg/2-p.hbut;

q.pushbutton_remPopTag = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'enable','off','position',[x y wbut2 p.hbut],...
    'string',str5,'callback',{@pushbutton_remPopTag_Callback,h_fig}, ...
    'tooltipstring',ttstr3);

x = p.mg+wlst+p.mg;
y = y-p.mg-hbut2;

q.pushbutton_applyTag = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'position',[x y wbut2 hbut2],'string',...
    str7,'callback',{@pushbutton_applyTag_Callback,h_fig},'fontweight',...
    'bold','enable','off','tooltipstring',ttstr4);
