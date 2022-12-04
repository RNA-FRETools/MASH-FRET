function pushbutton_startSim_Callback(obj, evd, h_fig)

% update by MH, 19.12.2019: adapt code to new output argument of buildModel.m
% update by MH, 17.12.2019: call updateMov.m from here and adapt code to new output arguments of updateMov.m (call plotExample.m and setSimCoordTable from here)

% Simulate state sequences
ok = buildModel(h_fig);
if ~ok
    return
end

% save sampling time in project parameters
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
p.proj{proj}.frame_rate = 1/p.proj{proj}.sim.prm.gen_dt{1}(4);
h.param = p;
guidata(h_fig,h);

% Check for correct patterned background image
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

% Calculate intensity state sequences and generate coordinates
[ok,actstr] = updateMov(h_fig);
if ~ok
    return
end

% build traces of first molecule and first video frame
refreshPlotExample(h_fig);

% plot data
plotData_sim(h_fig);

h = guidata(h_fig);
p = h.param;
dat = p.proj{proj}.sim.prm.res_dt{1};

% update actions
setContPan([cat(2,'Success: ',num2str(size(dat,3)),' state sequences ',...
    'have been successfully simulated!'),cat(2,'Intensity-time traces of ',...
    'the first molecule in the set, as well as the first frame in the ',...
    'video are shown in the respective axes.'),actstr],'success',h_fig);

% bring trajectory plot tab front
bringPlotTabFront('Straj',h_fig);

% Set GUI to proper values
updateFields(h_fig, 'sim');
