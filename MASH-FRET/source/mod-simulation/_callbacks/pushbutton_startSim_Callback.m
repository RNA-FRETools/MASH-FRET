function pushbutton_startSim_Callback(obj, evd, h_fig)

% Last update by MH, 19.12.2019
% >> adapt code to new output argument of buildModel.m
%
% update by MH, 17.12.2019
% >> call updateMov.m from here and adapt code to new output arguments of 
%  updateMov.m (call plotExample.m and setSimCoordTable from here)

% Set GUI to proper values
updateFields(h_fig, 'sim');

% Simulate state sequences
ok = buildModel(h_fig);
if ~ok
    return
end

% Check for correct patterned background image
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
prm = p.proj{proj}.sim;

if prm.bgType == 3 % pattern
    [ok,prm] = checkBgPattern(prm, h_fig);
    if ~ok
        return
    end
    p.proj{proj}.sim = prm;
    h.param = p;
    guidata(h_fig, h);
end

% Calculate intensity state sequences and generate coordinates
[ok,actstr] = updateMov(h_fig);
if ~ok
    return
end

% Build and plot traces of first molecule in set and first frame in video
plotExample(h_fig);

h = guidata(h_fig);
dat = h.results.sim.dat{1};

% update actions
setContPan([cat(2,'Success: ',num2str(size(dat,2)),' state sequences ',...
    'have been successfully simulated!'),cat(2,'Intensity-time traces of ',...
    'the first molecule in the set, as well as the first frame in the ',...
    'video are shown in the respective axes.'),actstr],'success',h_fig);

% Set GUI to proper values
updateFields(h_fig, 'sim');
