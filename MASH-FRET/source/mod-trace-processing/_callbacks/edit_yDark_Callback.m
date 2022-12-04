function edit_yDark_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
itgDim = p.proj{proj}.pix_intgr(1);
selected_chan = p.proj{proj}.TP.fix{3}(6);
multichanvid = numel(p.proj{proj}.movie_file);
    
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
if method~=6 % dark trace
    return
end

if multichanvid
    res_y = p.proj{proj}.movie_dim{1}(2);
else
    res_y = p.proj{proj}.movie_dim{c}(2);
end
valMin = itgDim/2;
valMax = res_y - itgDim/2;
val = str2num(get(obj, 'String'));
if ~(numel(val) == 1 && ~isnan(val) && val > valMin && val < valMax)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Dark y-coordinates must be > ',num2str(valMin),' and < ',...
        num2str(valMax)], h_fig, 'error');
    return
end

p.proj{proj}.TP.curr{mol}{3}{3}{l,c}(method,5) = val;

h.param = p;
guidata(h_fig, h);

ud_ttBg(h_fig);
updateFields(h_fig, 'subImg');
