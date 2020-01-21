function traceManager(h_fig)
% traceManager(h_fig)
%
% Enables trace selection upon visual inspection or defined criteria 
% "h_fig" >> handle to the main figure

% Last update by MH, 25.4.2019
% >> move molecule selection here
%
% update: by MH, 24.4.2019
% >> add tag colors
%
% update: by FS, 24.4.2018
% >> add molecule tags
   
h = guidata(h_fig);
h.tm.ud = false;
guidata(h_fig,h);

p = h.param.ttPr;
proj = p.curr_proj;

% molecule tags, added by FS, 24.4.2018
h.tm.molTagNames = p.proj{proj}.molTagNames;
h.tm.molTag = p.proj{proj}.molTag;

% added by MH, 24.4.2019
h.tm.molTagClr = p.proj{proj}.molTagClr;

% added by MH, 25.4.2019
h.tm.molValid = p.proj{proj}.coord_incl;

% added byMH, 26.4.2019
h.tm.rangeTag = [];

guidata(h_fig, h);

if ~(isfield(h.tm, 'figure_traceMngr') && ...
        ishandle(h.tm.figure_traceMngr))
    ok = loadData2Mngr(h_fig);
    if ~ok
        h = guidata(h_fig);
        if ishandle(h.tm.figure_traceMngr)
            close(h.tm.figure_traceMngr);
            return;
        end
    end
end

