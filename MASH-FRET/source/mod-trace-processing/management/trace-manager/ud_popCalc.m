function molIncl = ud_popCalc(h_fig)

h = guidata(h_fig);
p = h.param;
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
datid = getASdataindex;
jx = datid(get(h.tm.popupmenu_selectXval,'value'));
jy = datid(get(h.tm.popupmenu_selectYval,'value'));

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
    trace_x = [];
    trace_y = [];
    for m = unique(dat3.val{datax,jx}(:,2))'
        val_m = dat3.val{datax,jx}(dat3.val{datax,jx}(:,2)==m,:);
        if size(val_m,1)==1
            trace_x = cat(1,trace_x,val_m(1,:));
            trace_y = cat(1,trace_y,val_m(1,:));
        else
            trace_x = cat(1,trace_x,val_m(1:end-1,:));
            trace_y = cat(1,trace_y,val_m(2:end,:));
        end
    end
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
        if isempty(trace_x) || isempty(trace_y)
            trace = [];
        else
            trace = [trace_x trace_y];
        end
    else
        trace = trace_x;
    end
end
if isempty(trace)
    molIncl = [];
    return
end

if (is2D && sum(jx==getASdataindex('framewise')) && ...
        sum(jy==getASdataindex('framewise'))) || ...
        (~is2D && sum(jx==getASdataindex('framewise'))) % frame-wise data
    molIncl = molsWithConf(trace(:,1:2:end),'trace',prm,incl);
elseif (is2D && sum(jx==getASdataindex('molwise')) && ...
        sum(jy==getASdataindex('molwise'))) || ...
        (~is2D && sum(jx==getASdataindex('molwise'))) % molecule-wise
    molIncl = molsWithConf(trace(:,1:2:end),'value',prm);
elseif (is2D && sum(jx==getASdataindex('statewise')) && ...
        sum(jy==getASdataindex('statewise'))) || ...
        (~is2D && sum(jx==getASdataindex('statewise'))) % state-wise
    molIncl = molsWithConf(trace,'state',prm);
end
    
