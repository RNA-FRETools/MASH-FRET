function ud_setExpSet_tabChan(h_fig)
% ud_setExpSet_tabChan(h_fig)
% 
% Set properties of controls in "Channel" tab of window "Experimental 
% settings" to proper values
%
% h_fig0: handle to "Experiment settings" figure

% get interface content
h = guidata(h_fig);

if ~(isfield(h,'tab_chan') && ishandle(h.tab_chan))
    return
end
    

% get project parameters
proj = h.figure.UserData;

% set number of channels
set(h.edit_nChan,'string',num2str(proj.nb_channel));
if h.radio_impFileSingle.Value
    set(h.edit_nChan,'enable','off');
else
    set(h.edit_nChan,'enable','on');
end

% set emitter names
for c = 1:proj.nb_channel
    if isfield(h,'edit_chanLbl') && c<=numel(h.edit_chanLbl) && ...
            ishandle(h.edit_chanLbl(c))
        set(h.edit_chanLbl(c),'string',proj.labels{c});
    end
end

% set image axes
if proj.nb_channel==0
    set(h.axes_chan,'visible','off');
else
    set(h.axes_chan,'visible','on');
end

% set "Next" button
allset = true;
for c = 1:proj.nb_channel
    if ~(c<=numel(proj.labels) && ~isempty(proj.labels{c}))
        allset = false;
        break
    end
end
if allset
    set(h.push_nextChan,'enable','on');
else
    set(h.push_nextChan,'enable','off');
end

