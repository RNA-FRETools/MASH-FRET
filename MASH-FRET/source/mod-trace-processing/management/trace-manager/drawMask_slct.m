function drawMask_slct(h_fig)
% Draw mask over data in plot 1

% defaults
clr = [0.5,0.5,0.5];
a = 0.5;
fcn = {@axes_ovrAll_1_ButtonDownFcn,h_fig};

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
nExc = p.proj{proj}.nb_excitations;
incl = p.proj{proj}.bool_intensities;
inSec = p.proj{proj}.time_in_sec;
expT = p.proj{proj}.resampling_time; % this is truely the exposure time
dat3 = get(h.tm.axes_histSort,'userdata');
mol = str2num(get(h.tm.checkbox_molNb(1),'string'));
mol_disp = str2num(get(h.tm.edit_nbTotMol,'string'));

% get plot coordinates
xaxis = get(h.tm.axes_ovrAll_1,'xlim');
yaxis = get(h.tm.axes_ovrAll_1,'ylim');
L = sum(sum(incl(:,dat3.slct(1:mol-1))))*nExc;
if inSec
    T = L*expT;
else
    T = L;
end
xdata = [xaxis(1)-1 T];
ydata = [yaxis(2)+1 yaxis(2)+1];
for m = mol:mol+mol_disp-1
    if m<=numel(dat3.slct) && dat3.slct(m)

        % append x data
        L = L + sum(incl(:,m))*nExc;
        if inSec
            T = L*expT;
        else
            T = L;
        end
        xdata = [xdata,xdata(end),T];
        ydata = [ydata,yaxis(1)-1,yaxis(1)-1];
    end
end
xdata = [xdata,xdata(end),xaxis(2)+1];
ydata = [ydata,yaxis(2)+1,yaxis(2)+1];

if isfield(h.tm,'area_slct') && ishandle(h.tm.area_slct)
    set(h.tm.area_slct,'xdata',xdata,'ydata',ydata,'basevalue',yaxis(1)-1);
else
    set(h.tm.axes_ovrAll_1,'nextplot','add');
    h.tm.area_slct = area(h.tm.axes_ovrAll_1,xdata,ydata,'linestyle','none',...
        'facecolor',clr,'facealpha',a,'buttondownfcn',fcn,'basevalue',...
        yaxis(1)-1);
    set(h.tm.axes_ovrAll_1,'nextplot','replacechildren');
    guidata(h_fig,h);
end

