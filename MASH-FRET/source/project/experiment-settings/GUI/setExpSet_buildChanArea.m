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

% delete previous controls
if isfield(h,'text_chan') && sum(ishandle(h.text_chan))
    delete(h.text_chan);
    h = rmfield(h,'text_chan');
end
if isfield(h,'text_chanEm') && sum(ishandle(h.text_chanEm))
    delete(h.text_chanEm);
    h = rmfield(h,'text_chanEm');
end
if isfield(h,'edit_chanLbl') && sum(ishandle(h.edit_chanLbl))
    delete(h.edit_chanLbl);
    h = rmfield(h,'edit_chanLbl');
end

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

setProp([h_fig,h_fig.Children],'units',prevun);

