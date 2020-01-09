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
%   p.wttsr: pixel width of tooltip box
%   p.fntclr1: text color in file/folder fields
%   p.tbl: reference table listing character's pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% created by MH, 19.10.2019

% default
wpan0 = 271;
wpan1 = 101;
htxt0 = 14;
hedit0 = 20;
fact = 5;
str0 = 'no. of mol. (N):';
str1 = 'Load coordinates:';
str2 = '...';
str3 = 'rem.';
str4 = 'Load presets:';
ttl0 = 'Thermodynamic model';
ttl1 = 'Photophysics';
ttstr0 = wrapStrToWidth('<b>Sample size:</b> number of simulated single molecules',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('<b>Import coordinates from file:</b> coordinates in the donor channel (x1,y1) are imported from columns (1,2) and in acceptor channel (x2,y2) from columns (3,4)',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('<b>Cancel coordinates import:</b> molecule coordinates will be randomly generated.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('<b>Import presets from file:</b> preset parameters include coordinates, FRET values and deviations, transition rates, total intensities and deviations, gamma factors and deviations, PSF widths. See MASH-FRET\tools\createSimPrm.m for help.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('<b>Cancel presets import:</b> simulation parameters are taken from the graphical interface.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_S_molecules;

% dimensions
pospan = get(h_pan,'position');
hpan = pospan(4)-2*p.mg;
htbl = pospan(4)-5*p.mg/2-5*p.mg/fact-2*htxt0-5*hedit0;
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wedit0 = pospan(3)-wpan0-wpan1-2*p.mg-wtxt0;
wtxt1 = pospan(3)-wpan0-wpan1-2*p.mg;
wedit1 = pospan(3)-wpan0-wpan1-2*p.mg;
wbut0 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut1 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;

% GUI
x = p.mg/2;
y = pospan(4)-2*p.mg-hedit0+(hedit0-htxt0)/2;

h.text_simNbMol = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str0,'position',...
    [x,y,wtxt0,htxt0]);

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_nbMol = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_nbMol_Callback,h_fig},'tooltipstring',ttstr0);

x = p.mg/2;
y = pospan(4)-2*p.mg-hedit0-p.mg/fact-htxt0;

h.text_simCoordFile = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str1,...
    'position',[x,y,wtxt1,htxt0],'horizontalalignment','left');

y = y-hedit0;

h.edit_simCoordFile = uicontrol('style','edit','units',p.posun,'parent',...
    h_pan,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'enable','inactive','foregroundcolor',p.fntclr1);

y = y-p.mg/fact-hedit0;

h.pushbutton_simImpCoord = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str2,'callback',...
    {@pushbutton_simImpCoord_Callback,h_fig},'tooltipstring',ttstr1);

x = x+wbut0+p.mg/fact;

h.pushbutton_simRemCoord = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut1,hedit0],'string',str3,'callback',...
    {@pushbutton_simRemCoord_Callback,h_fig},'tooltipstring',ttstr2);

x = p.mg/2;
y = y-p.mg/fact-htbl;

h.uitable_simCoord = uitable('parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,htbl],'data',...
    cell(4,2));

y = y-p.mg/fact-htxt0;

h.text_simPrmFile = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str4,...
    'position',[x,y,wtxt1,htxt0],'horizontalalignment','left');

y = y-hedit0;

h.edit_simPrmFile = uicontrol('style','edit','units',p.posun,'parent',...
    h_pan,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'enable','inactive','foregroundcolor',p.fntclr1);

y = y-p.mg/fact-hedit0;

h.pushbutton_simImpPrm = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str2,'callback',...
    {@pushbutton_simImpPrm_Callback,h_fig},'tooltipstring',ttstr3);

x = x+wbut0+p.mg/fact;

h.pushbutton_simRemPrm = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut1,hedit0],'string',str3,'callback',...
    {@pushbutton_simRemPrm_Callback,h_fig},'tooltipstring',ttstr4);

x = p.mg/2+wtxt0+wedit0+p.mg/2;
y = p.mg/fact;

h.uipanel_S_thermodynamicModel = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'title',ttl0,'position',...
    [x,y,wpan0,hpan]);
h = buildPanelSimThermodynamicModel(h,p);

x = x+wpan0+p.mg/fact;

h.uipanel_S_photophysics = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'title',ttl1,'position',...
    [x,y,wpan1,hpan]);
h = buildPanelSimPhotophysics(h,p);
