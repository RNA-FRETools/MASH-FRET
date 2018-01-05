function nameCorr = getCorrName(name, pName, h_fig)
% Remove all uncompatible characters . , ; \ / : * ? " < > | or space from
% input file name and check for the name length
% "name" >> file name to correct
% "pName" >> path where file is saved (obsolet)
% "h_fig" >> MASH figure handle
% "nameCorr" >> corrected file name

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

[o,name,fext] = fileparts(name);

if isempty(fext)
    maxCarExt = '.cpSelect';
else
    maxCarExt = fext;
end

namePreCorr = strrep(name, ' ', '');
namePreCorr = strrep(namePreCorr, '.', '');
namePreCorr = strrep(namePreCorr, ';', '');
namePreCorr = strrep(namePreCorr, ',', '');
namePreCorr = strrep(namePreCorr, '\', '');
namePreCorr = strrep(namePreCorr, '/', '');
namePreCorr = strrep(namePreCorr, ':', '');
namePreCorr = strrep(namePreCorr, '*', '');
namePreCorr = strrep(namePreCorr, '?', '');
namePreCorr = strrep(namePreCorr, '"', '');
namePreCorr = strrep(namePreCorr, '<', '');
namePreCorr = strrep(namePreCorr, '>', '');
namePreCorr = strrep(namePreCorr, '|', '');

if (length(namePreCorr) + length(maxCarExt)) > (namelengthmax - 1)
    str = 'WARNING: The file name is too long';
    updateActPan(str, h_fig);
    
    nbCarSup = length(namePreCorr) + length(maxCarExt) - namelengthmax + 1;
    nameCorr = namePreCorr((nbCarSup + 1):length(namePreCorr));
    if strcmp(nameCorr(1), '-')
        nameCorr = nameCorr(2:length(nameCorr));
    end

    if ~isempty(fext)
        nameCorr = [nameCorr maxCarExt];
    end

    if (length(nameCorr) + length(maxCarExt)) > (namelengthmax - 1)
        while (length(nameCorr) + length(maxCarExt)) >= namelengthmax
            nameCorr = getCorrName(nameCorr, h_fig);
        end
    end
    
    str = ['new file name: ' nameCorr];
    updateActPan(str, h_fig);
    
else
    nameCorr = namePreCorr;
    if ~isempty(fext)
        nameCorr = [nameCorr maxCarExt];
    end
end
