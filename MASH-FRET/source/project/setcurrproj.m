function setcurrproj(h_fig)
% setcurrproj(h_fig)
%
% Get current project index in project list and check whether it is out of
% range. If yes, the last project in the list is made current and project 
% list is updated.

% collect interface parameters
h = guidata(h_fig);
p = h.param;

% modify current project index if it is out of range of the list
nProj = numel(p.proj);
if p.curr_proj>nProj
    setContPan(['Current project index is out of range: it will now be ',...
        'set to the last index in list.'],'warning',h_fig);
    set(h.listbox_projLst,'value',nProj)
    listbox_projLst_Callback(h.listbox_projLst,[],h_fig);
end
