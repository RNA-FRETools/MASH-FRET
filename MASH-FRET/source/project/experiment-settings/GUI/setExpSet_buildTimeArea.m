function h = setExpSet_buildTimeArea(h,exc,h_fig0)
% h = setExpSet_buildTimeArea(h,exc,h_fig0)
%
% Creates adjustable control area of tabbed panel "File structure".
%
% h: structure containing handles to all figure's children
% exc: laser wavelengths
% h_fig0: handle to main figure

% defaults
str0 = '999nm:';
str1 = '(0=end)';

% parents
h_fig = h.figure;
h_tab = h.tab_fstrct;
h_cb = h.check_timeDat;

% dimensions
prevun = h_tab.Units;
setProp([h_fig,h_fig.Children],'units','pixels');
poscb = h_cb.Position;
wtxt0 = getUItextWidth(str0,h.fun,h.fsz,'normal',h.tbl);
wtxt1 = getUItextWidth(str1,h.fun,h.fsz,'normal',h.tbl);

% delete previous controls
if isfield(h,'text_timeExcCol') && sum(ishandle(h.text_timeExcCol))
    delete(h.text_timeExcCol);
    h = rmfield(h,'text_timeExcCol');
end
if isfield(h,'edit_timeExcCol') && sum(ishandle(h.edit_timeExcCol))
    delete(h.edit_timeExcCol);
    h = rmfield(h,'edit_timeExcCol');
end
if isfield(h,'text_timeExcZero') && sum(ishandle(h.text_timeExcZero))
    delete(h.text_timeExcZero);
    h = rmfield(h,'text_timeExcZero');
end

% GUI
x = poscb(1)+poscb(3);
y = poscb(2);

nExc = numel(exc);
for l = 1:nExc
    
    y = y+(h.hedit-h.htxt)/2;
    
    h.text_timeExcCol(l) = uicontrol('parent',h_tab,'style','text',...
        'units',h.un,'fontunits',h.fun,'fontsize',h.fsz,'position',...
        [x,y,wtxt0,h.htxt],'string',sprintf('%inm:',exc(l)));
    
    x = x+wtxt0;
    y = y-(h.hedit-h.htxt)/2;
    
    h.edit_timeExcCol(l) = uicontrol('parent',h_tab,'style','edit','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold',...
        'foregroundcolor',h_cb.ForegroundColor,'position',...
        [x,y,h.wedit0,h.hedit],'callback',...
        {@edit_setExpSet_timeExcCol,l,h_fig});
    
    x = x+h.wedit0+h.mg/2;
end

x = x-h.mg/2;
y = y+(h.hedit-h.htxt)/2;

h.text_timeExcZero = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str1,'position',...
    [x,y,wtxt1,h.htxt]);

setProp([h_fig,h_fig.Children],'units',prevun);
