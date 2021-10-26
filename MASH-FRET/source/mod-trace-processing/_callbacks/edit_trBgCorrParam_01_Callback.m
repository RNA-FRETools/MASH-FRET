function edit_trBgCorrParam_01_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;
selected_chan = p.proj{proj}.TP.fix{3}(6);

% get channel and laser corresponding to selected data
chan = 0;
for l = 1:nExc
    for c = 1:nChan
        chan = chan+1;
        if chan==selected_chan
            break
        end
    end
    if chan==selected_chan
        break
    end
end
method = p.proj{proj}.TP.curr{mol}{3}{2}(l,c);
if ~sum(double(method~=[1 2]))
    return
end

val = str2num(get(obj, 'String'));
if method==4 % number of binning interval
    val = round(val);
    if ~(numel(val) == 1 && ~isnan(val) && val >= 1)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan('Number of binning interval must be >= 1.',h_fig,...
            'error');
        return
    end
elseif method==4 % CumP threshold
    if ~(numel(val)==1 && ~isnan(val) && val>=0 && val<=1)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan(['Cumulative probability threshold must be comprised',...
            ' between 0 and 1.'], h_fig,'error');
        return
    end
elseif method==6 % running average window size
    if ~(numel(val) == 1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan('Running average window size must be >= 0.',h_fig,...
            'error');
        return
    end
elseif method==3 % tolerance cutoff
    if ~(numel(val) == 1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan('Tolerance cutoff must be >= 0.', h_fig, 'error');
        return
    end
elseif method==7 % calculation method
    val = round(val);
    if ~(numel(val) == 1 && ~isnan(val) && sum(val==[1 2]))
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan('Median calculation method must be 1 or 2',h_fig,...
            'error');
        return
    end
end

p.proj{proj}.TP.curr{mol}{3}{3}{l,c}(method,1) = val;

h.param = p;
guidata(h_fig, h);

ud_ttBg(h_fig);
