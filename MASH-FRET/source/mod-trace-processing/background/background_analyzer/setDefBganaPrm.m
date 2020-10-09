function [ok,param,curr_m,curr_l,curr_c] = setDefBganaPrm(h_fig)
param = [];
curr_m = 1; curr_l = 1; curr_c = 1;
ok = 1;

[mfile_path,o,o] = fileparts(mfilename('fullpath'));

if exist([mfile_path filesep 'default_param.ini'], 'file')
    try
        prm_prev = load([mfile_path filesep 'default_param.ini'], '-mat');
        param = cell(1,3);
    catch err
        h_err = errordlg({err.message '' ...
            'The file will be deleted.' ''...
            'Please run MASH-FRET again to debug.'}, ...
            'Initialisation error', 'modal');
        uiwait(h_err);
        delete([mfile_path filesep '..' filesep '..' filesep ...
            'default_param.ini']);
        ok = 0;
        return;
    end
end

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nMol = size(p.proj{proj}.intensities,2)/nChan;
exc = p.proj{proj}.excitations;
nExc = numel(exc);
nChan = p.proj{proj}.nb_channel;

% get channel and laser corresponding to selected data
selected_chan = p.proj{proj}.fix{3}(6);
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

curr_m = p.curr_mol(proj); % current molecule
curr_l = l; % current excitation
curr_c = c; % current channel

for m = 1:nMol
    if exist('prm_prev','var')
        param{1}{m} = prm_prev.m;
    end

    p_BG = p.proj{proj}.curr{m}{3};
    meth = p_BG{2};
    def{1}{m}(:,:,1) = meth; % [nExc-by-nChan] correction methods
    
    for l = 1:nExc
        for c = 1:nChan
            prm = p_BG{3}{l,c}(meth(l,c),:);
            def{1}{m}(l,c,2) = prm(1); % [nExc-by-nChan] parameters 1
            def{1}{m}(l,c,3) = prm(2); % [nExc-by-nChan] sub-image dim.
            def{1}{m}(l,c,4) = prm(4); % [nExc-by-nChan] dark x-coord.
            def{1}{m}(l,c,5) = prm(5); % [nExc-by-nChan] dark y-coord.
            def{1}{m}(l,c,6) = prm(6); % [nExc-by-nChan] auto dark
                                          % coord.
            def{1}{m}(l,c,7) = prm(3); % [nExc-by-nChan] BG intensities
            if m == 1
                def{2}{1}(l,c,:) = 100:-10:10; % [nExc-by-nChan-by-10] param 1
                def{2}{2}(l,c,:) = zeros(1,1,10); % [nExc-by-nChan-by-10] param 2
                def{2}{3}(l,c,:) = 5:5:50; % [nExc-by-nChan-by-10] subimge dim.
            end
        end
    end
end
def{3}(1) = true; % Fix parameter 1 for all calc.
def{3}(2) = true; % Fix parameter 2 for all calc.
def{3}(3) = true; % calculate for all molecules

if exist('prm_prev','var')
    param(2:3) = prm_prev.gen;
end

param = adjustVal(param, def);


