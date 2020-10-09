function menu_export_Callback(obj, evd, h_fig)

% Last update: by MH, 24.4.2019
% >> save tag colors
%
% update by FS, 24.4.2018
% >> save molecule tags and tag names
%
%

h = guidata(h_fig);

if ~h.mute_actions
    saveNclose = questdlg(['Do you want to export the traces to ' ...
        'MASH and close the trace manager?'], ...
        'Close and export to MASH-FRET', 'Yes', 'No', 'No');
    if ~strcmp(saveNclose, 'Yes')
        return
    end
end

p = h.param.ttPr;
proj = p.curr_proj;

% added by MH, 13.1.2020: reset ES histograms
if ~isequal(p.proj{proj}.coord_incl,h.tm.molValid) || ...
        ~isequal(p.proj{proj}.molTag,h.tm.molTag) || ...
        ~isequal(p.proj{proj}.molTagNames,h.tm.molTagNames)
    for i = 1:size(p.proj{proj}.ES,2)
        if ~(numel(p.proj{proj}.ES{i})==1 && isnan(p.proj{proj}.ES{i}))
            p.proj{proj}.ES{i} = [];
        end
    end
end

p.proj{proj}.coord_incl = h.tm.molValid;
p.proj{proj}.molTag = h.tm.molTag; % added by FS, 24.4.2018
p.proj{proj}.molTagNames = h.tm.molTagNames; % added by FS, 24.4.2018

% added by MH, 24.4.2019
p.proj{proj}.molTagClr = h.tm.molTagClr;

h.param.ttPr = p;
h.tm.ud = true;
guidata(h_fig,h);

updateFields(h.figure_MASH, 'ttPr');

close(h.tm.figure_traceMngr);


