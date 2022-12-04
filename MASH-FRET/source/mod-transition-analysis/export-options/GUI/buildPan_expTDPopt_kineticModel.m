function q = buildPan_expTDPopt_kineticModel(q,p,h_fig)
% q = buildPan_expTDPopt_kineticModel(q,p,h_fig)
%
% Build panel "Kinetic model" in TA's "Export options" window
%
% q: structure containing figure's control handles
% p: structure containg main figure default layout parameters
% h_fig: handle to main figure

% defaults
str0 = 'model selection (*_BIC.txt)';
str1 = 'model parameters (*_mdl.txt)';
str2 = 'simulated dwell times (*.dt)';

% parent
h_pan = q.uipanel_mdl;

% dimensions
wcb0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wcb1 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wcb2 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wpan = p.mg+max([wcb0,wcb1,wcb2])+p.mg;
hpan = p.mgpan+3*(p.hedit0+p.mg);

% set panel dimensions
h_pan.Position([3,4]) = [wpan,hpan];

% GUI
x = p.mg;
y = hpan-p.mgpan-p.hedit0;

q.checkbox_mdlSlct = uicontrol('parent',h_pan,'style','checkbox','units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str0,...
    'position',[x y wcb0 p.hedit0],'callback',...
    {@checkbox_expTDPopt_mdlSlct_Callback,h_fig});

y = y-p.mg-p.hedit0;

q.checkbox_mdlOpt = uicontrol('parent',h_pan,'style','checkbox','units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str1,...
    'position',[x y wcb1 p.hedit0],'callback',...
    {@checkbox_expTDPopt_mdlOpt_Callback,h_fig});

y = y-p.mg-p.hedit0;

q.checkbox_mdlSim = uicontrol('parent',h_pan,'style','checkbox','units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str2,...
    'position',[x y wcb2 p.hedit0],'callback',...
    {@checkbox_expTDPopt_mdlSim_Callback,h_fig});
