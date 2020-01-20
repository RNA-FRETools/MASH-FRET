function molIncl = ud_popCalc(h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
exc = p.proj{proj}.excitations;
nExc = numel(exc);
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);

% get stored data
dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');

% get method settings
data = get(h.tm.popupmenu_selectData,'value');
j = get(h.tm.popupmenu_selectCalc,'value');

prm = [str2num(get(h.tm.edit_xrangeLow,'string')), ...
    str2num(get(h.tm.edit_xrangeUp,'string'));...
    str2num(get(h.tm.edit_yrangeLow,'string')), ...
    str2num(get(h.tm.edit_yrangeUp,'string'));...
    get(h.tm.popupmenu_units,'value')...
    get(h.tm.popupmenu_cond,'value');...
    str2num(get(h.tm.edit_conf1,'string')), ...
    str2num(get(h.tm.edit_conf2,'string'))];

% molecule selection at last update
slct = dat3.slct;
incl =  p.proj{proj}.bool_intensities(:,slct);

if j==1 % original time traces
    if data<=(nChan*nExc+nFRET+nS) % 1D
        trace = dat1.trace{data};
        
    else % 2D
        ind = data-nChan*nExc-nFRET-nS;
        data_e = ceil(ind/nS)+nChan*nExc;
        data_s = ind-(ceil(ind/nS)-1)*nS+nChan*nExc+nFRET;
        trace = [dat1.trace{data_e} dat1.trace{data_s}];
    end
    molIncl = molsWithConf(trace,'trace',prm,incl);
    
elseif j==6 % state trajectories
    if data<=(nChan*nExc+nFRET+nS) % 1D
        trace = dat3.val{data,j-1};
    else % 2D
        ind = data-nChan*nExc-nFRET-nS;
        data_e = ceil(ind/nS)+nChan*nExc;
        data_s = ind-(ceil(ind/nS)-1)*nS+nChan*nExc+nFRET;
        trace = [dat3.val{data_e,j-1} dat3.val{data_s,j-1}];
    end
    molIncl = molsWithConf(trace,'trace',prm,incl);
    
else % calculated values
    if data<=(nChan*nExc+nFRET+nS) % 1D
        values = dat3.val{data,j-1};
    else
        ind = data-nChan*nExc-nFRET-nS;
        data_e = ceil(ind/nS) + nChan*nExc;
        data_s = ind - (ceil(ind/nS)-1)*nS + nChan*nExc+nFRET;
        values = [dat3.val{data_e,j-1} dat3.val{data_s,j-1}] ;
    end
    molIncl = molsWithConf(values,'value',prm);
end
