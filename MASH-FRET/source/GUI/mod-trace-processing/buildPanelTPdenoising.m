function h = buildPanelTPdenoising(h,p)
% h = buildPanelTPdenoising(h,p);
%
% Builds "Denoising" panel in "Trace processing" module
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TP_denoising: handle to panel "Denoising"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.fntclr2: text color in special pushbuttons
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hedit0 = 20;
hpop0 = 22;
wedit0 = 40;
fact = 5;
str0 = {'Sliding average','NL filter (Haran)','Wavelet (Taylor)'};
str1 = 'Apply';
str2 = 'all';
ttstr0 = wrapHtmlTooltipString('Select a <b>denoising method</b>.');
ttstr1 = wrapHtmlTooltipString('<b>Denoise traces</b>: only intensity-time trace are processed; ratio-time traces are calculated from denoised intensities.');
ttstr2 = wrapHtmlTooltipString('Apply current denoising settings to all molecules.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP_denoising;

% dimensions
pospan = get(h_pan,'position');
wpop0 = pospan(3)-p.mg*2-3*p.mg/fact-3*wedit0;
wcb0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wbut0 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hpop0;

h.popupmenu_denoising = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str0,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_denoising_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_denoiseParam_01 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_denoiseParam_01_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_denoiseParam_02 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_denoiseParam_02_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_denoiseParam_03 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_denoiseParam_03_Callback,h_fig});

x = x-p.mg/fact-wedit0;
y = y-(hpop0-hedit0)/2-p.mg/fact-hpop0;

h.checkbox_smoothIt = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str1,'tooltipstring',ttstr1,'callback',...
    {@checkbox_smoothIt_Callback,h_fig});

x = pospan(3)-p.mg-wbut0;

h.pushbutton_applyAll_den = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut0,hedit0],'string',str2,'callback',...
    {@pushbutton_applyAll_den_Callback,h_fig},'tooltipstring',ttstr2,...
    'foregroundcolor',p.fntclr2);


