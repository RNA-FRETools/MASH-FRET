function ESlinRegOpt(h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
if isempty(p.proj)
    return
end

h_fig2 = build_ESlinRegOpt(h_fig);

setDefPrm_ESlinRegOpt(h_fig,h_fig2);

ud_EScalc(h_fig,h_fig2);

ud_ESlinRegOpt(h_fig,h_fig2);


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
str0 = 'data:';
str1 = 'subgroup:';
str2 = {'Select subgroup'};
str3 = 'Emin';
str4 = 'nbin';
str5 = 'Emax';
str6 = '1/Smin';
str7 = 'nbin';
str8 = '1/Smax';
str9 = 'refresh calculations';
str10 = cat(2,char(947),' =');
str11 = cat(2,char(946),' =');
str12 = 'show corrected ES';
str13 = 'Save and close';
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
wtxt0 = getUItextWidth(str1,fntun,fntsz,'normal',tbl);
wtxt1 = getUItextWidth(str10,fntun,fntsz,'normal',tbl);
wcb0 = getUItextWidth(str12,fntun,fntsz,'normal',tbl) + wbox;
wpan0 = mg+wcb0+mg;
wpop0 = wpan0-wtxt0;
wedit0 = (wpan0-2*mg/fact)/3;
hpan0 = mgpan+mg+hedit0+mg/2+hedit0+mg+hedit0+mg+hbut0+mg;
hfig = mg+hpop0+mg/2+hpop0+mg+htxt0+hedit0+mg/2+htxt0+hedit0+mg+hbut0+mg+...
    hpan0+mg;
waxes0 = hfig-mg-mg;
haxes0 = hfig-mg-mg;
wfig = mg+wpan0+mg+waxes0+mg;

str_dat = get(h.popupmenu_gammaFRET,'string');
p = h.param.ttPr;
proj = p.curr_proj;
fret = p.proj{proj}.fix{3}(8);

q = struct();

x = posfig(1)+(posfig(3)-wfig)/2;
y = posfig(2)+(posfig(4)-hfig)/2;

h.figure_ESlinRegOpt = figure('units',posun,'numbertitle','off','menubar',...
    'none','position',[x,y,wfig,hfig],'visible','on','name',ttl0,...
    'closerequestfcn',{@figure_ESlinRegOpt_CloseRequestFcn,h_fig});
h_fig2 = h.figure_ESlinRegOpt;

x = mg;
y = hfig-mg-hpop0+(hpop0-htxt0)/2;

q.text_data = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wtxt0,htxt0],...
    'string',str0,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hpop0-htxt0)/2;

q.popupmenu_data = uicontrol('style','popupmenu','parent',h_fig2,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wpop0,hpop0],...
    'string',str_dat{fret+1},'tooltipstring',ttstr0,'enable','inactive');

x = mg;
y = y-mg/2-hpop0+(hpop0-htxt0)/2;

q.text_tag = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wtxt0,htxt0],...
    'string',str1,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hpop0-htxt0)/2;

q.popupmenu_tag = uicontrol('style','popupmenu','parent',h_fig2,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wpop0,hpop0],...
    'string',str2,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_tag_ESopt_Callback,h_fig,h_fig2});

x = mg;
y = y-mg-htxt0;

q.text_Emin = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str3,'horizontalalignment','center');

x = x+wedit0+mg/fact;

q.text_Ebin = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str4,'horizontalalignment','center');

x = x+wedit0+mg/fact;

q.text_Emax = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str5,'horizontalalignment','center');

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
    'string',str6,'horizontalalignment','center');

x = x+wedit0+mg/fact;

q.text_Sbin = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str7,'horizontalalignment','center');

x = x+wedit0+mg/fact;

q.text_Smax = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,htxt0],...
    'string',str8,'horizontalalignment','center');

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
    [x,y,wpan0,hbut0],'string',str9,'tooltipstring',ttstr7,'callback',...
    {@pushbutton_linreg_ESopt_Callback,h_fig,h_fig2});

y = y-mg-hpan0;

q.uipanel_results = uipanel('parent',h_fig2,'units',posun,'fontunits',...
    fntun,'fontsize',fntsz,'title',ttl1,'position',[x,y,wpan0,hpan0]);
h_pan = q.uipanel_results;

x = mg;
y = hpan0-mgpan-mg-hedit0+(hedit0-htxt0)/2;

q.text_gamma = uicontrol('style','text','parent',h_pan,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wtxt1,htxt0],...
    'string',str10,'horizontalalignment','left');

x = x+wtxt1;
y = y-(hedit0-htxt0)/2;

q.edit_gamma = uicontrol('style','edit','parent',h_pan,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr8,'callback',{@edit_gamma_ESopt_Callback,h_fig2});

x = mg;
y = y-mg/2-hedit0+(hedit0-htxt0)/2;

q.text_beta = uicontrol('style','text','parent',h_pan,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wtxt1,htxt0],...
    'string',str11,'horizontalalignment','left');

x = x+wtxt1;
y = y-(hedit0-htxt0)/2;

q.edit_beta = uicontrol('style','edit','parent',h_pan,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr9,'callback',{@edit_beta_ESopt_Callback,h_fig2});

x = mg;
y = y-mg-hedit0;

q.checkbox_show = uicontrol('style','checkbox','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wcb0,hedit0],...
    'string',str12,'tooltipstring',ttstr10,'callback',...
    {@checkbox_show_ESopt_Callback,h_fig,h_fig2});

y = mg;

q.pushbutton_save = uicontrol('style','pushbutton','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz,'position',[x,y,wcb0,hbut0],...
    'string',str13,'tooltipstring',ttstr11,'callback',...
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


function setDefPrm_ESlinRegOpt(h_fig,h_fig2)

h = guidata(h_fig);
q = guidata(h_fig2);

p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);
curr = p.proj{proj}.curr{mol}{6};

q.prm = cell(1,5);
q.prm{1} = ones(2,1); % gamma and beta factors
q.prm{2} = curr{4}; % processing parameters
q.prm{3} = false; % show corrected ES
q.prm{4} = p.proj{proj}.ES; % ES histograms
q.prm{5} = []; % corrected ES histogram

guidata(h_fig2,q);


function ud_ESlinRegOpt(h_fig,h_fig2)

h = guidata(h_fig);
q = guidata(h_fig2);

p = h.param.ttPr;
proj = p.curr_proj;
nFRET = size(p.proj{proj}.FRET,1);
prm = q.prm{2};
gamma = q.prm{1}(1,1);
beta = q.prm{1}(2,1);

% get current FRET pair
fret = p.proj{proj}.fix{3}(8);

% set subgroup list
str_tag = getStrPopTags(p.proj{proj}.molTagNames,p.proj{proj}.molTagClr);
nTag = size(str_tag,2);
if nTag>1
    str_tag = cat(2,'All molecules',str_tag);
end
if prm(fret,1)>nTag
    prm(fret,1) = 1;
end
set(q.popupmenu_tag,'string',str_tag,'value',prm(fret,1));

% set processing parameters
set([q.edit_Emin,q.edit_Ebin,q.edit_Emax,q.edit_Smin,q.edit_Sbin,...
    q.edit_Smax],'backgroundcolor',[1,1,1]);
set(q.edit_Emin,'string',num2str(prm(fret,2)));
set(q.edit_Emax,'string',num2str(prm(fret,3)));
set(q.edit_Ebin,'string',num2str(prm(fret,4)));
set(q.edit_Smin,'string',num2str(prm(fret,5)));
set(q.edit_Smax,'string',num2str(prm(fret,6)));
set(q.edit_Sbin,'string',num2str(prm(fret,7)));

% set results
set(q.edit_gamma,'string',num2str(gamma));
set(q.edit_beta,'string',num2str(beta));
set(q.checkbox_show,'value',q.prm{3});

% plot ES histogram
if ~q.prm{3}
    plot_ESlinRegOpt(q.axes_ES,q.prm{4}{fret},prm(fret,:),q.prm{1});
else
    if isempty(q.prm{5})
        [ES,ok,str] = getES(p.proj{proj},prm,...
            cat(2,[gamma;beta],ones(2,nFRET-1)),h_fig);
        if ~ok
            setContPan(str,'warning',h_fig);
        end
        q.prm{5} = ES{fret};
    end
    plot_ESlinRegOpt(q.axes_ES,q.prm{5},prm(fret,:),[1;1]);
end

% save changes
q.prm{2} = prm;
guidata(h_fig2,q);


function ud_EScalc(h_fig,h_fig2)
h = guidata(h_fig);
q = guidata(h_fig2);
p = h.param.ttPr;
proj = p.curr_proj;

curr = q.prm{2};
fret = p.proj{proj}.fix{3}(8);
p.proj{proj}.ES = q.prm{4}; % modify temporary ES field in project

[p,ES,gamma,beta,ok,str] = gammaCorr_ES(fret,p,curr,h_fig);

q.prm{4} = ES;
guidata(h_fig2,q);

if ~ok
    setContPan(str,'warning',h_fig);
    return
end

% save results
q.prm{1} = [round(gamma,2);round(beta,2)];
guidata(h_fig2,q);

h.param.ttPr = p;
guidata(h_fig,h);


function plot_ESlinRegOpt(h_axes,ES,prm,fact)

elim = prm(2:3);
slim = prm(5:6);

imagesc(elim,slim,ES,'parent',h_axes);
if sum(sum(isnan(ES))) || ~sum(sum(ES))
    set(h_axes,'clim',[0 1]);
    return
end

set(h_axes,'clim',[min(min(ES)) max(max(ES))],'ydir','normal');

gamma = fact(1);
beta = fact(2);
SIG = beta*(1-gamma);
OME = 1+gamma*beta;

set(h_axes,'nextplot','add');
plot(h_axes,elim,OME+SIG*elim,'--w');
set(h_axes,'nextplot','replacechildren');

xlim(h_axes,elim);
ylim(h_axes,slim);


function pushbutton_linreg_ESopt_Callback(obj,evd,h_fig,h_fig2)

ud_EScalc(h_fig,h_fig2);
ud_ESlinRegOpt(h_fig,h_fig2);


function popupmenu_tag_ESopt_Callback(obj,evd,h_fig,h_fig2)

val = get(obj,'value');
q = guidata(h_fig2);
fret = get(q.popupmenu_data,'value');

if val==q.prm{2}(fret,1)
    return
end

q.prm{2}(fret,1) = val;
q.prm{4} = cell(1,size(q.prm{4},2)); % reset ES
q.prm{5} = []; % reset corrected ES
guidata(h_fig2,q);

ud_ESlinRegOpt(h_fig,h_fig2)


function popupmenu_data_ESopt_Callback(obj,evd,h_fig,h_fig2)
ud_ESlinRegOpt(h_fig,h_fig2);


function edit_Emax_ESopt_Callback(obj,evd,h_fig,h_fig2)

q = guidata(h_fig2);

val = str2double(get(obj,'string'));
fret = get(q.popupmenu_data,'value');
valmin = q.prm{2}(fret,2);
if ~(numel(val)==1 && ~isnan(val) && val>valmin)
    set(obj,'backgroundcolor',[1,0.5,0.5]);
    setContPan(cat(2,'E-axis upper limit must be > ',num2str(valmin)),...
        'error',h_fig);
    return
end
if val==q.prm{2}(fret,3)
    return
end

q.prm{2}(fret,3) = val;
q.prm{4} = cell(1,size(q.prm{4},2)); % reset ES
q.prm{5} = []; % reset corrected ES
guidata(h_fig2,q);

ud_ESlinRegOpt(h_fig,h_fig2)


function edit_Ebin_ESopt_Callback(obj,evd,h_fig,h_fig2)

val = str2double(get(obj,'string'));
if ~(numel(val)==1 && ~isnan(val) && val>0)
    set(obj,'backgroundcolor',[1,0.5,0.5]);
    setContPan('Number of E intervals must be > 0 ','error',h_fig);
    return
end

q = guidata(h_fig2);
fret = get(q.popupmenu_data,'value');

if val==q.prm{2}(fret,4)
    return
end

q.prm{2}(fret,4) = val;
q.prm{4} = cell(1,size(q.prm{4},2)); % reset ES
q.prm{5} = []; % reset corrected ES
guidata(h_fig2,q);

ud_ESlinRegOpt(h_fig,h_fig2)


function edit_Emin_ESopt_Callback(obj,evd,h_fig,h_fig2)

q = guidata(h_fig2);

fret = get(q.popupmenu_data,'value');
val = str2double(get(obj,'string'));
valmax = q.prm{2}(fret,3);
if ~(numel(val)==1 && ~isnan(val) && val<valmax)
    set(obj,'backgroundcolor',[1,0.5,0.5]);
    setContPan(cat(2,'E-axis lower limit must be < ',num2str(valmax)),...
        'error',h_fig);
    return
end
if val==q.prm{2}(fret,2)
    return
end

q.prm{2}(fret,2) = val;
q.prm{4} = cell(1,size(q.prm{4},2)); % reset ES
q.prm{5} = []; % reset corrected ES
guidata(h_fig2,q);

ud_ESlinRegOpt(h_fig,h_fig2)


function edit_Smax_ESopt_Callback(obj,evd,h_fig,h_fig2)

q = guidata(h_fig2);

fret = get(q.popupmenu_data,'value');
val = str2double(get(obj,'string'));
valmin = q.prm{2}(fret,5);
if ~(numel(val)==1 && ~isnan(val) && val>valmin)
    set(obj,'backgroundcolor',[1,0.5,0.5]);
    setContPan(cat(2,'(1/S)-axis upper limit must be > ',num2str(valmin)),...
        'error',h_fig);
    return
end
if val==q.prm{2}(fret,6)
    return
end

q.prm{2}(fret,6) = val;
q.prm{4} = cell(1,size(q.prm{4},2)); % reset ES
q.prm{5} = []; % reset corrected ES
guidata(h_fig2,q);

ud_ESlinRegOpt(h_fig,h_fig2)


function edit_Sbin_ESopt_Callback(obj,evd,h_fig,h_fig2)

val = str2double(get(obj,'string'));
if ~(numel(val)==1 && ~isnan(val) && val>0)
    set(obj,'backgroundcolor',[1,0.5,0.5]);
    setContPan('Number of 1/S intervals must be > 0 ','error',h_fig);
    return
end

q = guidata(h_fig2);
fret = get(q.popupmenu_data,'value');

if val==q.prm{2}(fret,7)
    return
end

q.prm{2}(fret,7) = val;
q.prm{4} = cell(1,size(q.prm{4},2)); % reset ES
q.prm{5} = []; % reset corrected ES
guidata(h_fig2,q);

ud_ESlinRegOpt(h_fig,h_fig2);


function edit_Smin_ESopt_Callback(obj,evd,h_fig,h_fig2)

q = guidata(h_fig2);

fret = get(q.popupmenu_data,'value');
val = str2double(get(obj,'string'));
valmax = q.prm{2}(fret,6);
if ~(numel(val)==1 && ~isnan(val) && val<valmax)
    set(obj,'backgroundcolor',[1,0.5,0.5]);
    setContPan(cat(2,'E-axis lower limit must be < ',num2str(valmax)),...
        'error',h_fig);
    return
end

if val==q.prm{2}(fret,5)
    return
end

q.prm{2}(fret,5) = val;
q.prm{4} = cell(1,size(q.prm{4},2)); % reset ES
q.prm{5} = []; % reset corrected ES
guidata(h_fig2,q);

ud_ESlinRegOpt(h_fig,h_fig2);


function pushbutton_save_ESopt_Callback(obj,evd,h_fig,h_fig2)

h = guidata(h_fig);
q = guidata(h_fig2);

p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);
fret = p.proj{proj}.fix{3}(8);
method = p.proj{proj}.curr{mol}{6}{2}(1);
N = size(p.proj{proj}.prm,2);

% set options and gamma factors to all molecules using the same method
for n = 1:N
    if p.proj{proj}.curr{n}{6}{2}(1)==method
        p.proj{proj}.curr{n}{6}{1}(:,fret) = q.prm{1}; % gamma amd beta factors
        p.proj{proj}.curr{n}{6}{4} = q.prm{2}; % method parameters
    end
end
p.proj{proj}.ES = q.prm{4};

% save results
h.param.ttPr = p;
guidata(h_fig,h);

close(h_fig2);

ud_factors(h_fig);


function checkbox_show_ESopt_Callback(obj,evd,h_fig,h_fig2)

val = get(obj,'value');

q = guidata(h_fig2);
q.prm{3} = val;
guidata(h_fig2,q);

ud_ESlinRegOpt(h_fig,h_fig2)


function edit_beta_ESopt_Callback(obj,evd,h_fig2)

q = guidata(h_fig2);
beta = q.prm{1}(2,1);

set(obj,'string',num2str(beta));


function edit_gamma_ESopt_Callback(obj,evd,h_fig2)

q = guidata(h_fig2);
gamma = q.prm{1}(1,1);

set(obj,'string',num2str(gamma));


function figure_ESlinRegOpt_CloseRequestFcn(obj,evd,h_fig)

h = guidata(h_fig);
h = rmfield(h,'figure_ESlinRegOpt');
guidata(h_fig,h);

delete(obj);




