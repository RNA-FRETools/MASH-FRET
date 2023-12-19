function ud_histImportOpt(h_fig)

h = guidata(h_fig);
proj = h_fig.UserData;
opt = proj.hist_import_opt;

% collect import options
xcol = opt(3);
pcol = opt(4); 

% adjust columns nb to last file size
fdat = [];
if isfield(h,'tab_fstrct') && ishandle(h.tab_fstrct)
    fdat = h.table_fstrct.UserData;
end
isfdat = ~isempty(fdat);
if isfdat
    C = size(fdat,2);
    xcol(xcol==0 | xcol>C) = C;
    pcol(pcol==0 | pcol>C) = C;
end

% save modifications
opt(3) = xcol;
opt(4) = pcol; 

% save modifications
proj.hist_import_opt = opt;
h_fig.UserData = proj;

