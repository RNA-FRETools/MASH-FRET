function ok = pushbutton_updateSim_Callback(obj, evd, h_fig)

% Last update by MH, 17.12.2019
% >> adapt code to new output arguments of updateMov.m (call plotExample.m
%  and setSimCoordTable from here)

% Set GUI to proper values
updateFields(h_fig, 'sim');

% Check for correct patterned background image
h = guidata(h_fig);
if h.param.sim.bgType == 3 % pattern
    p = h.param.sim;
    [ok,p] = checkBgPattern(p, h_fig);
    if ~ok
        return
    end
    h.param.sim = p;
    guidata(h_fig, h);
end

% Calculate intensity state sequences and generate coordinates
[ok,actstr] = updateMov(h_fig);
if ~ok
    return
end

% Build and plot traces of first molecule in set and first frame in video
plotExample(h_fig);

% update actions
setContPan([cat(2,'Success: molecule coordinates and sample heterogeneity',...
    ' (parameter deviations) in state sequences have been successfully ',...
    'refreshed!'),cat(2,'Intensity-time traces of the first molecule in ',...
    'the set, as well as the first frame in the video, have been re-built',...
    ' and re-plot in the respective axes.'),actstr],'success',h_fig);

% Set GUI to proper values
updateFields(h_fig, 'sim');
