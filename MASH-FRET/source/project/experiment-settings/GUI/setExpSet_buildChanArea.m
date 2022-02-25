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
prevun = h_tab.Units;
setProp([h_fig,h_fig.Children],'units','pixels');
postab = h_tab.Position;
wtxt0 = (postab(3)-2*h.mg-(nChan-1)*2*h.mg)/nChan;
haxe = postab(4)-h.mgtab-h.hedit-h.mg-h.htxt-h.mg-h.htxt-h.hedit-h.mg-...
    h.htxt-h.mg-h.hedit-h.mg;
waxe = (postab(3)-2*h.mg-(nChan-1)*2*h.mg)/nChan;

% delete previous controls
h = delControlIfHandle(h,{'text_chan','text_chanEm','edit_chanLbl',...
    'axes_chan'});

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
    
    y = y-haxe;

    h.axes_chan(c) = axes('parent',h_tab,'units',h.un,'fontunits',h.fun,...
        'fontsize',h.fsz,'position',[x,y,waxe,haxe],'xtick',[],'ytick',[],...
        'nextplot','replacechildren');
    
    x = x+wtxt0+2*h.mg;
    y = y+haxe;
end

setProp([h_fig,h_fig.Children],'units',prevun);

