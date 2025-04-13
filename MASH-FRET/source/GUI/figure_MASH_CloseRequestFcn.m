function figure_MASH_CloseRequestFcn(obj, evd)

h = guidata(obj);

if isfield(h, 'wait') && isfield(h.wait, 'figWait') && ...
        ishandle(h.wait.figWait)
    delete(h.wait.figWait);
end
if isfield(h, 'figure_trsfOpt') && ishandle(h.figure_trsfOpt)
    delete(h.figure_trsfOpt);
end
if isfield(h, 'figure_itgOpt') && ishandle(h.figure_itgOpt)
    delete(h.figure_itgOpt);
end
if isfield(h, 'figure_itgExpOpt') && ishandle(h.figure_itgExpOpt)
    delete(h.figure_itgExpOpt);
end
if isfield(h, 'figure_optBg') && ishandle(h.figure_optBg)
    delete(h.figure_optBg)
end
if isfield(h, 'figure_pbStats') && ishandle(h.figure_pbStats)
    delete(h.figure_pbStats)
end
if isfield(h, 'figure_dummy') && ~isempty(h.figure_dummy) && ...
        ishandle(h.figure_dummy)
    delete(h.figure_dummy)
end

setContPan('save interface parameters in default_param.ini file ...',...
    'process',obj);

p = h.param;
if ~isempty(p.proj) && isfield(p.ttPr,'defProjPrm')
    % remove background intensities
    for c = 1:size(p.ttPr.defProjPrm.mol{3}{3},2)
        for l = 1:size(p.ttPr.defProjPrm.mol{3}{3},1)
            p.ttPr.defProjPrm.mol{3}{3}{l,c}(3) = 0;
        end
    end

    % remove discretisation results
    p.ttPr.defProjPrm.mol{3}{4} = [];
    p.folderRoot = p.proj{p.curr_proj}.folderRoot;
end
p = rmfield(p,{'proj','curr_proj'});
[mfile_path,o,o] = fileparts(which('MASH'));
save([mfile_path filesep 'default_param.ini'], '-struct', 'p');

setContPan('closing MASH-FRET ...','process',obj);

delete(obj);
