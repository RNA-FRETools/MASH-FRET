function isopen = isPanelOpen(h_pan)

isopen = 0; % not an extendable panel

h_but = h_pan.UserData;
if ~(~isempty(h_but) && ishandle(h_but) && isExtButton(h_but))
    % not an extendable panel
    return
end

isopen = isExtButton(h_but);


