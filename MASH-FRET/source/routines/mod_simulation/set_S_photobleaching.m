function set_S_photobleaching(pb,t,h_fig)
% set_S_photobleaching(pb,t,h_fig)
%
% Set photobleaching parameters to proper values and update interface
%
% pb: 1 to apply photobelaching, 0 to keep initial trace length
% t: photobleaching exponential time constant
% h_fig: handle to main figure

h = guidata(h_fig);

set(h.checkbox_simBleach,'value',pb);

if pb
    set(h.edit_simBleach,'string',num2str(t));
    edit_simBleach_Callback(h.edit_simBleach,[],h_fig);
end