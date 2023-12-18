function [dat_proj,ok] = loadProj(pname, fname, s, h_fig)

dat_proj = {};
ok = 1;

if ~iscell(fname)
    fname = {fname};
end
    
[~,~,fext] = fileparts(fname{1});
fext_prev = fext;
if size(fname,2) > 1
    for i = 2:size(fname,2)
        [o,o,fext] = fileparts(fname{i});
        if ~strcmp(fext_prev, fext)
            updateActPan(['Input files do not have the same ' ...
                'extension.'], h_fig, 'error');
            ok = 0;
            return
        end
    end
end

islb = size(fname,2)>1;
if islb
    if loading_bar('init', h_fig, size(fname,2), 'Import traces...')
        ok = 0;
        return
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
end

if isempty(s) % MASH project
    for i = 1:size(fname,2)
        s = load([pname fname{i}], '-mat');
        [s,ok] = checkField(s, [pname fname{i}], h_fig);

        if islb && loading_bar('update', h_fig)
            ok = 0;
            return
        end
        
        if isempty(s)
            updateActPan(['Unable to load data from file: ' fname{i}], ...
                h_fig, 'error');
        else
            dat_proj = cat(2,dat_proj,s);
        end
    end

else % ASCII files
    ishist = isfield(s,'hist_file') && ~isempty(s.hist_file);
    if ishist
        opt = s.hist_import_opt;
        s = histAscii2mash(pname, fname{1}, s, opt, h_fig);
    else
        opt = s.traj_import_opt;
        s = intAscii2mash(pname, fname, s, opt, h_fig);
    end
    if isempty(s)
        ok = 0;
        return
    end
    [s,ok] = checkField(s, '', h_fig);
    dat_proj = s;
end

if islb
    loading_bar('close', h_fig);
end

if isempty(dat_proj)
    updateActPan('No data loaded.\nPlease check import options.', ...
        h_fig, 'error');
    ok = 0;
    return
end
