function h = setExpSet_buildChanArea(h,nChan)
% h = setExpSet_buildChanArea(h,nChanl)
%
% Creates adjustable control area of tabbed panel "Channels".
%
% h: structure containing handles to all figure's children
% nChan: number of channels

% defaults
str0 = 'emitter';

% parents
h_fig = h.figure;
h_tab = h.tab_chan;

% dimensions
postab = h_tab.Position;
hare = postab(4)-h.mgtab-h.hedit-2*h.mg-h.hedit-h.mg;
waxe = postab(3)-2*h.mg;
haxe = hare-h.htxt-h.mg-h.htxt-h.hedit-h.mg;
wtxt0 = (waxe-(nChan-1)*2*h.mg)/nChan;

x = h.mg;
y = h.edit_nChan.Position(2)-h.mg-h.htxt-h.mg-h.htxt-h.hedit;

for c = 1:nChan
    y = y+h.mg+h.htxt+h.hedit;
    
    h.text_chan(c) = uicontrol('parent',h_tab,'style','text','units',h.un,...
        'fontunits',h.fun,'fontsize',h.fsz,'fontweight','bold','string',...
        num2str(c),'position',[x,y,wtxt0,h.htxt],'backgroundcolor',h.bgclr,...
        'foregroundcolor',h.fgclr);
    
    y = y-h.mg-h.htxt;
    
    h.text_chanEm(c) = uicontrol('parent',h_tab,'style','text','units',...
        h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str0,'position',...
        [x,y,wtxt0,h.htxt]);
    
    y = y-h.hedit;
    
    h.edit_chanLbl(c) = uicontrol('parent',h_tab,'style','edit','units',...
        h.un,'position',[x,y,wtxt0,h.hedit],'callback',...
        {@edit_setExpSet_chanLbl,h_fig,c});
    
    x = x+wtxt0+2*h.mg;
end

x = h.mg;
y = y-h.mg-haxe;

h.axes_chan = axes('parent',h_tab,'units',h.un,'fontunits',h.fun,...
    'fontsize',h.fsz,'position',[x,y,waxe,haxe],'xtick',[],'ytick',[],...
    'nextplot','replacechildren');
