function molIncl = ud_popCalc(h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;

% get stored data
dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');

% initialize return variable
N = numel(dat3.slct);
molIncl = false(1,N);

% get method settings
datax = get(h.tm.popupmenu_selectXdata,'value');
datay = get(h.tm.popupmenu_selectYdata,'value')-1;
jx = get(h.tm.popupmenu_selectXval,'value')-1;
jy = get(h.tm.popupmenu_selectYval,'value')-1;

is2D = datay>0;
isTDP = (datax==datay & jx==9 & jy==9);

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

if isTDP
    trace_x = dat3.val{datax,jx};
    trace_y = [dat3.val{datay,jy}(2:end,:);dat3.val{datay,jy}(end,:)];
    trace = [trace_x,trace_y];
else
    if jx==0 % original time traces
        trace_x = dat1.trace{datax};
    else
        trace_x = dat3.val{datax,jx};
    end
    if is2D
        % control coherence of x- and y-data
        if ~checkXYdataCoherence(datax,datay,jx,jy)
            return
        end
        if jy==0 % original time traces
            trace_y = dat1.trace{datay};
        else
            trace_y = dat3.val{datay,jy};
        end
        trace = [trace_x trace_y];
    else
        trace = trace_x;
    end
end

if (is2D && sum(jx==[0,1]) && sum(jy==[0,1])) || ...
        (~is2D && sum(jx==[0,1])) % frame-wise data
    molIncl = molsWithConf(trace,'trace',prm,incl);
elseif (is2D && sum(jx==(2:8)) && sum(jy==(2:8))) || ...
        (~is2D && sum(jx==(2:8))) % molecule-wise
    molIncl = molsWithConf(trace,'value',prm);
elseif (is2D && sum(jx==[9,10]) && sum(jy==[9,10])) || ...
        (~is2D && sum(jx==[9,10])) % state-wise
    molIncl = molsWithConf(trace,'state',prm);
end
    
