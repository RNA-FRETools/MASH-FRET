function check_dependencies(mode)
% Check toolbox dependencies of MASH-FRET

% Input Arguments
% Discovery mode: find required toolboxes among the installed ones and writes them to a file requirements.md
%                 Note 1: run check_dependencies.m in Discovery mode only on an installation where all toolboxes are available, otherwise the list may be incomplete)
%                 Note 2: Running check_dependencies.m in Discovery mode requires MATLAB >2016b
% Analysis mode: check whether the required toolboxes (specified in requirements.md) are installed on the current system)

root = fileparts(which('MASH'));
if isempty(root)
    fprintf('MASH-FRET root not found!');
    return
end
requirementsFile = [root, '/requirements.md'];

switch mode
    case 'discovery'
    
        if verLessThan('matlab', '9.1')
            fprintf('Discovery mode requires MATLAB version > 2016b. You may still run check_dependencies.m in analysis mode')
            return
        end
       
        filepath = [root, '/**/*.m'];
        files = dir(filepath);
        filelist = cell(1, length(files));
        for i = 1:length(files)
            filelist{i} = fullfile(files(i).folder,files(i).name);
        end
        [~,pList] = matlab.codetools.requiredFilesAndProducts(filelist);
        fprintf('The following toolboxes are required to run MASH-FRET:\n');
        for i = 1:length(pList)
           fprintf('- %s (version installed %s)\n', pList(i).Name, pList(i).Version);
        end
        fprintf('- %s (version installed %s)\n', pList(i).Name, pList(i).Version);
        fprintf('\nNote: only toolboxes that are required and installed are listed.\nRun Discovery mode only on full installations (all toolboxes present).\ncheck_dependencies.m will list those that are required\n')

        if ~exist(requirementsFile, 'file')
            fileID = fopen(requirementsFile,'w');
            fprintf(fileID, '');
            for i = 1:length(pList)
                fprintf(fileID, '%s\n', pList(i).Name);
            end
            fclose(fileID);
        else
            fprintf('Note: requirements.md already exists.\n')
        end

        
    case 'analysis'
        if ~exist(requirementsFile, 'file')
            fprintf('Error: requirements.md file does not exist\n')
            return
        end
        
        fid = fopen(requirementsFile);
        requirementsContent = textscan(fid,'%s', 'delimiter','\n');
        product_info = ver;
        error = 0;
        for i = 1:length(requirementsContent{1})
            if ismember(requirementsContent{1}{i}, {product_info.Name})
                fprintf('- %s is available\n', requirementsContent{1}{i})
            else
                fprintf('- %s is missing\n', requirementsContent{1}{i})
                error = 1;
            end
        end
        if error == 0
            fprintf('-> Success: All required toolboxes are installed\n')
        else
            fprintf('-> Warning: Not all required toolboxes are installed. Parts of MASH-FRET may not function properly\n')
        end
end


end