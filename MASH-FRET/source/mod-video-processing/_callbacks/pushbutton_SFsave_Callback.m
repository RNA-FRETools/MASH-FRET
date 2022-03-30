function pushbutton_SFsave_Callback(obj, evd, h_fig)
% pushbutton_SFsave_Callback([],[],h_fig)
% pushbutton_SFsave_Callback(file_out,[],h_fig)
%
% h_fig: handle to main figure
% file_out: {1-by-2} destination folder and file for spots coordinates

% collect interface parameters
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.VP.curr;
def = p.proj{p.curr_proj}.VP.def;
meth = curr.gen_crd{2}{1}(1);
coordsf = curr.gen_crd{2}{5};

% control SF coordinates
if isequal(coordsf,def.gen_crd{2}{5})
    setContPan('Start a "spotfinder" procedure first.','error',h_fig);
    return
end

% control SF method
if meth<=1
    return
end

% save spots coordinates to file
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
    coordfile = saveSpots(p,h_fig,pname,fname);
else
    coordfile = saveSpots(p,h_fig);
end
if isempty(coordfile)
    return
end
