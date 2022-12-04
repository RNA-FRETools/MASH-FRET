function q = buildPan_expTDPopt_kineticAnalysis(q,p,h_fig)
% q = buildPan_expTDPopt_kineticAnalysis(q,p,h_fig)
%
% Build panel "Kinetic analysis" in TA's "Export options" window
%
% q: structure containing figure's control handles
% p: structure containg main figure default layout parameters
% h_fig: handle to main figure

% defaults
str0 = 'BOBA figures(*.pdf)';
str1 = 'BOBA FRET results(*.fit)';
str2 = 'fitting curves & parameters(*.fit)';
str3 = 'dwell time histograms(*.hdt)';

% parent
h_pan = q.uipanel_kin;

% dimensions
wcb0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wcb1 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wcb2 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wcb3 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wpan = p.mg+max([wcb0,wcb1,wcb2,wcb3])+p.mg;
hpan = p.mgpan+4*(p.hedit0+p.mg);

% set panel dimensions
h_pan.Position([3,4]) = [wpan,hpan];

% GUI
x = p.mg;
y = p.mg;

q.checkbox_figBOBA = uicontrol('parent',h_pan,'style','checkbox','units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str0,...
    'position',[x y wcb0 p.hedit0],'callback',...
    {@checkbox_expTDPopt_figBOBA_Callback,h_fig});

y = y+p.hedit0+p.mg;

q.checkbox_kinBOBA = uicontrol('parent',h_pan,'style','checkbox','units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str1,...
    'position',[x y wcb1 p.hedit0],'callback',...
    {@checkbox_expTDPopt_kinBOBA_Callback,h_fig});

y = y+p.hedit0+p.mg;

q.checkbox_kinCurves = uicontrol('parent',h_pan,'style','checkbox','units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x y wcb2 p.hedit0],'string',str2,'callback',...
    {@checkbox_expTDPopt_kinCurves_Callback,h_fig});

y = y+p.hedit0+p.mg;

q.checkbox_kinDthist = uicontrol('parent',h_pan,'style','checkbox','units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x y wcb3 p.hedit0],'string',str3,'callback',...
    {@checkbox_expTDPopt_kinDthist_Callback,h_fig});
