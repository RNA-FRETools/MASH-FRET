function q = buildPanelVideoView(q,p,h_fig)
% Build panel "Video view" and update main structure with handles to new uicontrols

% q.uipanel_videoView: handle to panel "Video view"
%
% p.posun: position units
% p.fntun: font units
% p.fntsz: main font size
% p.mg: main margin
% p.mgbig: large margin
% p.wcb: main checkbox width
% p.wcb2: small checkbox width
% p.hpop: main popupmenu height
% p.htxt: main text height
% p.hcb: main checkbox height
% 

% defaults
limy = [0 10000];
xlbl = 'x-position (pixel)';
ylbl = 'y-position (pixel)';
axttl = 'Average video frame';
str0 = 'Select laser wavelength:';
str1 = 'Show molecules:';
str2 = {'selected','unselected','all'};
str3 = 'show';
str4 = 'not labelled';

% parent
h_pan = q.uipanel_videoView;

% dimensions
pospan = get(h_pan,'position');
waxes = pospan(3) - p.wcb - 3*p.mg;
haxes = pospan(4) - p.hpop - 5*p.mg;
wedit2 = p.wcb-p.wcb2;

% list strings
h = guidata(h_fig);
p_proj = h.param.proj{h.param.curr_proj};
str_pop = getStrPop('exc',p_proj.excitations);
if numel(str_pop)>1
    str_pop = [str_pop 'all'];
end

x = 2*p.mg;
y = pospan(4) - 2*p.mg - p.hpop + (p.hpop-p.htxt)/2;

q.text_exc = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'position',[x,y,0.7*p.wcb,p.htxt],'fontunits',p.fntun,'fontsize',...
    p.fntsz,'string',str0,'fontweight','bold','horizontalalignment',...
    'left');

x = x + 0.7*p.wcb + p.mg;
y = y - (p.hpop-p.htxt)/2;

q.popupmenu_VV_exc = uicontrol('style','popup','parent',h_pan,'units',...
    p.posun,'string',str_pop,'position',[x,y,0.3*p.wcb,p.hpop],'value',...
    numel(str_pop),'callback',{@popupmenu_VV_exc_Callback,h_fig});

x = 2*p.mg;
y = y - p.mgbig - p.hpop + (p.hpop-p.htxt)/2;

q.text_VV_mol = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'position',[x,y,0.5*p.wcb,p.htxt],'fontunits',p.fntun,'fontsize',...
    p.fntsz,'string',str1,'fontweight','bold','horizontalalignment',...
    'left');

x = x + 0.5*p.wcb + p.mg;
y = y - (p.hpop-p.htxt)/2;

q.popupmenu_VV_mol = uicontrol('style','popup','parent',h_pan,'units',...
    p.posun,'value',numel(str2),'position',[x,y,0.5*p.wcb,p.hpop],'string',...
    str2,'callback',{@popupmenu_VV_mol_Callback,h_fig});

x = 2*p.mg;
y = y - p.mgbig - p.hpop;

q.checkbox_VV_tag0 = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz,'string',str3,'position',...
    [x,y,p.wcb2,p.hcb],'callback',{@checkbox_VV_tag0_Callback,h_fig});

x = x + p.wcb2 + p.mg;

q.edit_VV_tag0 = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz,'position',[x,y,wedit2,p.hcb],...
    'string',str4,'enable','off');

x = p.wcb + 3*p.mg;
y = pospan(4) - p.hpop - p.mg - haxes;

q.axes_videoView = axes('parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz,'activepositionproperty',...
    'outerposition','gridlineStyle',':','nextPlot','replace');
ylim(q.axes_videoView,limy);
ylabel(q.axes_videoView,xlbl);
xlabel(q.axes_videoView,ylbl);
title(q.axes_videoView,axttl);
pos = getRealPosAxes([x,y,waxes,haxes],...
    get(q.axes_videoView,'tightinset'),'traces'); 
pos(3) = pos(3) - p.fntsz;
pos(1) = pos(1) + p.fntsz;
set(q.axes_videoView,'Position',pos);

