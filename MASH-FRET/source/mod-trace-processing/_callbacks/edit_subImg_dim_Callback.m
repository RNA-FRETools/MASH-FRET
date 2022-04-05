function edit_subImg_dim_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
selected_chan = p.proj{proj}.TP.fix{3}(6);

if ~(p.proj{proj}.is_coord && p.proj{proj}.is_movie)
    return
end

% get channel and laser corresponding to selected data
chan = 0;
for l = 1:nExc
    for c = 1:nChan
        chan = chan+1;
        if chan==selected_chan
            break;
        end
    end
    if chan==selected_chan
        break;
    end
end

multichanvid = numel(p.proj{proj}.movie_file)==1;
if multichanvid
    res_x = p.proj{proj}.movie_dim{1}(1);
    subW = round(res_x/nChan);
    maxVal = min([subW (res_x-(nChan-1)*subW)]);
else
    maxVal = p.proj{proj}.movie_dim{c}(1);
end

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val) == 1 && ~isnan(val) && val > 0 && val <= maxVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Subimage dimensions must be > 0 and <= ' ...
        num2str(maxVal)], h_fig , 'error');
    return
end
method = p.proj{proj}.TP.curr{mol}{3}{2}(l,c);

p.proj{proj}.TP.curr{mol}{3}{3}{l,c}(method,2) = val;

h.param = p;
guidata(h_fig, h);

updateFields(h_fig, 'subImg');

