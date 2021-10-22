function saveBgOpt(h_fig,varargin)
% saveBgOpt(h_fig)
% saveBgOpt(h_fig,pname,fname)
%
% Export background intensities calculated with Background analyzer to ASCII files.
%
% h_fig: handle to Background analyzer figure
% pname: destination folder
% fname: destination file

g = guidata(h_fig);
h = guidata(g.figure_MASH);
p = h.param;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nMol = size(p.proj{proj}.intensities,2)/nChan;
exc = p.proj{proj}.excitations;
labels = p.proj{proj}.labels;
rate = p.proj{proj}.frame_rate;
nPix = p.proj{proj}.pix_intgr(2);
perSec = p.proj{proj}.TP.fix{2}(4);

if ~isempty(varargin)
    pname = varargin{1};
    fname = varargin{2};
else
    [o,defname,o] = fileparts(p.proj{proj}.proj_file);
    defname = [setCorrectPath('traces_processing', g.figure_MASH) ...
        'optimisation' filesep defname];
    [pname,fname,o] = uiputfile({'*.bga', ...
        'Background analyzer results(*.bga)'; '*.*', 'All files(*.*)'}, ...
        'Export BG optimisation', defname);
end
if ~sum(fname)
    return
end
[o,fname,o] = fileparts(fname);

for l = 1:nExc
    for c = 1:nChan
        dat = [];
        for m = 1:nMol
            if m==1
                meth = g.param{1}{m}(l,c,1);
                dat = g.res{m,l,c}(:,2:end);
            end
            if meth~=g.param{1}{m}(l,c,1)
                updateActPan(['The export function supports only a ' ...
                    'unique correction method for all molecules.'], ...
                    g.figure_MASH, 'error');
                return;
            end
            dat = [dat g.res{m,l,c}(:,1)];
        end
        
        str_un = '(a.u. /pix)';
        if perSec
            str_un = '(a.u. /pix /s)';
            dat(:,3:end) = dat(:,3:end)/rate;
        end
        dat(:,3:end) = dat(:,3:end)/nPix;

        % export BG intensities and statistics
        f = fopen([pname fname '_' labels{c} '-' num2str(exc(l)) ...
            'nm.bga'], 'Wt');
        if meth==1
            prm = [];
            fprintf(f, ['mean_value' str_un '\tstd_value' str_un '\t' ...
                repmat(['mol_%i' str_un '\t'], [1,nMol]) '\n'], (1:nMol)');
        elseif sum(meth==(3:7)) % sub image, param 1
            prm = [1 2];
            fprintf(f, ['param_1\tsubimage_size(pix)\t' ...
                'mean_value' str_un '\tstd_value' str_un '\t' ...
                repmat(['mol_%i' str_un '\t'],[1,nMol]) '\n'], (1:nMol)');
        else % sub image
            prm = 1;
            fprintf(f, ['subimage_size(pix)\tmean_value' str_un ...
                '\tstd_value' str_un '\t' repmat(['mol_%i' str_un ...
                '\t'],[1,nMol]) '\n'], (1:nMol)');
        end
        means = mean(dat(:,(numel(prm)+1):end),2);
        stds = std(dat(:,(numel(prm)+1):end),0,2);
        fprintf(f, [repmat('%d\t', [1,(size(dat,2)-3)+numel(prm)+2]) ...
            '\n'], [dat(:,prm) means stds dat(:,4:end)]');
        fclose(f);
    end
end
