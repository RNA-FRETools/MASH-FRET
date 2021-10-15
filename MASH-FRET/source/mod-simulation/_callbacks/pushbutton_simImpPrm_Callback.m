function pushbutton_simImpPrm_Callback(obj, evd, h_fig)
% pushbutton_simImpPrm_Callback([],[],h_fig)
% pushbutton_simImpPrm_Callback({pname,fname},[],h_fig)
%
% h_fig: handle to main figure
% pname: folder where preset file is located
% fname: preset file name

% update by MH, 18.12.2019: modify input & output arguments of impSimPrm according to new definition
% update by MH, 12.12.2019: show coordinates after loading pre-sets

% get source file
if ~iscell(obj)
    % open browser and ask for file
    [fname, pname, o] = uigetfile({'*.mat', 'Matlab file(*.mat)'; ...
        '*.*', 'All files(*.*)'}, 'Select a parameters file');
else
    % call from script routine: file is stored in the first input argument
    pname = obj{1};
    fname = obj{2};
    if pname(end)~=filesep
        pname = [pname,filesep];
    end
end
if ~(~isempty(fname) && sum(fname))
    return
end
cd(pname);

% import presets from file
impSimPrm(fname, pname, h_fig);

% set GUI to proper values
updateFields(h_fig, 'sim');

