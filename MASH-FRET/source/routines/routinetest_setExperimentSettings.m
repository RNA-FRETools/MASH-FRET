function routinetest_setExperimentSettings(h_fig0,p,opt,prefix)
% routinetest_setExperimentSettings(h_fig0,p,opt,prefix)
%
% Set experiment settings to proper values.
%
% h_fig0: handle to main figure
% p: structure containing experiment settings
% opt: 'sim', 'video', 'trajectories' or 'edit'
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% collect interface parameters
h0 = guidata(h_fig0);
if ~(isfield(h0,'figure_setExpSet') && ishandle(h0.figure_setExpSet))
    disp('No experiment settings window detected.');
    return
end
h_fig = h0.figure_setExpSet;
h = guidata(h_fig);

% test "Channels" tab
if isfield(h,'tab_chan') && ishandle(h.tab_chan)
    routinetest_setExpSet_channels(h_fig0,p);
    push_setExpSet_next(h.push_nextChan,[],h_fig,2);
end

% test "Import" tab
if isfield(h,'tab_imp') && ishandle(h.tab_imp)
    routinetest_setExpSet_import(h_fig0,p,prefix);
    push_setExpSet_next(h.push_nextImp,[],h_fig,1);
end

% set "Lasers" tab
if isfield(h,'tab_exc') && ishandle(h.tab_exc)
    routinetest_setExpSet_lasers(h_fig0,p);
    push_setExpSet_next(h.push_nextExc,[],h_fig,3);
end

% set "Calculations" tab
if isfield(h,'tab_calc') && ishandle(h.tab_calc)
    routinetest_setExpSet_calc(h_fig0,p);
    push_setExpSet_next(h.push_nextCalc,[],h_fig,4);
end

% set "File structure" tab
if isfield(h,'tab_fstrct') && ishandle(h.tab_fstrct)
    routinetest_setExpSet_fstrct(h_fig0,p);
    push_setExpSet_next(h.push_nextFstrct,[],h_fig,5);
end

% set "Divers" tab
routinetest_setExpSet_divers(h_fig0,p);

% save & close
push_setExpSet_save(h.push_save,[],opt,h_fig,h_fig0);
