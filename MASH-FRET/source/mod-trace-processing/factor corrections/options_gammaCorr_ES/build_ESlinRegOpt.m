function h_fig2 = build_ESlinRegOpt(h_fig)

% default
mg = 10;
fact = 5;
mgpan = 15;
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
hbut0 = 22;
wbox = 15;
wttstr = 250;
posun = 'pixels';
fntun = 'points';
fntsz = 8;
limx0 = [-0.2,1.2];
limy0 = [1,5];
xlbl0 = 'FRET';
ylbl0 = '1/S';
str0 = 'subgroup:';
str1 = {'Select subgroup'};
str2 = 'Emin';
str3 = 'nbin';
str4 = 'Emax';
str5 = '1/Smin';
str6 = 'nbin';
str7 = '1/Smax';
str8 = 'refresh calculations';
str9 = cat(2,char(947),' =');
str10 = cat(2,char(946),' =');
str11 = 'show corrected ES';
str12 = 'Save and close';
ttl0 = 'Factor calculation via linear regression';
ttl1 = 'Results';

% collect figure parameters
h = guidata(h_fig);
hndls = [h.figure_dummy,h.text_dummy];
tbl = h.charDimTable;

% tooltip strings
ttstr0 = wrapStrToWidth('<b>Select subgroup</b> used for building ES histogram.',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr1 = wrapStrToWidth('<b>E boundaries:</b> lower limit of E-axis',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr2 = wrapStrToWidth('<b>E intervals:</b> number of intervals in E-axis',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr3 = wrapStrToWidth('<b>E boundaries:</b> upper limit of E-axis',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr4 = wrapStrToWidth('<b>1/S boundaries:</b> lower limit of (1/S)-axis',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr5 = wrapStrToWidth('<b>1/S intervals:</b> number of intervals in (1/S)-axis',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr6 = wrapStrToWidth('<b>1/S boundaries:</b> upper limit of (1/S)-axis',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr7 = wrapStrToWidth('<b>Start linear regression</b>: E-S data points will be analyzed to determine global coefficients gamma and beta.',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr8 = wrapStrToWidth('<b>Gamma factor</b> calculated from the linear regression.',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr9 = wrapStrToWidth('<b>Beta factor</b> calculated from the linear regression.',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr10 = wrapStrToWidth('Show ES histogram after <b>gamma- and beta-correction</b>.',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr11 = wrapStrToWidth('<b>Export to MASH</b> the calculated gamma and beta-factors.',fntun,fntsz,'normal',wttstr,'html',hndls);

% get dimensions
posfig = getPixPos(h_fig);
wtxt0 = getUItextWidth(str0,fntun,fntsz,'normal',tbl);
wtxt1 = getUItextWidth(str9,fntun,fntsz,'normal',tbl);
wcb0 = getUItextWidth(str11,fntun,fntsz,'normal',tbl) + wbox;
wpan0 = mg+wcb0+mg;
wpop0 = wpan0-wtxt0;
wedit0 = (wpan0-2*mg/fact)/3;
hpan0 = mgpan+mg+hedit0+mg/2+hedit0+mg+hedit0+mg+hbut0+mg;
hfig = mg+hedit0+mg+hpop0+mg+htxt0+hedit0+mg/2+htxt0+hedit0+mg+hbut0+mg+...
    hpan0+mg;
waxes0 = hfig-mg-mg;
haxes0 = hfig-mg-mg;
wfig = mg+wpan0+mg+waxes0+mg;

p = h.param.ttPr;
proj = p.curr_proj;
clr = p.proj{proj}.colours;
fret = p.proj{proj}.fix{3}(8);
str_dat = removeHtml(get(h.popupmenu_gammaFRET,'string'));
bgcol = clr{2}(fret,1:3);
fntcol = ones(1,3)*(sum(clr{2}(fret,1:3))<=1.5);

q = struct();

x = posfig(1)+(posfig(3)-wfig)/2;
y = posfig(2)+(posfig(4)-hfig)/2;

h.figure_ESlinRegOpt = figure('units',posun,'numbertitle','off','menubar',...
    'none','position',[x,y,wfig,hfig],'visible','on','name',ttl0,...
    'closerequestfcn',{@figure_ESlinRegOpt_CloseRequestFcn,h_fig});
h_fig2 = h.figure_ESlinRegOpt;

x = mg;
y = hfig-mg-hpop0;

q.edit_data = uicontrol('style','edit','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wpan0,hpop0],...
    'string',str_dat{fret+1},'backgroundcolor',bgcol,'foregroundcolor',...
    fntcol,'enable','inactive');

x = mg;
y = y-mg-hpop0+(hpop0-htxt0)/2;

q.text_tag = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wtxt0,htxt0],...
    'string',str0,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hpop0-htxt0)/2;

q.popupmenu_tag = uicontrol('style','popupmenu','parent',h_fig2,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wpop0,hpop0],...
    'string',str1,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_tag_ESopt_Callback,h_fig,h_fig2});

x = mg;
y = y-mg-htxt0;

q.text_Emin = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str2,'horizontalalignment','center');

x = x+wedit0+mg/fact;

q.text_Ebin = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str3,'horizontalalignment','center');

x = x+wedit0+mg/fact;

q.text_Emax = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str4,'horizontalalignment','center');

x = mg;
y = y-hedit0;

q.edit_Emin = uicontrol('style','edit','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr1,'callback',...
    {@edit_Emin_ESopt_Callback,h_fig,h_fig2});

x = x+wedit0+mg/fact;

q.edit_Ebin = uicontrol('style','edit','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr2,'callback',...
    {@edit_Ebin_ESopt_Callback,h_fig,h_fig2});

x = x+wedit0+mg/fact;

q.edit_Emax = uicontrol('style','edit','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr3,'callback',...
    {@edit_Emax_ESopt_Callback,h_fig,h_fig2});

x = mg;
y = y-mg/2-htxt0;

q.text_Smin = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str5,'horizontalalignment','center');

x = x+wedit0+mg/fact;

q.text_Sbin = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str6,'horizontalalignment','center');

x = x+wedit0+mg/fact;

q.text_Smax = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str7,'horizontalalignment','center');

x = mg;
y = y-hedit0;

q.edit_Smin = uicontrol('style','edit','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr4,'callback',...
    {@edit_Smin_ESopt_Callback,h_fig,h_fig2});

x = x+wedit0+mg/fact;

q.edit_Sbin = uicontrol('style','edit','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr5,'callback',...
    {@edit_Sbin_ESopt_Callback,h_fig,h_fig2});

x = x+wedit0+mg/fact;

q.edit_Smax = uicontrol('style','edit','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr6,'callback',...
    {@edit_Smax_ESopt_Callback,h_fig,h_fig2});

x = mg;
y = y-mg-hbut0;

q.pushbutton_linreg = uicontrol('style','pushbutton','parent',h_fig2,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz,'position',...
    [x,y,wpan0,hbut0],'string',str8,'tooltipstring',ttstr7,'callback',...
    {@pushbutton_linreg_ESopt_Callback,h_fig,h_fig2});

y = y-mg-hpan0;

q.uipanel_results = uipanel('parent',h_fig2,'units',posun,'fontunits',...
    fntun,'fontsize',fntsz,'title',ttl1,'position',[x,y,wpan0,hpan0]);
h_pan = q.uipanel_results;

x = mg;
y = hpan0-mgpan-mg-hedit0+(hedit0-htxt0)/2;

q.text_gamma = uicontrol('style','text','parent',h_pan,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wtxt1,htxt0],...
    'string',str9,'horizontalalignment','left');

x = x+wtxt1;
y = y-(hedit0-htxt0)/2;

q.edit_gamma = uicontrol('style','edit','parent',h_pan,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr8,'callback',{@edit_gamma_ESopt_Callback,h_fig2});

x = mg;
y = y-mg/2-hedit0+(hedit0-htxt0)/2;

q.text_beta = uicontrol('style','text','parent',h_pan,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wtxt1,htxt0],...
    'string',str10,'horizontalalignment','left');

x = x+wtxt1;
y = y-(hedit0-htxt0)/2;

q.edit_beta = uicontrol('style','edit','parent',h_pan,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr9,'callback',{@edit_beta_ESopt_Callback,h_fig2});

x = mg;
y = y-mg-hedit0;

q.checkbox_show = uicontrol('style','checkbox','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wcb0,hedit0],...
    'string',str11,'tooltipstring',ttstr10,'callback',...
    {@checkbox_show_ESopt_Callback,h_fig,h_fig2});

y = mg;

q.pushbutton_save = uicontrol('style','pushbutton','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wcb0,hbut0],...
    'string',str12,'tooltipstring',ttstr11,'callback',...
    {@pushbutton_save_ESopt_Callback,h_fig,h_fig2});

x = mg+wpan0+mg;
y = mg;

q.axes_ES = axes('parent',h_fig2,'units',posun,'fontunits',fntun,...
    'fontsize',fntsz,'activepositionproperty','outerposition','xlim',limx0,...
    'ylim',limy0,'nextplot','replacechildren');
h_axes = q.axes_ES;
xlabel(h_axes,xlbl0);
ylabel(h_axes,ylbl0);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
% posaxes(4) = (posaxes(4)-2*p.mg/fact)/3;
set(h_axes,'position',posaxes);

% allow figure rescaling
setProp(h_fig2,'units','normalized');

% save gui
guidata(h_fig,h);
guidata(h_fig2,q);


