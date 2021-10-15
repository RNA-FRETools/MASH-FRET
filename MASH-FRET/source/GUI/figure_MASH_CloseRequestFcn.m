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
if isfield(h, 'figure_dummy') && ~isempty(h.figure_dummy) && ...
        ishandle(h.figure_dummy)
    delete(h.figure_dummy)
end

param = h.param;
if ~isempty(param.proj) && isfield(param.ttPr,'defProjPrm')
    % remove background intensities
    for c = 1:size(param.ttPr.defProjPrm.mol{3}{3},2)
        for l = 1:size(param.ttPr.defProjPrm.mol{3}{3},1)
            param.ttPr.defProjPrm.mol{3}{3}{l,c}(3) = 0;
        end
    end

    % remove discretisation results
    param.ttPr.defProjPrm.mol{3}{4} = [];
    h.param.folderRoot = h.param.proj{h.param.curr_proj}.folderRoot;
end
h.param = rmfield(h.param,{'proj','curr_proj'});
[mfile_path,o,o] = fileparts(which('MASH'));
save([mfile_path filesep 'default_param.ini'], '-struct', 'param');

delete(obj);
