function routinetest_VP_visualizationArea(h_fig,p,prefix)
% routinetest_VP_visualizationArea(h_fig,p,prefix)
%
% Tests import of different video/image file format and test zoom/"Create trace" cursors
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_VP
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% collect interface parameters
h = guidata(h_fig);

% test video import
disp(cat(2,prefix,'test video import...'));
nvid = size(p.vid_files,2);
for f = [2:nvid,1]
    disp(cat(2,prefix,'>> import of ',p.vid_files{f},'...'));
    pushbutton_loadMov_Callback({p.annexpth,p.vid_files{f}},[],h_fig);
end

% test "Create trace" cursor
disp(cat(2,prefix,'test "Create trace" cursor...'));
switchMovTool(h.togglebutton_target, [], h_fig);

h = guidata(h_fig);
pixDim = h.param.movPr.itg_dim;
x = pixDim+ceil(rand(1)*(h.movie.pixelX-2*pixDim))-0.5;
y = pixDim+ceil(rand(1)*(h.movie.pixelY-2*pixDim))-0.5;
pointITT({[x,y],[p.dumpdir,filesep,p.tracecurs_file]}, [], h_fig);

