function saveActPan(actions, h_fig)
% Save actions to the year-month-day.log file.
% "h_fig" >> MASH figure handle
% "actions" >> action strings to write

% Requires external function: updateActPan.
% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

h = guidata(h_fig);

if isfield(h, 'folderRoot')
    pname = h.folderRoot;
else
    pname = pwd;
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
    str = 'Error occured while log writing.';
    updateActPan(str, h_fig, 'error');
end