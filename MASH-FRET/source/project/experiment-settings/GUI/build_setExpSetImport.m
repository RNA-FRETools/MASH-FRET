function h = build_setExpSetImport(h,dat2import,h_fig0)
% h = build_setExpSetImport(h,dat2import,h_fig0)
%
% Builds first tabbed panel "Import" of "Experiment settings" window.
%
% h: structure containing handles to all figure's children
% dat2import: data to import from file ('video' or 'trajectories')
% h_fig0: handle to main figure

% defaults
str0a = 'Select a video file:';
str0b = 'Select the trajectory files:';
str1 = '...';
str2 = ['Next ',char(9658)];

% parents
h_fig = h.figure;
h_tab = h.tab_imp;

% dimensions
postab = h_tab.Position;
switch dat2import
    case 'video'
        str0 = str0a;
    case 'trajectories'
        str0 = str0b;
    otherwise
        str0 = str0a;
end
wtxt0 = postab(3)-2*h.mg;
wbut0 = getUItextWidth(str1,h.fun,h.fsz,'normal',h.tbl)+h.wbrd;
wedit0 = wtxt0-h.mg-wbut0;
wbut1 = getUItextWidth(str2,h.fun,h.fsz,'normal',h.tbl)+h.wbrd;

x = h.mg;
y = postab(4)-h.mgtab-h.mg-h.htxt;

h.text_impFile = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str0,'horizontalalignment',...
    'left','position',[x,y,wtxt0,h.htxt]);

y = y-h.mg-h.hedit;

h.edit_impFile = uicontrol('parent',h_tab,'style','edit','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,wedit0,h.hedit],...
    'callback',{@edit_setExpSet_impFile,h_fig});

x = x+wedit0+h.mg;

h.push_impFile = uicontrol('parent',h_tab,'style','pushbutton','units',...
    h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str1,'position',...
    [x,y,wbut0,h.hedit],'callback',{@push_setExpSet_impFile,h_fig,h_fig0});

y = h.mg;
x = postab(3)-h.mg-wbut1;

h.push_nextImp = uicontrol('parent',h_tab,'style','pushbutton','units',...
    h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str2,'position',...
    [x,y,wbut1,h.hedit],'callback',{@push_setExpSet_next,h_fig,1});
