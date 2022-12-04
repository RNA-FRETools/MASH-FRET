function checkbox_molNb_Callback(obj, evd, h_fig)

% Last update by MH, 24.4.2019
% >> allow molecule tagging even if the molecule unselected
%
% update: FS, 24.4.2018
% >> deactivate the label popupmenu if the molecule is not selected
%
%

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
isBot = nFRET | nS;

mol = str2num(get(obj, 'String'));
[o,ind_h,o] = find(h.tm.checkbox_molNb == obj);
h.tm.molValid(mol) = logical(get(obj, 'Value'));
guidata(h_fig, h);

if get(obj, 'Value')
    shad = [1 1 1];
else
    shad = get(h.tm.checkbox_molNb(ind_h), 'BackgroundColor');
end
set([h.tm.axes_itt(ind_h), h.tm.axes_itt_hist(ind_h)], 'Color', shad);
if isBot
    set([h.tm.axes_frettt(ind_h), h.tm.axes_hist(ind_h)], 'Color', ...
        shad);
end
    
    % deactivate the popupmenu if the molecule is not selected
    % added by FS, 24.4.2018
    % cancelled by MH, 24.4.2019: allow labelling even if not selected
%     if h.tm.molValid(mol) == 0
%         set(h.tm.popup_molNb(ind_h), 'Enable', 'off', 'Value', 1)
%         h.tm.molTag(mol) = 1;
%         guidata(h_fig, h)
%     else
%         set(h.tm.popup_molNb(ind_h), 'Enable', 'on')
%     end

% update plot in "Video view"
plotData_videoView(h_fig);

