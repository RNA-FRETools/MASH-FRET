function menu_map_export(obj,evd,h_fig)

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
