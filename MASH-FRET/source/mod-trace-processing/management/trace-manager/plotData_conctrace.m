function plotData_conctrace(h_axes,ind,h_fig)

% defaults
fcn_ovrAll_1 = {@axes_ovrAll_1_ButtonDownFcn,h_fig};

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
chanExc = p.proj{proj}.chanExc;
exc = p.proj{proj}.excitations;
nI0 = sum(chanExc>0);
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);
inSec = p.proj{proj}.time_in_sec;
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
    return
end

if ind<=(nChan*nExc+nI0+nFRET+nS) % single channel/FRET/S
    if ind<=(nChan*nExc) % channel intensity trace
        l = ceil(ind/nChan);
    elseif ind<=(nChan*nExc+nI0) % total intensity trace
        i = ind-nChan*nExc;
        [o,chans] = find(chanExc>0);
        c = chans(i);
        l = find(exc==chanExc(c));
    elseif ind<=(nChan*nExc+nI0+nFRET) % FRET trace
        n = ind-nChan*nExc-nI0;
        l = find(exc==chanExc(FRET(n,1)));
    else % S trace
        n = ind-nChan*nExc-nI0-nFRET;
        l = find(exc==chanExc(S(n,1)));
    end
    x_axis = l:nExc:nExc*size(dat1.trace{ind},1);
    if inSec
        x_axis = x_axis*expT;
    end
    plot(h_axes,x_axis,dat1.trace{ind}(:,1),'buttondownfcn',fcn,...
        'color',dat1.color{ind});
    xlim(h_axes, [x_axis(1) x_axis(end)]);
    if ind<=(nChan*nExc+nI0) % intensity
        ylim(h_axes, [min([min(dat1.trace{ind}(:,1)),0]) ...
            max(dat1.trace{ind}(:,1))]);
    else % ratio
        ylim(h_axes, [-0.2 1.2]);
    end
    xlabel(h_axes, dat1.xlabel);
    ylabel(h_axes, dat1.ylabel{ind});


elseif ind==(nChan*nExc+nI0+nFRET+nS+1) && (nChan>1 || nExc>1)% all intensities
    min_y = Inf;
    max_y = -Inf;
    for l = 1:nExc
        for c = 1:nChan
            %ind = (l-1)+c; % RB 2018-01-03: indizes/colour bug solved
            i = nChan*(l-1)+c;
            x_axis = l:nExc:nExc*size(dat1.trace{i}(:,1),1);
            if inSec
                x_axis = x_axis*expT;
            end
            plot(h_axes,x_axis,dat1.trace{i}(:,1),'color',dat1.color{i},...
                'buttondownfcn',fcn);
            min_y = min([min_y min(dat1.trace{i}(:,1))]);
            max_y = max([max_y max(dat1.trace{i}(:,1))]);

            % added by MH, 24.4.2019
            if l==1 && c==1
                set(h_axes,'nextplot','add');
            end
        end
    end
    set(h_axes,'nextplot','replacechildren');
    xlim(h_axes, [x_axis(1) x_axis(end)]);
    ylim(h_axes, [min([min_y,0]) max_y]);
    xlabel(h_axes, dat1.xlabel);
    ylabel(h_axes, dat1.ylabel{ind});
    
elseif ind==(nChan*nExc+nI0+nFRET+nS+(nChan>1 || nExc>1)+1) && nI0>1 % all total intensities
    min_y = Inf;
    max_y = -Inf;
    j = 0;
    for c = 1:nChan
        if chanExc(c)==0
            continue
        end
        j = j+1;
        i = nChan*nExc+j;
        l = find(exc==chanExc(c));
        x_axis = l:nExc:nExc*size(dat1.trace{i}(:,1),1);
        if inSec
            x_axis = x_axis*expT;
        end
        plot(h_axes,x_axis,dat1.trace{i}(:,1),'color',dat1.color{i},...
            'buttondownfcn',fcn);
        min_y = min([min_y min(dat1.trace{i}(:,1))]);
        max_y = max([max_y max(dat1.trace{i}(:,1))]);

        % added by MH, 24.4.2019
        if j==1
            set(h_axes,'nextplot','add');
        end
    end
    set(h_axes,'nextplot','replacechildren');
    xlim(h_axes, [x_axis(1) x_axis(end)]);
    ylim(h_axes, [min([min_y,0]) max_y]);
    xlabel(h_axes, dat1.xlabel);
    ylabel(h_axes, dat1.ylabel{ind});

elseif ind==(nChan*nExc+nI0+nFRET+nS+(nChan>1 || nExc>1)+(nI0>1)+1) && ...
        nFRET>1% all FRET
    for n = 1:nFRET
        i = nChan*nExc+nI0+n;
        ldon = find(exc==chanExc(FRET(n,1)));
        x_axis = ldon:nExc:nExc*size(dat1.trace{i}(:,1),1);
        if inSec
            x_axis = x_axis*expT;
        end
        plot(h_axes,x_axis,dat1.trace{i}(:,1),'color',dat1.color{i},...
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

elseif ind==(nChan*nExc+nI0+nFRET+nS+(nChan>1 || nExc>1)+(nI0>1)+...
        (nFRET>1)+1) && nS>1% all S
    for n = 1:nS
        i = nChan*nExc+nI0+nFRET+n;
        ldon = find(exc==chanExc(S(n,1)));
        x_axis = ldon:nExc:nExc*size(dat1.trace{i}(:,1),1);
        if inSec
            x_axis = x_axis*expT;
        end
        plot(h_axes,x_axis,dat1.trace{i}(:,1),'color',dat1.color{i},...
            'buttondownfcn',fcn);
        if n==1
            set(h_axes,'nextplot','add');
        end
    end
    set(h_axes,'nextplot','replacechildren');
    xlim(h_axes, [x_axis(1) x_axis(end)]);
    ylim(h_axes, [-0.2 1.2]);
    xlabel(h_axes, dat1.xlabel);
    ylabel(h_axes, dat1.ylabel{ind});

elseif ind==(nChan*nExc+nI0+nFRET+nS+(nChan>1 || nExc>1)+(nI0>1)+(nFRET>1)+...
        (nS>1)+1) && nFRET>0 && nS>0 % all FRET & S
    for n = 1:(nFRET+nS)
        i = nChan*nExc+nI0+n;
        if n<=nFRET
            ldon = find(exc==chanExc(FRET(n,1)));
        else
            ldon = find(exc==chanExc(S(n-nFRET,1)));
        end
        x_axis = ldon:nExc:nExc*size(dat1.trace{i}(:,1),1);
        if inSec
            x_axis = x_axis*expT;
        end
        plot(h_axes,x_axis,dat1.trace{i}(:,1),'color',dat1.color{i},...
            'buttondownfcn',fcn);
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

