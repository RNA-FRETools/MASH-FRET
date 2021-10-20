function push_setExpSet_save(obj,evd,h_fig,h_fig0)

% recover project settings from options window
h_fig0.UserData = h_fig.UserData;

% close options window
figure_setExpSet_CloseRequestFcn([],[],h_fig,h_fig0,1);