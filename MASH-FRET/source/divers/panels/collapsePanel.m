function collapsePanel(hbut)
% collapsePanel(hbut)
%
% Collapse panel corresponding to input "Expand" button.
%
% hbut: handles to "Expand" buttons

% default
mgy = 10; % pixel margin between panels' bottoms and tops
mgx = 1; % pixel margin between expand/collapse and help buttons
hght_cllps = 25; % panel pixel height when collapsed
clr_cllps = [0.8,0.8,0.8]; % background color of collapsed panels

% get handles to input panels
hpans = [];
for p = 1:numel(hbut)
    hpans = cat(2,hpans,hbut(p).UserData{1});
end

% get parent and corresponding pixel height
hprnt = hpans(1).Parent;
% hght_prnt = hprnt.Position(4);
% hfig = hprnt.Parent;
% posfig = getPixPos(hfig);
% hght_prnt = hght_prnt*posfig(4);
posprnt = getPixPos(hprnt);
hght_prnt = posprnt(4);

% get handles to all children panels and collapse/expand buttons
hchld = hprnt.Children;
nChld = numel(hchld);
incl_pan = false(1,nChld);
incl_but = incl_pan;
incl_hlp = incl_pan;
for c = 1:nChld
    if strcmp(hchld(c).Type,'uipanel')
        incl_pan(c) = true;
    end
    if strcmp(hchld(c).Type,'uicontrol') && ...
            strcmp(hchld(c).Style,'pushbutton')
        if isExtButton(hchld(c))
            incl_but(c) = true;
        elseif isempty(hchld(c).String) && ...
                ~strcmp(hchld(c).UserData,'nohelp')
            incl_hlp(c) = true;
        end
    end
end
hcpan = hchld(incl_pan);
hcbut = hchld(incl_but);
hchlp = hchld(incl_hlp);
if numel(hcpan)~=numel(hcbut) || numel(hcpan)~=numel(hchlp)
    disp(['collapsePanel: The number of expandable panels (',...
        num2str(numel(hcpan)),') is different than the number of buttons (',...
        num2str(numel(hcbut)),') or help buttons (',num2str(numel(hchlp)),...
        ')'])
    return
end

% order children from top to bottom positions
nChld = numel(hcpan);
ycpan = NaN(1,nChld);
ycbut = ycpan;
ychlp = ycpan;
un_pan = cell(1,nChld);
un_but = un_pan;
un_hlp = un_pan;
for c = 1:nChld
    % set panel's and buttons' position units to pixels
    un_pan{c} = hcpan(c).Units;
    hcpan(c).Units = 'pixels';
    un_but{c} = hcbut(c).Units;
    hcbut(c).Units = 'pixels';
    un_hlp{c} = hchlp(c).Units;
    hchlp(c).Units = 'pixels';
    
    % get panel's and buttons's y-position
    ycpan(c) = hcpan(c).Position(2);
    ycbut(c) = hcbut(c).Position(2);
    ychlp(c) = hchlp(c).Position(2);
end
[~,ord] = sort(ycpan,'descend');
hcpan = hcpan(ord);
[~,ord] = sort(ycbut,'descend');
hcbut = hcbut(ord);
[~,ord] = sort(ychlp,'descend');
hchlp = hchlp(ord);

% collapse input panels and adjust y-positions of panels below
for c = 1:nChld
    if sum(hcpan(c)==hpans)
        % set panel color
        set(hcpan(c),'bordertype','none','backgroundcolor',clr_cllps);
        hght = hght_cllps;
    else
        hght = hcpan(c).Position(4);
    end
    hcbut(c).String = char(9660);
    
    % set panel position relative to top panels
    if c==1 % toppest panel
        y = hght_prnt-mgy/2-hght;
    else
        y = hcpan(c-1).Position(2)-mgy-hght;
    end
    x = hcpan(c).Position(1);
    wdth = hcpan(c).Position(3);
    hcpan(c).Position = [x,y,wdth,hght];
    
    % set expand/collapse button's position
    x = x+wdth-hcbut(c).Position(3);
    y = y+hght-hcbut(c).Position(4);
    hcbut(c).Position = [x,y,hcbut(c).Position([3,4])];
    
    % set help button's position
    x = x-mgx-hcbut(c).Position(3);
    hchlp(c).Position = [x,y,hchlp(c).Position([3,4])];
end

% reset panel's and button's position units to original
for c = 1:nChld
    hcpan(c).Units = un_pan{c};
    hcbut(c).Units = un_but{c};
    hchlp(c).Units = un_hlp{c};
end

