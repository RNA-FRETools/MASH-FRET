function h = buildPanelSimThermodynamicModel(h,p)
% h = buildPanelSimThermodynamicModel(h,p);
%
% Builds "Thermodynamic model" panel in "Simulation" module
% 
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_S_thermodynamicModel: handle to panel "Thermodynamic model"
% p: structure containing default and often-used parameters (dimensions, margin etc.) with fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.tbl: reference table listing character's pixel dimensions

% created by MH, 19.10.2019

% default
wedit0 = 40;
htxt0 = 14;
hedit0 = 20;
hpop0 = 22;
fact = 5;
Jmax = 5; % max. number of states settable via GUI
str0 = 'nb. of states (J):';
str1 = {'Select a state'};
str2 = 'state (j)';
str3 = 'FRETj';
str4 = 'wFRETj';
str5 = 'Transition rates (kjj'' in s-1)';
ttstr0 = wrapHtmlTooltipString('<b>Number of FRET states:</b> including degenerated states.');
ttstr1 = wrapHtmlTooltipString('Select a <b>state</b> to configurate.');
ttstr2 = wrapHtmlTooltipString('<b>FRET value</b> assigned to the selected state.');
ttstr3 = wrapHtmlTooltipString('<b>Sample heterogeneity:</b> standard deviation of the FRET Gaussian distribution associated to the selected state.');
ttstr4 = cell(1,Jmax^2);
for j1 = 1:Jmax
    for j2 = 1:Jmax
        ttstr4{j1,j2} = wrapHtmlTooltipString(sprintf('rate of transition <b>%i->%i</b>',j1,j2));
    end
end

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_S_thermodynamicModel;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt1 = Jmax*wedit0+(Jmax-1)*p.mg/fact;
wtxt2 = -Inf;
for j = 1:Jmax
    w = getUItextWidth(num2str(j),p.fntun,p.fntsz1,'normal',p.tbl);
    if w>wtxt2
        wtxt2 = w;
    end
end

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0-hpop0+(hpop0-htxt0)/2;

h.text_simNbState = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str0,...
    'position',[x,y,wtxt0,htxt0]);

x = x + wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_nbStates = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_nbStates_Callback,h_fig},'tooltipstring',ttstr0);

x = x+wedit0+p.mg/2;
y = y-(hpop0-hedit0)/2;

h.popupmenu_states = uicontrol('style','popupmenu','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hpop0],'callback',{@popupmenu_states_Callback,h_fig},...
    'string',str1,'tooltipstring',ttstr1);

y = y+hpop0;

h.text_simStates = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str2,'position',...
    [x,y,wedit0,htxt0]);

x = x+wedit0+p.mg/fact;
y = y-hpop0+(hpop0-hedit0)/2;

h.edit_stateVal = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_stateVal_Callback,h_fig},'tooltipstring',ttstr2);

y = y+hedit0;

h.text_simFRETval = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str3,...
    'position',[x,y,wedit0,htxt0]);

x = x+wedit0+p.mg/fact;
y = y-hedit0;

h.edit_simFRETw = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_simFRETw_Callback,h_fig},'tooltipstring',ttstr3);

y = y+hedit0;

h.text_simFRETdelta = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str4,...
    'position',[x,y,wedit0,htxt0]);

x = p.mg/2+wtxt2;
y = y-hedit0-(hpop0-hedit0)/2-p.mg/2-htxt0;

h.text_simTransRates = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str5,...
    'position',[x,y,wtxt1,htxt0]);

for j1 = 1:Jmax
    
    x = p.mg/2;
    y = y-1-hedit0+(hedit0-htxt0)/2;
    
    h = setfield(h,cat(2,'text0',num2str(j1)),uicontrol('style','text',...
        'parent',h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',...
        p.fntsz1,'position',[x,y,wtxt2,htxt0],'string',num2str(j1)));
    
    y = y-(hedit0-htxt0)/2;
    x = x+wtxt2;
    
    for j2 = 1:Jmax
        h = setfield(h,cat(2,'edit',num2str(j1),num2str(j2)),...
            uicontrol('style','edit','parent',h_pan,'units',p.posun,...
            'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
            [x,y,wedit0,hedit0],'callback',{@edit_kinCst_Callback,h_fig},...
            'tooltipstring',ttstr4{j1,j2}));
        x = x+wedit0+1;
    end
end

x = p.mg/2+wtxt2;
y = y-htxt0;

for j1 = 1:Jmax
    h = setfield(h,cat(2,'text',num2str(j1),'0'),uicontrol('style','text',...
        'parent',h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',...
        p.fntsz1,'position',[x,y,wedit0,htxt0],'string',num2str(j1)));
   
    x = x+wedit0+1;
end
