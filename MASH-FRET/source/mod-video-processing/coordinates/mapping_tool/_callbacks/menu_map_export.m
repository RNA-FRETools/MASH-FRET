function menu_map_export(obj,evd,h_fig)
% menu_map_export([],[],h_fig)
% menu_map_export(file,[],h_fig)
%
% h_fig: handle to main figure
% file: {1-by-2} cell array with:
%  file{1}: file locations
%  file{2}: file name

if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if pname(end)~=filesep
        pname = [pname,filesep];
    end
    exportMapCoord(h_fig,pname,fname);
else
    exportMapCoord(h_fig);
end
