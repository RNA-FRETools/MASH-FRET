function ud_setExpSet_tabImp(h_fig)
% ud_setExpSet_tabImp(h_fig)
% 
% Set properties of controls in "Import" tab of window "Experimental 
% settings" to proper values
%
% h_fig: handle to "Experiment settings" figure

% get interface content
h = guidata(h_fig);

if ~(isfield(h,'tab_imp') && ishandle(h.tab_imp))
    return
end

% get project parameters
proj = h_fig.UserData;

% set interface
if proj.is_movie
    set(h.edit_impFile,'string',proj.movie_file,'enable','on');
    set(h.push_nextImp,'enable','on');
else
    set(h.edit_impFile,'string','','enable','off');
    set(h.push_nextImp,'enable','off');
end




