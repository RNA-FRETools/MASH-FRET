function drawMask_subpop(h_fig,molIncl)

% defaults
clr = [0.5 0.5 0.5];
a = 0.5;

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
nExc = p.proj{proj}.nb_excitations;
incl = p.proj{proj}.bool_intensities;
inSec = p.proj{proj}.TP.fix{2}(7);
expT = p.proj{proj}.frame_rate; % this is truely the exposure time

if isfield(h.tm,'area_subpop')
    if ishandle(h.tm.area_subpop)
        delete(h.tm.area_subpop);
    end
    h.tm.area_subpop = [];
end

M = numel(molIncl);
yaxis = get(h.tm.axes_traceSort,'ylim');

% initialize x & y data
xdata = 0;
ydata = yaxis(1)-1;
L = 0; T = 0;
for m = 1:M
    if ~molIncl(m)
        xdata = [xdata,T];
        ydata = [ydata,yaxis(2)+1];    
    else
        xdata = [xdata,T];
        ydata = [ydata,yaxis(1)-1];    
    end
    
    L = L + sum(incl(:,m))*nExc;
    if inSec
        T = L*expT;
    else
        T = L;
    end
    
    if ~molIncl(m)
        xdata = [xdata,T];
        ydata = [ydata,yaxis(2)+1];    
    else
        xdata = [xdata,T];
        ydata = [ydata,yaxis(1)-1];    
    end
    
end

set(h.tm.axes_traceSort,'nextplot','add');
h.tm.area_subpop = area(h.tm.axes_traceSort,xdata,ydata,'linestyle','none',...
    'facecolor',clr,'facealpha',a,'basevalue',yaxis(1)-1);
set(h.tm.axes_traceSort,'nextplot','replacechildren');
guidata(h_fig,h);
