function q = buildPanelOverview(q,p,h_fig)
% Build panel "Overview" and update main structure with handles to new uicontrols

% q.uipanel_overview: handle to panel "Overview"
%
% p.posun: position units
% p.fntun: font units
% p.fntsz: main font size
% p.mg: main margin
% p.mgbig: large margin
% p.wedit: main edit field width
% p.hbut: main button height
% p.htxt: main text height

% defaults
wsld = 20; % slider bar x-dimension
arrow_up = repmat([0.92 0.92 0.92 0.92 0.92 0.92 0 0.92 0.92 0.92 0.92 0.92;
    0.92 0.92 0.92 1    1    0    0 0    0.92 0.92 0.92 0.92;
    0.92 0.92 1    1    0    0    0 0    0    0.92 0.92 0.92;
    0.92 1    1    0    0    0    0 0    0    0    0.92 0.92;
    1    1    0    0    0    0    0 0    0    0    0    0.85;
    1    0    0    0    0    0    0 0    0    0    0    0;
    1    1    1    1    1    1    1 1    1    1    1    0.85],[1,1,3]);
str0 = 'Selection:';
str1 = 'Untag all';
str2 = 'define a new tag';
str3 = 'Set';
str4 = 'Delete tag';
str5 = 'disp:';
ttstr0 = 'Remove tags to all molecules';
ttstr1 =  'select a molecule tag';
ttstr2 = 'define the tag color';
ttstr3 = 'Delete a default tag';
ttstr4 = 'Hide overall panel';
ttstr5 = 'Number of molecule per view';

% parent
h_pan = q.uipanel_overview;

% dimensions
pospan = get(h_pan,'position');
wpop = 3*p.wedit+2*p.mg/2;
wbut = (wpop+p.wtxt3)/2;
h_sld = pospan(4) - 3*p.mg - p.mg - p.hbut;

% list strings
str_pop = getStrPop_select(h_fig);
str_lst = colorTagNames(h_fig);

% "reduce panel" userdata
dat.arrow = flip(arrow_up,1);% close
dat.open = 1;
dat.tooltip = 'Show overall panel';% close
dat.visible = 'off';

% sliding bar steps and visibility
N = numel(q.molValid);
if N<p.defNperPage
    N_disp = N;
else
    N_disp = p.defNperPage;
end
if N<=N_disp || N_disp==0
    sbstep0 = 1;
    sbstep1 = 1;
    sbmin = 0;
    sbmax = 1;
    sbvis = 'off';
else
    sbvis = 'on';
    sbmin = 1;
    sbmax = N-N_disp+1;
    sbstep0 = 1/(N-N_disp);
    sbstep1 = N_disp/(N-N_disp);
end

x = p.mg;
y = pospan(4) - p.mg - p.mg - p.hbut + (p.hbut-p.htxt)/2;
    
% added by MH, 24.4.2019
q.text_selection = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'string',str0,'position',[x,y,0.5*wpop,p.htxt],'fontunits',p.fntun, ...
    'fontsize', p.fntsz,'fontweight','bold');

x = x + 0.5*wpop + p.mg/2 ;
y = y - (p.hbut-p.htxt)/2;

% added by MH, 24.4.2019
q.popupmenu_selection = uicontrol('style','popupmenu','parent',...
    h_pan,'units',p.posun,'string',str_pop,'value',1,'position',...
    [x,y,4/5*wpop,p.hbut],'fontunits',p.fntun,'fontsize', p.fntsz,...
    'callback',{@popupmenu_selection_Callback,h_fig});

x = x + 4/5*wpop + 2*p.mg;

q.pushbutton_untagAll = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'string',str1,'position',[x y 0.5*wpop p.hbut],...
    'tooltipString',ttstr0,'fontunits',p.fntun,'fontsize',p.fntsz,...
    'callback',{@pushbutton_untagAll_Callback,h_fig});

x = x + 0.5*wpop + p.mg;

% edit box to define a molecule tag, added by FS, 24.4.2018
q.edit_molTag = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'String',str2,'FontUnits',p.fntun,'FontSize',p.fntsz,'Position',...
    [x y wpop p.hbut],'Callback',{@edit_addMolTag_Callback,h_fig});

x = x + wpop + p.mg;

% popup menu to select molecule tag, added by FS, 24.4.2018
% add callback, MH 24.4.2019
q.popup_molTag = uicontrol('Style','popup','Parent',h_pan,'Units',p.posun, ...
    'String',str_lst,'Position',[x y wpop p.hbut],'TooltipString',ttstr1, ...
    'FontUnits',p.fntun,'FontSize',p.fntsz,'Callback',...
    {@popup_molTag_Callback,h_fig});

x = x + wpop + p.mg;

% added by MH, 24.4.2019
q.pushbutton_tagClr = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'string',str3,'position',[x y p.wedit p.hbut],...
    'tooltipstring',ttstr2,'fontunits',p.fntun,'fontsize',p.fntsz,...
    'callback',{@pushbutton_tagClr_Callback,h_fig},'enable','off');

x = x + p.wedit + p.mg;

% popup menu to select molecule tag, added by FS, 24.4.2018
q.pushbutton_deleteMolTag = uicontrol('Style','pushbutton','Parent',h_pan,...
    'Units',p.posun,'FontUnits',p.fntun,'FontSize',p.fntsz,'String',str4,...
    'Position',[x y 1/2*wpop p.hbut],'TooltipString',ttstr3,'Callback',...
    {@pushbutton_deleteMolTag_Callback,h_fig});

x = pospan(3) - p.mg - wbut;

q.pushbutton_reduce = uicontrol('Style','pushbutton','Parent',h_pan,...
    'Units',p.posun,'Position',[x y wbut p.hbut],'CData',arrow_up,...
    'TooltipString',ttstr4,'Callback',{@pushbutton_reduce_Callback,h_fig},...
    'userdata',dat);

x = x - p.mgbig - p.wedit;

q.edit_nbTotMol = uicontrol('Style','edit','Parent',h_pan,'Units',p.posun,...
    'Position',[x y p.wedit p.hedit],'String',num2str(p.defNperPage),...
    'TooltipString',ttstr5,'Callback',{@edit_nbTotMol_Callback,h_fig});

x = x - p.mg - p.wedit;
y = y + (p.hedit-p.htxt)/2;

q.textNmol = uicontrol('Style','text','Parent',h_pan,'Units',p.posun,...
    'String',str5,'HorizontalAlignment','right','Position',...
    [x y p.wedit p.htxt],'FontUnits',p.fntun,'FontSize',p.fntsz);

x = pospan(3) - p.mg - wsld;
y = p.mg;

q.slider = uicontrol('Style','slider','Parent',h_pan,'Units',p.posun,...
    'Position',[x y wsld h_sld],'Value',sbmax,'Max',sbmax,'Min',...
    sbmin,'Callback',{@slider_Callback,h_fig},'SliderStep',...
    [sbstep0 sbstep1],'Visible',sbvis);

