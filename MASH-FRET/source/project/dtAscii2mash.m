function s = dtAscii2mash(pname, fname, p, h_fig)

dat = [];
dat_file = {};
file_valid = [];

for i_f = 1:size(fname)
    dt = importdata([pname fname{i_f}]);
    if size(dt,2) < 3
        disp(['Error: number of columns < 3 for file: ' fname]);
        
    else
        final = inputdlg(['Final state for file "' fname '":'], ...
            'User input', {1}, {'0'});
        if ~(~isempty(final) && ~isempty(str2num(final{1})) && ...
                numel(str2num(final{1})) == 1 && ...
                ~isnan(str2num(final{1})))
            disp('Invalid input: process interrupted.');
            return;

        else
            final = str2num(final{1});
            dt(end,end) = final;
            dat_file = [dat_file dt];
            file_valid = [file_valid i];
        end
    end
end
if ~isempty(dat_file)
    dat.dt = dt;
    dat.dt_ascii = true;
    dat.dt_pname = pname;
    dat.dt_fname = fname(file_valid);
    ok = 1;
end

