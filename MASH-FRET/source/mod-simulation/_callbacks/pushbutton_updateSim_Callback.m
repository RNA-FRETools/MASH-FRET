function ok = pushbutton_updateSim_Callback(obj, evd, h_fig)

% update 17.12.2019 by MH: adapt code to new output arguments of updateMov.m (call plotExample.m and setSimCoordTable from here)

% check for correct patterned background image
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
curr = p.proj{proj}.sim.curr;
if curr.gen_dat{8}{1}==3 % pattern
    [ok,curr] = checkBgPattern(curr, h_fig);
    if ~ok
        return
    end
    p.proj{proj}.sim.curr = curr;
    h.param = p;
    guidata(h_fig, h);
end

% calculate intensity state sequences and generate coordinates
[ok,actstr] = updateMov(h_fig);
if ~ok
    return
end

% build traces of first molecule and first video frame
refreshPlotExample(h_fig);

% plot data
plotData_sim(h_fig);

% update actions
setContPan([cat(2,'Success: molecule coordinates and sample heterogeneity',...
    ' (parameter deviations) in state sequences have been successfully ',...
    'refreshed!'),cat(2,'Intensity-time traces of the first molecule in ',...
    'the set, as well as the first frame in the video, have been re-built',...
    ' and re-plot in the respective axes.'),actstr],'success',h_fig);

% Set GUI to proper values
updateFields(h_fig, 'sim');
