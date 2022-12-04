function figure_bgopt_CloseRequestFcn(obj, evd, h_fig)

h = guidata(h_fig);
g = guidata(h.figure_bgopt);

p = h.param;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
prm = g.param;
m = g.curr_m;

% remove background intensities
for c = 1:nChan
    for l = 1:nExc
        prm{1}{m}(l,c,7) = 0;
    end
end
param.m = prm{1}{m};
param.gen = prm(2:3);

[mfile_path,o,o] = fileparts(mfilename('fullpath'));
save([mfile_path filesep 'default_param.ini'], '-struct', 'param');

if isfield(h,'bga')
    rmfield(h,'bga');
end

delete(obj);
