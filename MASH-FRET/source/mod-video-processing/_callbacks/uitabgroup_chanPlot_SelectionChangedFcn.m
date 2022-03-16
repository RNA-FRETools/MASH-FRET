function uitabgroup_chanPlot_SelectionChangedFcn(obj,evd,h_fig)

n = find(obj.Children==obj.SelectedTab);

h = guidata(h_fig);

h.uitabgroup_VP_plot_vid.SelectedTab = ...
    h.uitabgroup_VP_plot_vid.Children(n);
h.uitabgroup_VP_plot_avimg.SelectedTab = ...
    h.uitabgroup_VP_plot_avimg.Children(n);