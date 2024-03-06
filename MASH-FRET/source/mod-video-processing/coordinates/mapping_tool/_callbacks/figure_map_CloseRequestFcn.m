function figure_map_CloseRequestFcn(obj, evd, h_fig)

global pntCoord;

% collect intefrace parameters
h = guidata(h_fig);
q = h.map;
mute = h.mute_actions;

% collect mapping
if ~isempty(q.lim_x)
    nChan = size(q.lim_x,2) - 1;
else
    nChan = numel(q.refimgfile);
end
minN = size(pntCoord{1},1);
for i = 2:nChan
    minN = min([minN size(pntCoord{i},1)]);
end
if minN > 0
    for i = 1:nChan
        if ~isempty(q.lim_x)
            q.pnt(1:minN,2*i-1) = pntCoord{i}(1:minN,1) + q.lim_x(i);
        else
            q.pnt(1:minN,2*i-1) = pntCoord{i}(1:minN,1);
        end
        q.pnt(1:minN,2*i) = pntCoord{i}(1:minN,2);
    end
end

nb_points = size(q.pnt,1);
if nb_points >= 4 || nb_points == 0
    exit_choice = 'Yes';
else
    msgStr = {[num2str(nb_points) ' reference coordinates have been ',...
        'selected.']};
    if nb_points < 4
        msgStr = cat(2,msgStr,['No transformation can be calculated: at ',...
            'least 4 pairs of coordinates need to be mapped.']);
    end

    if ~mute
        msgStr = cat(2,msgStr,'','Do you still want to exit?');
        exit_choice = questdlg(msgStr);
    else
        for i = 1:size(msgStr,2)
            disp(msgStr{i})
        end
        exit_choice = 'Yes';
    end
end
if ~strcmp(exit_choice, 'Yes')
    return
end

% store reference coordinates
if nb_points>0

    % save points
    h.map = q;
    guidata(h_fig,h);
    
    ok = saveMapCoord(h_fig);
    if ~ok
        return
    end
end

% close mapping tool
h = guidata(h_fig);
delete(h.figure_map);
h = rmfield(h,'figure_map');
guidata(h_fig,h);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');
