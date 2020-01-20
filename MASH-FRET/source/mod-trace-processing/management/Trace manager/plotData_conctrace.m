function plotData_conctrace(h_axes,ind,h_fig)

% defaults
fcn_ovrAll_1 = {@axes_ovrAll_1_ButtonDownFcn,h_fig};

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);
inSec = p.proj{proj}.fix{2}(7);
expT = p.proj{proj}.frame_rate; % this is truely the exposure time

if h_axes==h.tm.axes_ovrAll_1
    fcn = fcn_ovrAll_1;
else
    fcn = {}; 
end

cla(h_axes);

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');

if ~sum(dat3.slct)
    return;
end

if ind<=nChan*nExc+nFRET+nS % single channel/FRET/S
    x_axis = 1:size(dat1.trace{ind},1);
    if inSec
        x_axis = x_axis*expT;
    end
    plot(h_axes,x_axis,dat1.trace{ind},'buttondownfcn',fcn,...
        'color',dat1.color{ind});
    xlim(h_axes, [x_axis(1) x_axis(end)]);
    if ind <= nChan*nExc
        ylim(h_axes, [min(dat1.trace{ind}) ...
            max(dat1.trace{ind})]);
    else
        ylim(h_axes, [-0.2 1.2]);
    end
    xlabel(h_axes, dat1.xlabel);
    ylabel(h_axes, dat1.ylabel{ind});


elseif ind==nChan*nExc+nFRET+nS+1 && nChan>1% all intensities
    x_axis = 1:size(dat1.trace{1},1);
    if inSec
        x_axis = x_axis*expT;
    end
    min_y = Inf;
    max_y = -Inf;
    for l = 1:nExc
        for c = 1:nChan
            %ind = (l-1)+c; % RB 2018-01-03: indizes/colour bug solved
            ind = 2*(l-1)+c;
            plot(h_axes,x_axis,dat1.trace{ind},'color',dat1.color{ind},...
                'buttondownfcn',fcn);
            min_y = min([min_y min(dat1.trace{ind})]);
            max_y = max([max_y max(dat1.trace{ind})]);

            % added by MH, 24.4.2019
            if l==1 && c==1
                set(h_axes,'nextplot','add');
            end
        end
    end
    set(h_axes,'nextplot','replacechildren');
    xlim(h_axes, [x_axis(1) x_axis(end)]);
    ylim(h_axes, [min_y max_y]);
    xlabel(h_axes, dat1.xlabel);
    ylabel(h_axes, dat1.ylabel{ind});

elseif ind==nChan*nExc+nFRET+nS+2 && nFRET>1% all FRET
    x_axis = 1:size(dat1.trace{nChan*nExc+1},1);
    if inSec
        expT = p.proj{proj}.frame_rate;
        x_axis = x_axis*expT;
    end
    for n = 1:nFRET
        ind = nChan*nExc+n;
        plot(h_axes,x_axis,dat1.trace{ind},'color',dat1.color{ind},...
            'buttondownfcn',fcn);
        % added by MH, 24.4.2019
        if n==1
            set(h_axes,'nextplot','add');
        end
    end
    set(h_axes,'nextplot','replacechildren');
    xlim(h_axes, [x_axis(1) x_axis(end)]);
    ylim(h_axes, [-0.2 1.2]);
    xlabel(h_axes, dat1.xlabel);
    ylabel(h_axes, dat1.ylabel{ind});

elseif (ind==nChan*nExc+nFRET+nS+2 && nFRET==1 && nS>1) || ...
        (ind==nChan*nExc+nFRET+nS+3 && nFRET>1 && nS>1)% all S
    x_axis = 1:size(dat1.trace{nChan*nExc+nFRET+1},1);
    if inSec
        expT = p.proj{proj}.frame_rate;
        x_axis = x_axis*expT;
    end
    for n = 1:nS
        ind = nChan*nExc+nFRET+n;
        plot(h_axes,x_axis,dat1.trace{ind},'color',...
            dat1.color{ind},'buttondownfcn',fcn);
        if n==1
            set(h_axes,'nextplot','add');
        end
    end
    set(h_axes,'nextplot','replacechildren');
    xlim(h_axes, [x_axis(1) x_axis(end)]);
    ylim(h_axes, [-0.2 1.2]);
    xlabel(h_axes, dat1.xlabel);
    ylabel(h_axes, dat1.ylabel{ind});

elseif (ind==nChan*nExc+nFRET+nS+2 && nFRET==1 && nS==1) || ...
        (ind==nChan*nExc+nFRET+nS+3 && ((nFRET>1 && nS==1) ...
        || (nFRET==1 && nS>1))) || ...
        (ind==nChan*nExc+nFRET+nS+4 && nFRET>1 && nS>1) % all FRET & S
    x_axis = 1:size(dat1.trace{nChan*nExc+1},1);
    if inSec
        x_axis = x_axis*expT;
    end
    for n = 1:(nFRET+nS)
        ind = nChan*nExc+n;
        plot(h_axes,x_axis,dat1.trace{ind},'color',...
            dat1.color{ind},'buttondownfcn',fcn);
        if n==1
            set(h_axes,'nextplot','add');
        end
    end
    set(h_axes,'nextplot','replacechildren');
    xlim(h_axes, [x_axis(1) x_axis(end)]);
    ylim(h_axes, [-0.2 1.2]);
    xlabel(h_axes, dat1.xlabel);
    ylabel(h_axes, dat1.ylabel{ind});
end

