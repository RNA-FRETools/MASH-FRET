function buildFitSettingsWin(h_fig)
% buildFitSettingsWin(h_fig)
%
% Open settings for exponential fit parameters in panel "State lifetimes"
%
% h_fig: handle to main figure

% get interface parameters
h = guidata(h_fig);
if isfield(h,'figure_TA_fitSettings') && ishandle(h.figure_TA_fitSettings)
    figure(get(h.figure_TA_fitSettings,'number'));
    return
end

% defaults
posun = 'pixels'; % position and dimension units
fntun = 'points'; % font units
fntsz1 = 8; % common font size
mg = 10; % common margin
mgpan = 20; % top margin inside a panel (includes title)
wbox = 15; % box width in checkboxes
warr = 20; % width of downwards arrow in popupmenu
hedit0 = 20;
hcb0 = 20;
htxt0 = 14;
hpop0 = 22;
wedit1 = 40;
fact = 5;
mgprm = 1;
figttl = 'Fit settings';
str0 = 'stretched';
str1 = 'BOBA';
str2 = 'replic.';
str3 = 'sam';
str4 = 'nb. of decays:';
str5 = 'weight';
str6 = 'dec.(s):';
str20 = 'state value';
str21 = {'Select a state value'};
str8 = 'auto.';
str9 = 'manual';
str10 = 'exponential n°:99';
str11 = {'Select an exponential'};
str12 = 'lower';
str13 = 'start';
str14 = 'upper';
str15 = 'fit';
str16 = 'sigma';
str17 = 'am:';
str18 = 'dec.(s):';
str19 = 'beta:';
ttl1 = 'Fitting parameters';
ttstr0 = wrapHtmlTooltipString('<b>Fitting function:</b> when activated, a <b>stretched exponential decay</b> function, amp*exp[-(t/dec)^beta], is fitted to the dwell time histogram.');
ttstr1 = wrapHtmlTooltipString('<b>Molecule bootstrapping:</b> when activated, sample histograms are created from molecules randomly selected in the project (replicates) and are fitted with an exponential function; the resulting bootstrap mean and standard deviation of fit parameters are used to estimate the cross-sample variability of exponential decays and thus, of state transition rates.');
ttstr2 = wrapHtmlTooltipString('<b>Fitting function:</b> when activated, a <b>sum of exponential decay</b> functions, amp*exp(-t/dec), is fitted to the dwell time histogram.');
ttstr3 = wrapHtmlTooltipString('<b>Number of expoenntial functions</b> to sum up in the fitting model.');
ttstr4 = wrapHtmlTooltipString('<b>Replicate weighing:</b> when activated, replicates are being given a weight proportional to the length of their time traces; this prevents the over-representation of short trajectories in bootstrap samples.');
ttstr5 = wrapHtmlTooltipString('<b>Number of bootstrap replicates:</b> number of molecules randomly selected in the project, used to create one sample histogram.');
ttstr6 = wrapHtmlTooltipString('<b>Number of bootstrap samples:</b> number of sample histograms to create in order to estimate cross-sample variability.');
ttstr20 = wrapHtmlTooltipString('Select a <b>state value</b>');
ttstr8 = wrapHtmlTooltipString('Perform <b>model selection</b> automatically.');
ttstr9 = wrapHtmlTooltipString('<b>Set manually</b> the fitting parameters.');
ttstr10 = wrapHtmlTooltipString('Select an <b>exponential component</b> to adjust fitting parameters or show best fit parameters and bootstrapping results.');
ttstr11 = wrapHtmlTooltipString('Exponential''s <b>lowest amplitude</b> allowed in fit.');
ttstr12 = wrapHtmlTooltipString('<b>Starting guess</b> for exponential''s <b>amplitude</b>');
ttstr13 = wrapHtmlTooltipString('Exponential''s <b>highest amplitude</b> allowed in fit.');
ttstr14 = wrapHtmlTooltipString('Exponential''s <b>lowest decay constant</b> allowed in fit.');
ttstr15 = wrapHtmlTooltipString('<b>Starting guess</b> for exponential''s <b>decay constant</b>');
ttstr16 = wrapHtmlTooltipString('Exponential''s <b>highest decay constant</b> allowed in fit.');
ttstr17 = wrapHtmlTooltipString('Exponential''s <b>lowest stretching exponent</b> allowed in fit.');
ttstr18 = wrapHtmlTooltipString('<b>Starting guess</b> for exponential''s <b>stretching exponent</b>');
ttstr19 = wrapHtmlTooltipString('Exponential''s <b>highest stretching exponent</b> allowed in fit.');

tbl = h.charDimTable; % table listing character pixel dimensions

% create figure
h.figure_TA_fitSettings = figure('units',posun,'name',figttl,'numbertitle',...
    'off','menubar','none','visible','off');
h_fig2 = h.figure_TA_fitSettings;

% dimensions
posfig = get(h_fig2,'position');
wcb0 = getUItextWidth(str5,fntun,fntsz1,'normal',tbl)+wbox;
wrb0 = getUItextWidth(str4,fntun,fntsz1,'normal',tbl)+wbox;
wtxt0 = getUItextWidth(str6,fntun,fntsz1,'normal',tbl);
wtxt2 = getUItextWidth(str20,fntun,fntsz1,'normal',tbl);
hpan1 = mgpan+mg+mg/2+2*mgprm+hpop0+htxt0+3*hedit0;
wpan1 = 2*mg+3*mgprm+mg/2+wtxt0+5*wedit1;
wedit0 = (wpan1-wrb0-mg/2-wcb0-mg/fact)/3;
wcb1 = getUItextWidth(str8,fntun,fntsz1,'normal',tbl)+wbox;
wcb2 = getUItextWidth(str9,fntun,fntsz1,'normal',tbl)+wbox;
hfig = mg+htxt0+hpop0+mg+hedit0+mg/fact+hedit0+mg/2+hpan1+mg;
wfig = mg+wpan1+mg;
wpop0 = getUItextWidth(str10,fntun,fntsz1,'normal',tbl)+warr;
wtxt1 = getUItextWidth(str18,fntun,fntsz1,'normal',tbl);

% set figure dimensions
set(h_fig2,'position',[posfig(1:2),wfig,hfig]);

x = mg;
y = hfig-mg-htxt0;

q.text_TA_slState = uicontrol('style','text','parent',h_fig2,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wtxt2,htxt0],'string',str20);

y = y-hpop0;

q.popupmenu_TA_slStates = uicontrol('style','popupmenu','parent',h_fig2,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wtxt2,hpop0],'string',str21,'tooltipstring',ttstr20,'callback',...
    {@popupmenu_TA_slStates_Callback,h_fig});

x = x+wtxt2+mg;
y = y+(hpop0-hcb0)/2;

q.radiobutton_TA_slAuto = uicontrol('style','radiobutton','parent',h_fig2,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wcb1,hcb0],'string',str8,'tooltipstring',ttstr8,'callback',...
    {@radiotbutton_TA_slAuto_Callback,h_fig});

x = x+wcb1;

q.radiobutton_TA_slMan = uicontrol('style','radiobutton','parent',h_fig2,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wcb2,hcb0],'string',str9,'tooltipstring',ttstr9,'callback',...
    {@radiotbutton_TA_slMan_Callback,h_fig});

x = mg;
y = y-(hpop0-hcb0)/2-mg-hedit0;

q.radiobutton_TDPstretch = uicontrol('style','radiobutton','parent',h_fig2,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wrb0,hedit0],'string',str0,'tooltipstring',ttstr0,'callback',...
    {@radiobutton_TDPstretch_Callback,h_fig});

x = x+wrb0+wedit0+mg/2;

q.checkbox_BOBA = uicontrol('style','checkbox','parent',h_fig2,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str1,'tooltipstring',ttstr1,'callback',...
    {@checkbox_BOBA_Callback,h_fig});

x = x+wcb0;
y = y+(hedit0-htxt0)/2;

q.text_bs_nRep = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str2);

x = x+wedit0+mg/fact;

q.text_bs_nSamp = uicontrol('style','text','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str3);

x = mg;
y = y-mg/fact-hedit0;

q.radiobutton_TDPmultExp = uicontrol('style','radiobutton','parent',h_fig2,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wrb0,hedit0],'string',str4,'tooltipstring',ttstr2,'callback',...
    {@radiobutton_TDPmultExp_Callback,h_fig});

x = x+wrb0;

q.edit_TDP_nExp = uicontrol('style','edit','parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr3,'callback',{@edit_TDP_nExp_Callback,h_fig});

x = x+wedit0+mg/2;

q.checkbox_bobaWeight = uicontrol('style','checkbox','parent',h_fig2,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str5,'tooltipstring',ttstr4,'callback',...
    {@checkbox_bobaWeight_Callback,h_fig});

x = x+wcb0;

q.edit_TDPbsprm_01 = uicontrol('style','edit','parent',h_fig2,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr5,'callback',...
    {@edit_TDPbsprm_01_Callback,h_fig});

x = x+wedit0+mg/fact;

q.edit_TDPbsprm_02 = uicontrol('style','edit','parent',h_fig2,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr6,'callback',...
    {@edit_TDPbsprm_02_Callback,h_fig});

x = mg;
y = mg;

q.uipanel_TA_fittingParameters = uipanel('parent',h_fig2,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz1,'position',[x,y,wpan1,hpan1],...
    'title',ttl1);
h_pan = q.uipanel_TA_fittingParameters;
pospan = get(h_pan,'position');
wedit2 = (pospan(3)-2*mg-mg/2-3*mgprm-wtxt1)/5;

% Build panel "Fitting parameters"
x = mg;
y = pospan(4)-mgpan-hpop0;

q.popupmenu_TDP_expNum = uicontrol('style','popupmenu','parent',h_pan,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str11,'tooltipstring',ttstr10,'callback',...
    {@popupmenu_TDP_expNum_Callback,h_fig});

x = mg+wtxt1;
y = y-mg/2-htxt0;

q.text_TDPfit_lower = uicontrol('style','text','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,htxt0],'string',str12);

x = x+wedit2+mgprm;

q.text_TDPfit_start = uicontrol('style','text','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,htxt0],'string',str13);

x = x+wedit2+mgprm;

q.text_TDPfit_upper = uicontrol('style','text','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,htxt0],'string',str14);

x = x+wedit2+mg/2;

q.text_TDPfit_res = uicontrol('style','text','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'fontweight','bold',...
    'position',[x,y,wedit2,htxt0],'string',str15);

x = x+wedit2+mgprm;

q.text_TDPfit_bsRes = uicontrol('style','text','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'fontweight','bold',...
    'position',[x,y,wedit2,htxt0],'string',str16);

x = mg;
y = y-hedit0+(hedit0-htxt0)/2;

q.text_TDPfit_amp = uicontrol('style','text','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wtxt1,htxt0],'string',str17,'horizontalalignment','right');

x = x+wtxt1;
y = y-(hedit0-htxt0)/2;

q.edit_TDPfit_aLow = uicontrol('style','edit','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,hedit0],'tooltipstring',ttstr11,'callback',...
    {@edit_TDPfit_aLow_Callback,h_fig});

x = x+wedit2+mgprm;

q.edit_TDPfit_aStart = uicontrol('style','edit','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,hedit0],'tooltipstring',ttstr12,'callback',...
    {@edit_TDPfit_aStart_Callback,h_fig});

x = x+wedit2+mgprm;

q.edit_TDPfit_aUp = uicontrol('style','edit','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,hedit0],'tooltipstring',ttstr13,'callback',...
    {@edit_TDPfit_aUp_Callback,h_fig});

x = x+wedit2+mg/2;

q.edit_TDPfit_aRes = uicontrol('style','edit','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,hedit0],'enable','inactive');

x = x+wedit2+mgprm;

q.edit_TDPfit_ampBs = uicontrol('style','edit','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,hedit0],'enable','inactive');

x = mg;
y = y-mgprm-hedit0+(hedit0-htxt0)/2;

q.text_TDPdec_amp = uicontrol('style','text','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wtxt1,htxt0],'string',str18,'horizontalalignment','right');

x = x+wtxt1;
y = y-(hedit0-htxt0)/2;

q.edit_TDPfit_decLow = uicontrol('style','edit','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,hedit0],'tooltipstring',ttstr14,'callback',...
    {@edit_TDPfit_decLow_Callback,h_fig});

x = x+wedit2+mgprm;

q.edit_TDPfit_decStart = uicontrol('style','edit','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,hedit0],'tooltipstring',ttstr15,'callback',...
    {@edit_TDPfit_decStart_Callback,h_fig});

x = x+wedit2+mgprm;

q.edit_TDPfit_decUp = uicontrol('style','edit','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,hedit0],'tooltipstring',ttstr16,'callback',...
    {@edit_TDPfit_decUp_Callback,h_fig});

x = x+wedit2+mg/2;

q.edit_TDPfit_decRes = uicontrol('style','edit','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,hedit0],'enable','inactive');

x = x+wedit2+mgprm;

q.edit_TDPfit_decBs = uicontrol('style','edit','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,hedit0],'enable','inactive');

x = mg;
y = y-mgprm-hedit0+(hedit0-htxt0)/2;

q.text_TDPfit_beta = uicontrol('style','text','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wtxt1,htxt0],'string',str19,'horizontalalignment','right');

x = x+wtxt1;
y = y-(hedit0-htxt0)/2;

q.edit_TDPfit_betaLow = uicontrol('style','edit','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,hedit0],'tooltipstring',ttstr17,'callback',...
    {@edit_TDPfit_betaLow_Callback,h_fig});

x = x+wedit2+mgprm;

q.edit_TDPfit_betaStart = uicontrol('style','edit','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,hedit0],'tooltipstring',ttstr18,'callback',...
    {@edit_TDPfit_betaStart_Callback,h_fig});

x = x+wedit2+mgprm;

q.edit_TDPfit_betaUp = uicontrol('style','edit','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,hedit0],'tooltipstring',ttstr19,'callback',...
    {@edit_TDPfit_betaUp_Callback,h_fig});

x = x+wedit2+mg/2;

q.edit_TDPfit_betaRes = uicontrol('style','edit','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,hedit0],'enable','inactive');

x = x+wedit2+mgprm;

q.edit_TDPfit_betaBs = uicontrol('style','edit','parent',h_pan,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wedit2,hedit0],'enable','inactive');

set(h_fig2,'visible','on');

guidata(h_fig2,q);
guidata(h_fig,h);

ud_fitSettings(h_fig);

