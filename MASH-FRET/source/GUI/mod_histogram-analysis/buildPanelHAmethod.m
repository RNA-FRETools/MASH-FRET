function h = buildPanelHAmethod(h,p)
% h = buildPanelHAmethod(h,p)
%
% Builds "Method" panel in module "Histogram analysis"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_HA_method: handle to panel "Method"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbox: box's pixel width in checkboxes
%   p.wttsr: pixel width of tooltip box
%   p.tbl: reference table listing character pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% Created by MH, 6.11.2019

% default
hedit0 = 20;
htxt0 = 14;
fact = 5;
str0 = 'Gaussian fitting';
str1 = 'thresholding';
str2 = 'BOBA FRET';
str3 = 'replicates:';
str4 = 'samples:';
str5 = 'weighting';
ttstr0 = wrapStrToWidth('Peak integration by <b>Gaussian fitting:</b> the histogram is fitted with a mixture of Gaussian functions; individual Gaussian integrals are normalized by the sum of all Gaussian integrals to obtain the state relative poopulations.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('Peak integration by <b>thresholding:</b> histogram peaks are separated by fixed thresholds and histogram counts are summed up between thresholds; resulting integrals are normalized by the sum of all integrals to obtain relative state populations.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('<b>Molecule bootstrapping:</b> when activated, sample histograms are created from molecules randomly selected in the project (replicates) and peaks are integrated; the resulting bootstrap mean and standard deviation are used to estimate the cross-sample variability of state populations.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('<b>Number of bootstrap replicates:</b> number of molecules randomly selected in the project, used to create one sample histogram.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('<b>Number of bootstrap samples:</b> number of sample histograms to create in order to estimate cross-sample variability.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr5 = wrapStrToWidth('<b>Replicate weighing:</b> when activated, replicates are being given a weight proportional to the length of their time traces; this prevents the over-representation of short trajectories in bootstrap samples.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_HA_method;

% dimensions
pospan = get(h_pan,'position');
wrb0 = pospan(3)-2*p.mg;
wtxt0 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl);
wedit0 = pospan(3)-2*p.mg-wtxt0;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hedit0;

h.radiobutton_thm_gaussFit = uicontrol('style','radiobutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wrb0,hedit0],'string',str0,'tooltipstring',ttstr0,...
    'callback',{@radiobutton_thm_gaussFit_Callback,h_fig});

y = y-p.mg/fact-hedit0;

h.radiobutton_thm_thresh = uicontrol('style','radiobutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wrb0,hedit0],'string',str1,'tooltipstring',ttstr1,...
    'callback',{@radiobutton_thm_thresh_Callback,h_fig});

y = y-p.mg/2-hedit0;

h.checkbox_thm_BS = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wrb0,hedit0],'string',str2,'tooltipstring',ttstr2,'callback',...
    {@checkbox_thm_BS_Callback,h_fig});

y = y-p.mg/fact-hedit0+(hedit0-htxt0)/2;

h.text_thm_nRep = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str3,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_thm_nRep = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr3,'callback',{@edit_thm_nRep_Callback,h_fig});

x = p.mg;
y = y-p.mg/fact-hedit0+(hedit0-htxt0)/2;

h.text_thm_nSpl = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str4,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_thm_nSpl = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr4,'callback',{@edit_thm_nSpl_Callback,h_fig});

x = p.mg;
y = p.mg;

h.checkbox_thm_weight = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wrb0,hedit0],'string',str5,'tooltipstring',ttstr5,'callback',...
    {@checkbox_thm_weight_Callback,h_fig});




