function menu_units_Callback(obj,evd,h_fig)

% collect interface content
h = guidata(h_fig);
p = h.param;

% control projects
if isempty(p.proj)
    updateFields(h_fig);
    return
end

% update units values
switch obj
    case h.menu_inSec
        p.proj{p.curr_proj}.time_in_sec = true;
        str_suc = 'Time units are now displayed in seconds!';
    case h.menu_inFrame
        p.proj{p.curr_proj}.time_in_sec = false;
        str_suc = 'Time units are now displayed in sampling steps!';
    case h.menu_perSec
        p.proj{p.curr_proj}.cnt_p_sec = ~p.proj{p.curr_proj}.cnt_p_sec;
        if p.proj{p.curr_proj}.cnt_p_sec
            str_suc = ['Intensity units are now displayed in counts per ',...
                'seconds!'];
        else
            str_suc = ['Intensity units are now displayed in counts per ',...
                'sampling step!'];
        end
    otherwise
        disp('menu_units_Callback: Unknown menu handle.');
        return
end

% save modifications
h.param = p;
guidata(h_fig,h);

% update panels and plots
updateFields(h_fig);

% display success
setContPan(str_suc,'success',h_fig);

