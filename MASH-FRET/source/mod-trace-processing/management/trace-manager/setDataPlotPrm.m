function setDataPlotPrm(h_fig)
% Assign data-specific plot colors and axis labels

% defaults
def_niv = 200;

% get project parameters
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
clr = p.proj{proj}.colours;
perSec = p.proj{proj}.fix{2}(4);
perPix = p.proj{proj}.fix{2}(5);
inSec = p.proj{proj}.fix{2}(7);

% get existing plot data
dat1 = get(h.tm.axes_ovrAll_1,'UserData');
dat2 = get(h.tm.axes_ovrAll_2,'UserData');
dat3 = get(h.tm.axes_histSort,'UserData');

% initializes interval number
nCalc = numel(get(h.tm.popupmenu_selectCalc,'string'))-1;
dat1.niv = repmat(def_niv,nChan*nExc+nFRET+nS+nFRET*nS,2);
dat3.niv = repmat(def_niv,nChan*nExc+nFRET+nS+nFRET*nS,2,nCalc);

% initializes plot parameters
dat1.color = cell(1,nChan*nExc+nFRET+nS);
dat1.ylabel = cell(1,nChan*nExc+nFRET+nS+4);
if inSec
    dat1.xlabel = 'time (s)';
else
    dat1.xlabel = 'frame number';
end

% define y-axis labels
str_extra = [];
if perSec
    str_extra = [str_extra ' per s.'];
end
if perPix
    str_extra = [str_extra ' per pix.'];
end

% set plot colors and axis labels
i = 0;
for l = 1:nExc % number of excitation channels
    for c = 1:nChan % number of emission channels
        i = i + 1;
        dat1.ylabel{i} = ['counts' str_extra];
        dat2.ylabel{i} = 'freq. counts'; % RB 2018-01-04
        dat2.xlabel{i} = ['counts' str_extra]; % RB 2018-01-04
        dat1.color{i} = clr{1}{l,c};
    end
end
for n = 1:nFRET
    i = i + 1;
    dat1.ylabel{i} = 'FRET';
    dat2.ylabel{i} = 'freq. counts'; % RB 2018-01-04
    dat2.xlabel{i} = 'FRET'; % RB 2018-01-04
    dat1.color{i} = clr{2}(n,:);
end
for n = 1:nS
    i = i + 1;
    dat1.ylabel{i} = 'S';
    dat2.ylabel{i} = 'freq. counts'; % RB 2018-01-04
    dat2.xlabel{i} = 'S'; % RB 2018-01-04
    dat1.color{i} = clr{3}(n,:);
end
if nChan > 1 || nExc > 1
    i = i + 1;
    dat1.ylabel{i} = ['counts' str_extra];
    % no dat2.xlabel{size(str_plot,2)} = ['counts' str_extra]; % RB 2018-01-04
end
if nFRET > 1
    i = i + 1;
    dat1.ylabel{i} = 'FRET';
    % no dat2.xlabel{size(str_plot,2)} = 'FRET'; % RB 2018-01-04
end
% String for all Stoichiometry Channels in popup menu
if nS > 1
    i = i + 1;
    dat1.ylabel{i} = 'S';
    % no dat2.xlabel{size(str_plot,2)} = 'S'; % RB 2018-01-04
end
% String for all FRET and Stoichiometry Channels in popup menu
if nFRET > 0 && nS > 0
    i = i + 1;
    dat1.ylabel{i} = 'FRET or S';
    % no dat2.xlabel{size(str_plot,2)} = 'FRET or S'; % RB 2018-01-04
end
i = 0;
for fret = 1:nFRET
    for s = 1:nS
        i = i + 1;
        % no dat1.ylabel{nChan*nExc+nFRET+nS+n} = 'FRET or S'; % RB 2018-01-04
        dat2.ylabel{nChan*nExc+nFRET+nS+i} = 'S'; % RB 2018-01-04: change index as str_plot and str_plot2 are different
        dat2.xlabel{nChan*nExc+nFRET+nS+i} = 'E'; % RB 2018-01-04: change index as str_plot and str_plot2 are different
    end
end

set(h.tm.axes_ovrAll_1,'UserData',dat1);
set(h.tm.axes_ovrAll_2,'UserData',dat2);
set(h.tm.axes_histSort,'UserData',dat3);
    
