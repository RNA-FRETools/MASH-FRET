function ok = pushbutton_exportSim_Callback(obj, evd, h_fig)

% % Check for correct patterned background image
% h = guidata(h_fig);
% if h.param.sim.bgType == 3 % pattern
%     p = h.param.sim;
%     [ok,p] = checkBgPattern(p, h_fig);
%     if ~ok
%         return
%     end
%     h.param.sim = p;
%     guidata(h_fig, h);
% end

% % Calculate intensity state sequences and generate coordinates
% [ok,actstr1] = updateMov(h_fig);
% if ~ok
%     return
% end

if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if pname(end)~=filesep
        pname = [pname,filesep];
    end
    [ok,actstr2] = exportResults(h_fig,pname,fname);
else
    [ok,actstr2] = exportResults(h_fig);
end
if ~ok
    return
end

% update actions
% setContPan(cat(2,'Success! Simulated data have been exported to files:',...
%     actstr1,actstr2),'success',h_fig);
setContPan(cat(2,'Success! Simulated data have been exported to files:',...
    actstr2),'success',h_fig);

% set fields to proper values
updateFields(h_fig, 'sim');
