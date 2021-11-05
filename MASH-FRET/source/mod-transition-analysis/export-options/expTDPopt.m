function expTDPopt(h_fig0)
% expTDPopt(h_fig0)
%
% Builds window "Export options" of TA module
%
% h_fig0: handle to main figure

% defaults
figttl = 'Export options';
str0 = 'Next >>';
str1 = 'Cancel';
ttl0 = 'Kinetic analysis';
ttl1 = 'TDP';
ttl2 = 'Kinetic model';

% control TA
h = guidata(h_fig0);
if ~isModuleOn(h.param,'TA')
    return
end

% get project's export settings
opt = h.param.proj{h.param.curr_proj}.TA.exp;
prm_default = getExpTDPprm();
opt = adjustVal(opt, prm_default);

% delete existing figure if any
if isfield(h, 'expTDPopt') && isfield(h.expTDPopt,'figure_expTDPopt') ...
        && ishandle(h.expTDPopt.figure_expTDPopt)
    delete(h.expTDPopt.figure_expTDPopt);
    h = rmfield(h,'expTDPopt');
end

% collect default layout parameters
p = h.dimprm;

% positions
pos_0 = get(0, 'ScreenSize');
wbut0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut1 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;

% GUI
q.figure_expTDPopt = figure('name',figttl,'menubar','none','numbertitle',...
    'off','visible','off','units',p.posun,'closerequestfcn',...
    {@figure_expTDPopt_CloseRequestFcn,h_fig0});
h_fig = q.figure_expTDPopt;

q.uipanel_TDP = uipanel('parent',h_fig,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'title',ttl1);
q = buildPan_expTDPopt_TDP(q,p,h_fig0);

q.uipanel_kin = uipanel('parent',h_fig,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'title',ttl0);
q = buildPan_expTDPopt_kineticAnalysis(q,p,h_fig0);

q.uipanel_mdl = uipanel('parent',h_fig,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'title',ttl2);
q = buildPan_expTDPopt_kineticModel(q,p,h_fig0);

q.pushbutton_next = uicontrol('style','pushbutton','parent',h_fig,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str0,...
    'callback',{@pushbutton_expTDPopt_next_Callback,h_fig0});

q.pushbutton_cancel = uicontrol('style','pushbutton','parent',h_fig,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'string',str1,...
    'callback',{@pushbutton_expTDPopt_cancel_Callback,h_fig0});

% adjust figure position
hpan0a = q.uipanel_TDP.Position(4);
hpan0b = q.uipanel_kin.Position(4);
hpan1 = q.uipanel_mdl.Position(4);
hpan0 = hpan0a+p.mg+hpan0b;
hfig = p.mg+max([hpan0,hpan1]+p.mg+p.wbuth+p.mg);

wpan0a = q.uipanel_TDP.Position(3);
wpan0b = q.uipanel_kin.Position(3);
wpan0 = max([wpan0a,wpan0b]);
wpan1 = q.uipanel_mdl.Position(3);
wfig = p.mg+wpan0+p.mg+wpan1+p.mg;

x = (pos_0(3)-wfig)/2;
y = (pos_0(4)-hfig)/2;

h_fig.Position = [x,y,wfig,hfig];

% adjust content positions
x = p.mg;
y = hfig-p.mg-hpan0a;
q.uipanel_TDP.Position = [x,y,wpan0,hpan0a];

y = y-p.mg-hpan0b;
q.uipanel_kin.Position = [x,y,wpan0,hpan0b];

x = x+wpan0+p.mg;
y = hfig-p.mg-hpan1;
q.uipanel_mdl.Position = [x,y,wpan1,hpan1];

x = wfig-p.mg-wbut0;
y = p.mg+(p.wbuth-p.hedit0)/2;
q.pushbutton_next.Position = [x,y,wbut0,p.hedit0];

x = x-p.mg-wbut1;
q.pushbutton_cancel.Position = [x,y,wbut1,p.hedit0];

% save modifications
h.expTDPopt = q;
guidata(h_fig0,h);

% add help button
q.pushbutton_help = setInfoIcons(h.expTDPopt.pushbutton_cancel,h_fig0,...
    h.param.infos_icon_file);

% save modifications
h = guidata(h_fig0);
h.expTDPopt = q;
guidata(h_fig,opt);
guidata(h_fig0, h);

% refresh panels
ud_expTDPopt(h_fig0);

% make figure visible
set(h_fig, 'Visible', 'on');

