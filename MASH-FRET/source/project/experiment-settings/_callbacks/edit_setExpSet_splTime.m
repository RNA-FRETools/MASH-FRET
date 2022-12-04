function edit_setExpSet_splTime(obj,evd,h_fig)

% retrieve project content
proj = h_fig.UserData;

spltime = str2double(get(obj,'string'));
if ~(isnumeric(spltime) && ~isempty(spltime) && spltime>0)
    helpdlg('Video sampling time must be a strictly positive number.');
else
    proj.frame_rate = spltime;
    
    % save modifications
    h_fig.UserData = proj;
end

% update interface
ud_setExpSet_tabDiv(h_fig);