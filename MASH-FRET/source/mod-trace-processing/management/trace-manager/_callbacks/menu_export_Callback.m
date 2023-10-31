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

p = h.param;
proj = p.curr_proj;

tmchanged = false;
if ~isequal(p.proj{proj}.coord_incl,h.tm.molValid) || ...
        ~isequal(p.proj{proj}.molTag,h.tm.molTag) || ...
        ~isequal(p.proj{proj}.molTagNames,h.tm.molTagNames)
    tmchanged = true;
end

% reset ES histograms
if tmchanged
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

% resets HA and TA analysis
if tmchanged
    p = importHA(p,p.curr_proj);
    p = importTA(p,p.curr_proj);
end

% save tag names and colors as defaults
p.es.tagNames = p.proj{proj}.molTagNames;
p.es.tagClr = p.proj{proj}.molTagClr;

h.param = p;
h.tm.ud = true;
guidata(h_fig,h);

updateFields(h_fig);

close(h.tm.figure_traceMngr);


