function setDataPlotPrm(h_fig)
% Assign data-specific plot colors and axis labels

% defaults
def_niv = 50;

% get project parameters
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
exc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;
nI0 = sum(chanExc>0);
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
clr = p.proj{proj}.colours;
perSec = p.proj{proj}.TP.fix{2}(4);
perPix = p.proj{proj}.TP.fix{2}(5);
inSec = p.proj{proj}.TP.fix{2}(7);

% get existing plot data
dat1 = get(h.tm.axes_ovrAll_1,'UserData');
% dat2 = get(h.tm.axes_ovrAll_2,'UserData'); % cancelled by MH, 21.1.2020
dat3 = get(h.tm.axes_histSort,'UserData');

% initializes interval number
nCalc = numel(get(h.tm.popupmenu_selectXval,'string'))-1;
dat1.niv = repmat(def_niv,1,nChan*nExc+nI0+nFRET+nS); % traces
dat3.niv = repmat(def_niv,nCalc,nChan*nExc+nI0+nFRET+nS);
dat3.label = cell(nChan*nExc+nI0+nFRET+nS,nCalc);
label_calc = {'%s','%s','%s','%s','%s','number of states',...
    'number of state transitions','dwell time (s)','%s','dwell time (s)'};

% initializes plot parameters
dat1.color = cell(1,nChan*nExc+nI0+nFRET+nS);
dat1.ylabel = cell(1,nChan*nExc+nI0+nFRET+nS+4);
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
%         dat2.ylabel{i} = 'freq. counts'; % RB 2018-01-04
%         dat2.xlabel{i} = ['counts' str_extra]; % RB 2018-01-04
        dat1.color{i} = clr{1}{l,c};
        for j = 1:nCalc
            dat3.label{i,j} = sprintf(label_calc{j},dat1.ylabel{i});
        end
    end
end
for c = 1:nChan
    if chanExc(c)==0
        continue
    end
    i = i + 1;
    l = find(exc==chanExc(c),1);
    dat1.ylabel{i} = ['counts' str_extra];
    dat1.color{i} = clr{1}{l,c};
    for j = 1:nCalc
        dat3.label{i,j} = sprintf(label_calc{j},dat1.ylabel{i});
    end
end
for n = 1:nFRET
    i = i + 1;
    dat1.ylabel{i} = 'FRET';
    
    % cancelled by MH, 21.1.2020
%     dat2.ylabel{i} = 'freq. counts'; % RB 2018-01-04
%     dat2.xlabel{i} = 'FRET'; % RB 2018-01-04

    dat1.color{i} = clr{2}(n,:);
    for j = 1:nCalc
        dat3.label{i,j} = sprintf(label_calc{j},dat1.ylabel{i});
    end
end
for n = 1:nS
    i = i + 1;
    dat1.ylabel{i} = 'S';
    
    % cancelled by MH, 21.1.2020
%     dat2.ylabel{i} = 'freq. counts'; % RB 2018-01-04
%     dat2.xlabel{i} = 'S'; % RB 2018-01-04

    dat1.color{i} = clr{3}(n,:);
    for j = 1:nCalc
        dat3.label{i,j} = sprintf(label_calc{j},dat1.ylabel{i});
    end
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

% cancelled by MH, 21.1.2020
% i = 0;
% for fret = 1:nFRET
%     for s = 1:nS
%         i = i + 1;
%         % no dat1.ylabel{nChan*nExc+nFRET+nS+n} = 'FRET or S'; % RB 2018-01-04
%         dat2.ylabel{nChan*nExc+nFRET+nS+i} = 'S'; % RB 2018-01-04: change index as str_plot and str_plot2 are different
%         dat2.xlabel{nChan*nExc+nFRET+nS+i} = 'E'; % RB 2018-01-04: change index as str_plot and str_plot2 are different
%     end
% end

set(h.tm.axes_ovrAll_1,'UserData',dat1);
% set(h.tm.axes_ovrAll_2,'UserData',dat2); % cancelled by MH, 21.1.2020
set(h.tm.axes_histSort,'UserData',dat3);
    
