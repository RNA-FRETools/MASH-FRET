function ESlinRegOpt(h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
if isempty(p.proj)
    return
end

open_ESlinRegOpt(h_fig);


function open_ESlinRegOpt(h_fig)

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
str0 = 'data:';
str1 = {'Select data'};
str2 = 'subgroup:';
str3 = {'Select subgroup'};
str4 = 'Emin';
str5 = 'nbin';
str6 = 'Emax';
str7 = '1/Smin';
str8 = 'nbin';
str9 = '1/Smax';
str10 = 'refresh calculations';
str11 = cat(2,char(947),' =');
str12 = cat(2,char(946),' =');
str13 = 'show corrected ES';
str14 = 'Save and close';
ttl0 = 'Factor calculation via linear regression';
ttl1 = 'Results';

% collect figure parameters
h = guidata(h_fig);
hndls = [h.figure_dummy,h.text_dummy];
tbl = h.charDimTable;

% tooltip strings
ttstr0 = wrapStrToWidth('<b>Select the FRET pair</b> to analyze.',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr1 = wrapStrToWidth('<b>Select subgroup</b> used for building ES histogram.',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr2 = wrapStrToWidth('<b>E boundaries:</b> lower limit of E-axis',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr3 = wrapStrToWidth('<b>E intervals:</b> number of intervals in E-axis',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr4 = wrapStrToWidth('<b>E boundaries:</b> upper limit of E-axis',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr5 = wrapStrToWidth('<b>1/S boundaries:</b> lower limit of (1/S)-axis',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr6 = wrapStrToWidth('<b>1/S intervals:</b> number of intervals in (1/S)-axis',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr7 = wrapStrToWidth('<b>1/S boundaries:</b> upper limit of (1/S)-axis',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr8 = wrapStrToWidth('<b>Start linear regression</b>: E-S data points will be analyzed to determine global coefficients gamma and beta.',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr9 = wrapStrToWidth('<b>Gamma factor</b> calculated from the linear regression.',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr10 = wrapStrToWidth('<b>Beta factor</b> calculated from the linear regression.',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr11 = wrapStrToWidth('Show ES histogram after <b>gamma- and beta-correction</b>.',fntun,fntsz,'normal',wttstr,'html',hndls);
ttstr12 = wrapStrToWidth('<b>Export to MASH</b> the calculated gamma and beta-factors.',fntun,fntsz,'normal',wttstr,'html',hndls);

% get dimensions
posfig = getPixPos(h_fig);
wtxt0 = getUItextWidth(str2,fntun,fntsz,'normal',tbl);
wtxt1 = getUItextWidth(str11,fntun,fntsz,'normal',tbl);
wcb0 = getUItextWidth(str13,fntun,fntsz,'normal',tbl) + wbox;
wpan0 = mg+wcb0+mg;
wpop0 = wpan0-wtxt0;
wedit0 = (wpan0-2*mg/fact)/3;
hpan0 = mgpan+mg+hedit0+mg/2+hedit0+mg+hedit0+mg+hbut0+mg;
hfig = mg+hpop0+mg/2+hpop0+mg+htxt0+hedit0+mg/2+htxt0+hedit0+mg+hbut0+mg+...
    hpan0+mg;
waxes0 = hfig-mg-mg;
haxes0 = hfig-mg-mg;
wfig = mg+wpan0+mg+waxes0+mg;

h.ESopt = [];
q = h.ESopt;

x = posfig(1)+(posfig(3)-wfig)/2;
y = posfig(2)+(posfig(4)-hfig)/2;

g.figure_ESlinRegOpt = figure('units',posun,'numbertitle','off','menubar',...
    'none','position',[x,y,wfig,hfig],'visible','on','name',ttl0);
h_fig2 = g.figure_ESlinRegOpt;

x = mg;
y = hfig-mg-hpop0+(hpop0-htxt0)/2;

q.text_data = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wtxt0,htxt0],...
    'string',str0,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hpop0-htxt0)/2;

q.popupmenu_data = uicontrol('style','popupmenu','parent',h_fig2,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wpop0,hpop0],...
    'string',str1,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_data_ESopt_Callback,h_fig});

x = mg;
y = y-mg/2-hpop0+(hpop0-htxt0)/2;

q.text_tag = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wtxt0,htxt0],...
    'string',str2,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hpop0-htxt0)/2;

q.popupmenu_tag = uicontrol('style','popupmenu','parent',h_fig2,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wpop0,hpop0],...
    'string',str3,'tooltipstring',ttstr1,'callback',...
    {@popupmenu_tag_ESopt_Callback,h_fig});

x = mg;
y = y-mg-htxt0;

q.text_Emin = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str4,'horizontalalignment','center');

x = x+wedit0+mg/fact;

q.text_Ebin = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str5,'horizontalalignment','center');

x = x+wedit0+mg/fact;

q.text_Emax = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str6,'horizontalalignment','center');

x = mg;
y = y-hedit0;

q.edit_Emin = uicontrol('style','edit','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr2,'callback',{@edit_Emin_ESopt_Callback,h_fig});

x = x+wedit0+mg/fact;

q.edit_Ebin = uicontrol('style','edit','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr3,'callback',{@edit_Ebin_ESopt_Callback,h_fig});

x = x+wedit0+mg/fact;

q.edit_Emax = uicontrol('style','edit','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr4,'callback',{@edit_Emax_ESopt_Callback,h_fig});

x = mg;
y = y-mg/2-htxt0;

q.text_Smin = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str7,'horizontalalignment','center');

x = x+wedit0+mg/fact;

q.text_Sbin = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str8,'horizontalalignment','center');

x = x+wedit0+mg/fact;

q.text_Smax = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str9,'horizontalalignment','center');

x = mg;
y = y-hedit0;

q.edit_Smin = uicontrol('style','edit','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr5,'callback',{@edit_Smin_ESopt_Callback,h_fig});

x = x+wedit0+mg/fact;

q.edit_Sbin = uicontrol('style','edit','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr6,'callback',{@edit_Sbin_ESopt_Callback,h_fig});

x = x+wedit0+mg/fact;

q.edit_Smax = uicontrol('style','edit','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr7,'callback',{@edit_Smax_ESopt_Callback,h_fig});

x = mg;
y = y-mg-hbut0;

q.pushbutton_linreg = uicontrol('style','pushbutton','parent',h_fig2,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz,'position',...
    [x,y,wpan0,hbut0],'string',str10,'tooltipstring',ttstr8,'callback',...
    {@pushbutton_linreg_ESopt_Callback,h_fig});

y = y-mg-hpan0;

q.uipanel_results = uipanel('parent',h_fig2,'units',posun,'fontunits',...
    fntun,'fontsize',fntsz,'title',ttl1,'position',[x,y,wpan0,hpan0]);
h_pan = q.uipanel_results;

x = mg;
y = hpan0-mgpan-mg-hedit0+(hedit0-htxt0)/2;

q.text_gamma = uicontrol('style','text','parent',h_pan,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wtxt1,htxt0],...
    'string',str11,'horizontalalignment','left');

x = x+wtxt1;
y = y-(hedit0-htxt0)/2;

q.edit_gamma = uicontrol('style','edit','parent',h_pan,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr9,'callback',{@edit_gamma_ESopt_Callback,h_fig});

x = mg;
y = y-mg/2-hedit0+(hedit0-htxt0)/2;

q.text_beta = uicontrol('style','text','parent',h_pan,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wtxt1,htxt0],...
    'string',str12,'horizontalalignment','left');

x = x+wtxt1;
y = y-(hedit0-htxt0)/2;

q.edit_beta = uicontrol('style','edit','parent',h_pan,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr10,'callback',{@edit_beta_ESopt_Callback,h_fig});

x = mg;
y = y-mg-hedit0;

q.checkbox_show = uicontrol('style','checkbox','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wcb0,hedit0],...
    'string',str13,'tooltipstring',ttstr11,'callback',...
    {@checkbox_show_ESopt_Callback,h_fig});

y = mg;

q.pushbutton_save = uicontrol('style','pushbutton','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wcb0,hbut0],...
    'string',str14,'tooltipstring',ttstr12,'callback',...
    {@pushbutton_save_ESopt_Callback,h_fig});

x = mg+wpan0+mg;
y = mg;

g.axes_ES = axes('parent',h_fig2,'units',posun,'fontunits',fntun,...
    'fontsize',fntsz,'activepositionproperty','outerposition','xlim',limx0,...
    'ylim',limy0);
h_axes = g.axes_ES;
xlabel(h_axes,xlbl0);
ylabel(h_axes,ylbl0);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
% posaxes(4) = (posaxes(4)-2*p.mg/fact)/3;
set(h_axes,'position',posaxes);

% allow figure rescaling
setProp(h_fig2,'units','normalized');

% save gui
h.ESopt = q;
guidata(h_fig,h);

ud_ESlinRegOpt(h_fig)


function ud_ESlinRegOpt(h_fig)

h = guidata(h_fig);
g = h.ESopt;
p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);
prm = p.proj{proj}.curr{mol}{6}{4};

str_dat = getStrPop('corr_gamma', {p.proj{proj}.FRET,p.proj{proj}.labels,...
    p.proj{proj}.colours});
str_dat = str_dat(2:end);
str_tag = getStrPopTags(p.proj{proj}.molTagNames,p.proj{proj}.molTagClr);
nTag = size(str_tag,2);
if nTag>1
    str_tag = cat(2,'All molecules',str_tag);
end
if prm(1)>nTag
    prm(1) = 1;
end

set(g.popupmenu_data,'string',str_dat);
set(g.popupmenu_tag,'string',str_tag,'value',prm(1));

set([g.edit_Emin,g.edit_Ebin,g.edit_Emax,g.edit_Smin,g.edit_Sbin,...
    g.edit_Smax],'backgroundcolor',[1,1,1]);

set(g.edit_Emin,'string',num2str(prm(2)));
set(g.edit_Emax,'string',num2str(prm(3)));
set(g.edit_Ebin,'string',num2str(prm(4)));
set(g.edit_Smin,'string',num2str(prm(5)));
set(g.edit_Smax,'string',num2str(prm(6)));
set(g.edit_Sbin,'string',num2str(prm(7)));

% save potentially adjusted subgroup
p.proj{proj}.curr{mol}{6}{4} = prm;
h.parm.ttPr = p;
guidata(h_fig,h);

% plot ES
plot_ESlinRegOpt(h_fig)


function plot_ESlinRegOpt(h_fig)


function edit_Emax_ESopt_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);

val = str2double(get(obj,'string'));
valmin = p.proj{proj}.curr{mol}{6}{4}(2);
if numel(val)~=1 || val<=valmin
    set(obj,'backgroundcolor',[1,0.5,0.5]);
    setContPan(cat(2,'E-axis upper limit must be > ',num2str(valmin)),...
        'error',h_fig);
    return
end

p.proj{proj}.curr{mol}{6}{4}(3) = val;
h.param.ttPr = p;
guidata(h_fig,h);

ud_ESlinRegOpt(h_fig)


function edit_Ebin_ESopt_Callback(obj,evd,h_fig)

val = str2double(get(obj,'string'));
if numel(val)~=1 || val<=0
    set(obj,'backgroundcolor',[1,0.5,0.5]);
    setContPan('Number of E intervals must be > 0 ','error',h_fig);
    return
end

h = guidata(h_fig);
proj = h.param.ttPr.curr_proj;
mol = h.param.ttPr.curr_mol(proj);
h.param.ttPr.proj{proj}.curr{mol}{6}{4}(4) = val;
guidata(h_fig,h);

ud_ESlinRegOpt(h_fig)


function edit_Emin_ESopt_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);

val = str2double(get(obj,'string'));
valmax = p.proj{proj}.curr{mol}{6}{4}(3);
if numel(val)~=1 || val>=valmax
    set(obj,'backgroundcolor',[1,0.5,0.5]);
    setContPan(cat(2,'E-axis lower limit must be < ',num2str(valmax)),...
        'error',h_fig);
    return
end

p.proj{proj}.curr{mol}{6}{4}(2) = val;
h.param.ttPr = p;
guidata(h_fig,h);

ud_ESlinRegOpt(h_fig)


function edit_Smax_ESopt_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);

val = str2double(get(obj,'string'));
valmin = p.proj{proj}.curr{mol}{6}{4}(5);
if numel(val)~=1 || val<=valmin
    set(obj,'backgroundcolor',[1,0.5,0.5]);
    setContPan(cat(2,'(1/S)-axis upper limit must be > ',num2str(valmin)),...
        'error',h_fig);
    return
end

p.proj{proj}.curr{mol}{6}{4}(6) = val;
h.param.ttPr = p;
guidata(h_fig,h);

ud_ESlinRegOpt(h_fig)


function edit_Sbin_ESopt_Callback(obj,evd,h_fig)

val = str2double(get(obj,'string'));
if numel(val)~=1 || val<=0
    set(obj,'backgroundcolor',[1,0.5,0.5]);
    setContPan('Number of 1/S intervals must be > 0 ','error',h_fig);
    return
end

h = guidata(h_fig);
proj = h.param.ttPr.curr_proj;
mol = h.param.ttPr.curr_mol(proj);
h.param.ttPr.proj{proj}.curr{mol}{6}{4}(7) = val;
guidata(h_fig,h);

ud_ESlinRegOpt(h_fig)


function edit_Smin_ESopt_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);

val = str2double(get(obj,'string'));
valmax = p.proj{proj}.curr{mol}{6}{4}(6);
if numel(val)~=1 || val>=valmax
    set(obj,'backgroundcolor',[1,0.5,0.5]);
    setContPan(cat(2,'E-axis lower limit must be < ',num2str(valmax)),...
        'error',h_fig);
    return
end

p.proj{proj}.curr{mol}{6}{4}(5) = val;
h.param.ttPr = p;
guidata(h_fig,h);

ud_ESlinRegOpt(h_fig)


function pushbutton_save_ESopt_Callback(obj,evd,h_fig)

function checkbox_show_ESopt_Callback(obj,evd,h_fig)

function edit_beta_ESopt_Callback(obj,evd,h_fig)

function edit_gamma_ESopt_Callback(obj,evd,h_fig)

function pushbutton_linreg_ESopt_Callback(obj,evd,h_fig)

function popupmenu_tag_ESopt_Callback(obj,evd,h_fig)

function popupmenu_data_ESopt_Callback(obj,evd,h_fig)




