function q = build_BA_panelParameterScreening(q,p,h_fig)
% q = build_BA_panelParameterScreening(q,p,h_fig)
%
% Build panel "Parameter screening" for Background analyzer
%
% q: structure to update with handles to new gaphical elements and that must contain field:
%  q.uipanel_opt: handle to panel "Parameter screening"
% p: structure containing dfault layout settings
% h_fig: handle to main figure

% defaults
str0 = 'apply to all moelcules';
str1 = 'dim.';
str2 = 'param.';
str3 = 'fix';
str4 = 'Start';
str5 = 'Save';
nEdit = 10;
ttstr0 = 'Calculate background intensities for all molecules';
ttstr1 = 'Sub-image dimensions';
ttstr2 = 'Fix one value for the sum-image dimensions';
ttstr3 = 'Fix one value for the parameter 1';
ttstr4 = 'Start screening';
ttstr5 = 'Export results to a text file';

% parent
h_pan = q.uipanel_opt;

% dimensions
pospan = get(h_pan,'position');
wcb1 = getUItextWidth(str0,p.fntun,p.fntsz,'normal',p.tbl) + p.wbox;
wrb0 = getUItextWidth(str3,p.fntun,p.fntsz,'normal',p.tbl) + p.wbox;
wbut4 = getUItextWidth(str4,p.fntun,p.fntsz,'normal',p.tbl) + p.wbrd;
wbut5 = getUItextWidth(str5,p.fntun,p.fntsz,'normal',p.tbl) + p.wbrd;

% build GUI
x = p.mg;
y = pospan(4)-p.mgpan-p.hcb;

q.checkbox_allmol = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz,'position',...
    [x,y,wcb1,p.hcb],'string',str0,'tooltipstring',ttstr0,'callback',...
    {@checkbox_BA_allmol_Callback,h_fig});

x = p.mg;
y = y-p.mg-p.htxt;

q.text_subimdim_2 = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz,'position',...
    [x,y,p.wedit,p.htxt],'string',str1);

x = x+p.wedit+p.mg;

q.text_param1_2 = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz,'position',...
    [x,y,p.wedit,p.htxt],'string',str2);

for n = 1:nEdit
    x = p.mg;
    y = y-p.hedit;
    
    q.edit_subimdim_i(n) = uicontrol('style','edit','parent',h_pan,'units',...
        p.posun,'fontunits',p.fntun,'fontsize',p.fntsz,'position',...
        [x,y,p.wedit,p.hedit],'tooltipstring',ttstr1,'callback',...
        {@edit_BA_subimdim_Callback,h_fig,n});
    
    x = x+p.wedit+p.mg;
    
    q.edit_param1_i(n) = uicontrol('style','edit','parent',h_pan,'units',...
        p.posun,'fontunits',p.fntun,'fontsize',p.fntsz,'position',...
        [x,y,p.wedit,p.hedit],'callback',...
        {@edit_BA_param1_Callback,h_fig,n});
    
    y = y-p.mg/2;
end

x = p.mg;
y = y-p.mg-p.hcb;

q.radiobutton_fix_subimdim = uicontrol('style','radiobutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz,...
    'position',[x,y,p.wedit,p.hcb],'tooltipstring',ttstr2,'callback',...
    {@radiobutton_BA_fix_subimdim_Callback,h_fig});

x = x+p.wedit+p.mg;

q.radiobutton_fix_param1 = uicontrol('style','radiobutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz,...
    'position',[x,y,wrb0,p.hcb],'string',str3,'tooltipstring',ttstr3,...
    'callback',{@radiobutton_BA_fix_param1_Callback,h_fig});

x = pospan(3)-p.mg-wbut4;
y = y-p.mg-p.hbut;

q.pushbutton_save = uicontrol('style','pushbutton','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz,'position',...
    [x,y,wbut5,p.hbut],'string',str5,'tooltipstring',ttstr5,'callback',...
    {@pushbutton_BA_save_Callback,h_fig});

x = x-p.mg-wbut5;

q.pushbutton_start = uicontrol('style','pushbutton','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz,'position',...
    [x,y,wbut4,p.hbut],'string',str4,'tooltipstring',ttstr4,'callback',...
    {@pushbutton_BA_start_Callback,h_fig});

