function figure_map_CloseRequestFcn(obj, evd, h_fig)

global pntCoord;

% collect intefrace parameters
h = guidata(h_fig);
q = h.map;
mute = h.mute_actions;

% collect mapping
nChan = size(q.lim_x,2) - 1;
minN = size(pntCoord{1},1);
for i = 2:nChan
    minN = min([minN size(pntCoord{i},1)]);
end
if minN > 0
    for i = 1:nChan
        q.pnt(1:minN,2*i-1) = pntCoord{i}(1:minN,1) + q.lim_x(i);
        q.pnt(1:minN,2*i) = pntCoord{i}(1:minN,2);
    end
end

% save points
h.map = q;
guidata(h_fig,h);

nb_points = size(q.pnt,1);
if nb_points >= 15 || nb_points == 0
    exit_choice = 'Yes';
else
    msgStr = {[num2str(nb_points) ' reference coordinates have been ',...
        'selected.']};
    if nb_points < 2
        msgStr = cat(2,msgStr,['No spatial transformation can be ' ...
            'calculated.']);
    else
        msgStr = cat(2,msgStr,['You are able to perform following ' ...
            'spatial transformations:']);
        if nb_points >= 2
            msgStr = cat(2,msgStr,'- Nonrefective similarity');
        end
        if nb_points >= 3
            msgStr = cat(2,msgStr,'- Similarity','- Affine');
        end
        if nb_points >= 4
            msgStr = cat(2,msgStr,'- Projective','- Piecewise linear');
        end
        if nb_points >= 6
            msgStr = cat(2,msgStr,'- Polynomial order 2');
        end
        if nb_points >= 10
            msgStr = cat(2,msgStr,'- Polynomial order 3');
        end
        if nb_points >= 12
            msgStr = cat(2,msgStr,'- Local weighted mean');
        end
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
    beadsSelect(h_fig);
    return
end

% store reference coordinates
ok = saveMapCoord(h_fig);
if ~ok
    return
end

% close mapping tool
h = guidata(h_fig);
delete(h.figure_map);
h = rmfield(h,'figure_map');
guidata(h_fig,h);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');
