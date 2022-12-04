function h = buildPanelSimMolecules(h,p)
% h = buildPanelSimMolecules(h,p);
%
% Builds "Molecules" panel in "Simulation" module including panels "Thermodynamic model" and "Photophysics"
% 
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_S_molecules: handle to panel "Molecules"
% p: structure containing default and often-used parameters (dimensions, margin etc.) with fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.fntclr1: text color in file/folder fields
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
htxt0 = 14;
hedit0 = 20;
hpop0 = 22;
wedit0 = 40;
fact = 5;
str0 = 'N = ';
str1 = 'random coordinates';
str2 = 'import coordinates:';
str3 = '...';
str5 = 'import presets:';
ttl0 = 'Thermodynamic model';
ttl1 = 'Photophysics';
ttstr0 = wrapHtmlTooltipString('<b>Sample size:</b> number of single molecules');
ttstr1 = wrapHtmlTooltipString('<b>Generate random coordinates:</b> molecule positions are randomly determined with sub-pixel resolution and within the video dimensions.');
ttstr2 = wrapHtmlTooltipString('<b>Import coordinates from file:</b> coordinates in the donor channel (x1,y1) are imported from columns (1,2) and in acceptor channel (x2,y2) from columns (3,4)');
ttstr3 = wrapHtmlTooltipString('<b>Import presets from file:</b> preset parameters include coordinates, FRET values and deviations, transition rates, total intensities and deviations, gamma factors and deviations, PSF widths. See MASH-FRET\tools\createSimPrm.m for help.');
ttstr4 = wrapHtmlTooltipString('Open file browser');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_S_molecules;

% dimensions
pospan = get(h_pan,'position');
wrb0 = max([getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox,...
    getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox]);
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wbut0 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpan0 = pospan(3)-2*p.mg;
hpan0 = p.mgpan+htxt0+hpop0+p.mg/2+htxt0+5*(1+hedit0)+htxt0+p.mg/2;
hpan1 = p.mgpan+htxt0+hedit0+p.mg/fact+hedit0+p.mg/2+htxt0+hedit0+p.mg/2+...
    hedit0+p.mg/2;
wedit1 = pospan(3)-p.mg-wrb0-p.mg/fact-wbut0-p.mg;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hedit0;

h.radiobutton_randCoord = uicontrol('style','radiobutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',...
    str1,'position',[x,y,wrb0,hedit0],'tooltipstring',ttstr1,'callback',...
    {@radiobutton_simCoord_Callback,h_fig});

x = x+wrb0;
y = y+(hedit0-htxt0)/2;

h.text_simNbMol = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str0,'position',...
    [x,y,wtxt0,htxt0]);

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_nbMol = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_nbMol_Callback,h_fig},'tooltipstring',ttstr0);

x = p.mg;
y = y-hedit0-p.mg/fact;

h.radiobutton_simCoordFile = uicontrol('style','radiobutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',...
    str2,'position',[x,y,wrb0,hedit0],'tooltipstring',ttstr2,'callback',...
    {@radiobutton_simCoord_Callback,h_fig});

x = x+wrb0;

h.edit_simCoordFile = uicontrol('style','edit','units',p.posun,'parent',...
    h_pan,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'foregroundcolor',p.fntclr1,'callback',...
    {@edit_simCoordFile_Callback,h_fig});

x = x+wedit1+p.mg/fact;

h.pushbutton_simImpCoord = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str3,'tooltipstring',ttstr4,'callback',...
    {@pushbutton_simImpCoord_Callback,h_fig});

x = h.radiobutton_randCoord.Position(1);
y = y-p.mg-hedit0;

h.checkbox_simPrmFile = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str5,...
    'position',[x,y,wrb0,hedit0],'tooltipstring',ttstr3,'callback',...
    {@checkbox_simPrmFile_Callback,h_fig});

x = x+wrb0;

h.edit_simPrmFile = uicontrol('style','edit','units',p.posun,'parent',...
    h_pan,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'foregroundcolor',p.fntclr1,'callback',...
    {@edit_simPrmFile_Callback,h_fig});

x = x+wedit1+p.mg/fact;

h.pushbutton_simImpPrm = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str3,'tooltipstring',ttstr4,'callback',...
    {@pushbutton_simImpPrm_Callback,h_fig});

x = p.mg;
y = y-p.mg/2-hpan0;

h.uipanel_S_thermodynamicModel = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'title',ttl0,'position',...
    [x,y,wpan0,hpan0]);
h = buildPanelSimThermodynamicModel(h,p);

y = y-p.mg/2-hpan1;

h.uipanel_S_photophysics = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'title',ttl1,'position',...
    [x,y,wpan0,hpan1]);
h = buildPanelSimPhotophysics(h,p);
