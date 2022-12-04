function success = saveActPan(actions, h_fig)
% Save actions to the year-month-day.log file.
% "h_fig" >> MASH figure handle
% "actions" >> action strings to write

% Requires external function: updateActPan.
%
% update 4.5.2019 by MH: save logs in MASH-FRET/log
% update 19.2.2019 by MH: manage error invalid root folder

success = 1;

try
%     if isfield(h, 'folderRoot')
%         pname = cat(2,h.folderRoot,filesep,'log');
%         if ~exist(pname, 'dir')
%             mkdir(pname)
%         end
%     else
%         pname = pwd;
%     end
    [src,o,o] = fileparts(which('MASH.m'));
    pname = cat(2,src,filesep,'log');
    if ~exist(pname,'dir')
        mkdir(pname);
    end
    
catch err
    fprintf(cat(2,'Failure in accessing root folder. Please check for ',...
        ' writing permissions or unusual characters in folder name or ',...
        'directory path\nError:',err.message));
    success = 0;
    return
end

dateTime = clock;
logName = [num2str(dateTime(1)) '-' num2str(dateTime(2)) '-' ...
    num2str(dateTime(3)) '.log'];

fID = fopen([pname filesep logName], 'a');
if fID ~= -1
    if iscell(actions)
        for i = 1:size(actions, 1)
            fprintf(fID, '%s\r\n', actions{i,1});
        end
    elseif ischar(actions)
        fprintf(fID, '%s\r\n', actions);
    end
    fclose(fID);
else
    disp(cat(2,'Failure in accessing root folder. Please check for ',...
        ' writing permissions or unusual characters in folder name or ',...
        'directory path'));
    success = 0;
end
