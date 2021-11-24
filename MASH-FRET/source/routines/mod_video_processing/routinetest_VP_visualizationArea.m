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

% test sliding bar
n = get(h.slider_img,'value');
set(h.slider_img,'value',n+1);
slider_img_Callback(h.slider_img,[],h_fig);

% test graph export and zoom reset
disp(cat(2,prefix,'test graph export and zoom reset...'));
h_axes = getHandleWithPropVal(h.uipanel_VP,'Type','axes');
for ax = 1:numel(h_axes)
    set(h_fig,'CurrentAxes',h_axes(ax));
    exportAxes({[p.dumpdir,filesep,p.exp_axes,'_',num2str(ax)]},[],h_fig);
    ud_zoom([],[],'reset',h_fig);
end

% test "Create trace" cursor
disp(cat(2,prefix,'test "Create trace" cursor...'));
switchMovTool(h.togglebutton_target, [], h_fig);

h = guidata(h_fig);
proj = h.param.proj{h.param.curr_proj};
pixDim = proj.VP.curr.gen_int{3}(1);
x = pixDim+ceil(rand(1)*(proj.movie_dim(1)-2*pixDim))-0.5;
y = pixDim+ceil(rand(1)*(proj.movie_dim(2)-2*pixDim))-0.5;
pointITT({[x,y],[p.dumpdir,filesep,p.tracecurs_file]}, [], h_fig);

