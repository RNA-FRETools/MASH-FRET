function TTgenGo(h_fig,varargin)
% TTgenGo(h_fig)
% TTgenGo(h_fig,pname,fname)
%
% Save traces to MASH project and other files.
% TTgenGo can be called either after pressing "create & export" button in Video processing, or from a test routine.
% 
% h_fig: handle to main figure
% pname: destination folder (from routine test)
% fname: destination .mash file (from routine test)

% Last update by MH, 28.3.2019: change MASH folder from /video-processing back to root folder
% update by MH, 18.2.2019: change default folder to video_processing comment code

h = guidata(h_fig);
p = h.param.movPr;

% update data
updateFields(h_fig,'movPr');

if isfield(p,'itg_movFullPth') && ~isempty(p.itg_movFullPth)
    if isfield(p, 'coordItg') && ~isempty(p.coordItg)
        
        % build file name
        fname_proj = '';
        [o,movName,o] = fileparts(p.itg_movFullPth);
        defName = cat(2,setCorrectPath(h.folderRoot,h_fig),movName,...
            '.mash');
        [fname,pname,o] = uiputfile({'*.mash;', 'MASH project(*.mash)'; ...
             '*.*','All Files (*.*)'},'Export MASH project',defName);
        if ~isempty(fname) && sum(fname)
            cd(pname);
            [o,fname,o] = fileparts(fname);
            fname_proj = getCorrName(cat(2,fname,'.mash'),pname,h_fig);
        end
        
        % export data
        if ~isempty(fname_proj) && sum(fname_proj)
            dat = exportProject(p,cat(2,pname,fname_proj),h_fig);
            if ~isempty(dat)
                
                % save project
                save(cat(2,pname,fname_proj),'-struct','dat');
                
                % export other files
                saveTraces(dat,pname,fname_proj,{p.itg_expMolFile ...
                    p.itg_expFRET},h_fig);
            end
        end
        
    else
        set(h.edit_itg_coordFile,'BackgroundColor',[1,0.75,0.75]);
        updateActPan('No coordinates loaded.',h_fig,'error');
    end
    
else
    set(h.edit_movItg,'BackgroundColor',[1 0.75 0.75]);
    updateActPan('No movie loaded.',h_fig,'error');
end
