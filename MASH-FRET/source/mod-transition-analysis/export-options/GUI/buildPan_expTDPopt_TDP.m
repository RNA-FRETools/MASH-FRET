function q = buildPan_expTDPopt_TDP(q,p,h_fig)
% q = buildPan_expTDPopt_TDP(q,p,h_fig)
%
% Build panel "TDP" in TA's "Export options" window
%
% q: structure containing figure's control handles
% p: structure containg main figure default layout parameters
% h_fig: handle to main figure

% default
str0 = 'clusters';
str1 = {'original', 'Gaussian convoluted', 'all'};
str2 = 'image(*.png):';
str3 = {'matrix(*.tdp)', 'gauss. convoluted matrix(*.tdp)', ...
    'coordinates (x,y,occurrence)(*.txt)', 'all(*.tdp, *.txt)'};
str4 = 'ASCII:';

% parent
h_pan = q.uipanel_TDP;

% dimensions
wcb0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wpop0 = getUItextWidth(str1{2},p.fntun,p.fntsz1,'normal',p.tbl)+p.warr;
wcb1 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wpop1 = getUItextWidth(str3{3},p.fntun,p.fntsz1,'normal',p.tbl)+p.warr;
wcb2 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wpan = p.mg+max([wcb0,wcb1+wpop0,wcb2+wpop1])+p.mg;
hpan = p.mgpan+p.hpop0+p.mg+p.hpop0+p.mg+p.hedit0+p.mg;

% set panel dimensions
h_pan.Position([3,4]) = [wpan,hpan];

% GUI
x = p.mg;
y = p.mg;

q.checkbox_TDPclust = uicontrol('parent',h_pan,'style','checkbox',...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str0,...
    'position',[x,y,wcb0,p.hedit0],'callback',...
    {@checkbox_expTDPopt_TDPclust_Callback,h_fig});

y = y+p.hedit0+p.mg+(p.hpop0-p.hedit0)/2;

q.checkbox_TDPimg = uicontrol('parent',h_pan,'style','checkbox','units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str2,...
    'position',[x y wcb1 p.hedit0],'callback',...
    {@checkbox_expTDPopt_TDPimg_Callback, h_fig});

x = x+wcb1;
y = y-(p.hpop0-p.hedit0)/2;

q.popupmenu_TDPimg = uicontrol('parent',h_pan,'style','popupmenu','units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x y wpop0 p.hpop0],'string',str1,'callback',...
    {@popupmenu_expTDPopt_TDPimg_Callback,h_fig});

x = p.mg;
y = y+p.hpop0+p.mg+(p.hpop0-p.hedit0)/2;

q.checkbox_TDPascii = uicontrol('parent',h_pan,'style','checkbox','units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str4,...
    'position',[x y wcb2 p.hedit0],'callback',...
    {@checkbox_expTDPopt_TDPascii_Callback, h_fig});

x = x+wcb2;
y = y-(p.hpop0-p.hedit0)/2;

q.popupmenu_TDPascii = uicontrol('parent',h_pan,'style','popupmenu',...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x y wpop1 p.hedit0],'string',str3,'callback',...
    {@popupmenu_expTDPopt_TDPascii_Callback, h_fig});
