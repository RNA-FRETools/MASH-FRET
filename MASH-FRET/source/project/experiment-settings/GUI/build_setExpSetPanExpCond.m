function h = build_setExpSetPanExpCond(h)
% h = build_setExpSetPanExpCond(h)
%
% Builds panel "Experimental conditions" of "Experimental settings" window.
%
% h: structure containing handles to all figure's children

% defaults
str0 = 'Molecule name:';
tblhead = {'condition','value','units'};
tbldim = 10;

% parents
h_fig = h.figure;
h_pan = h.panel_expCond;

% dimensions
pospan = h_pan.Position;
wtxt0 = getUItextWidth(str0,h.fun,h.fsz,'normal',h.tbl)+h.wpad;
wedit1 = pospan(3)-2*h.mg-wtxt0;
wtbl = pospan(3)-2*h.mg;
htbl = pospan(4)-h.mgpan-h.hedit-2*h.mg;

% GUI
x = h.mg;
y = pospan(4)-h.mgpan-h.hedit+(h.hedit-h.htxt)/2;

h.text_molName = uicontrol('parent',h_pan,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str0,'position',...
    [x,y,wtxt0,h.htxt],'horizontalalignment','left');

x = x+wtxt0;
y = y-(h.hedit-h.htxt)/2;

h.edit_molName = uicontrol('parent',h_pan,'style','edit','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,wedit1,h.hedit],...
    'callback',{@edit_setExpSet_molName,h_fig});

x = h.mg;
y = y-h.mg-htbl;

h.table_cond = uitable('parent',h_pan,'units',h.un,'fontunits',h.fun,...
    'fontsize',h.fsz,'position',[x,y,wtbl,htbl],'columnname',tblhead,...
    'celleditcallback',{@table_setExpSet_cond,h_fig},'data',...
    cell(tbldim,numel(tblhead)),'columneditable',true(1,numel(tblhead)));

