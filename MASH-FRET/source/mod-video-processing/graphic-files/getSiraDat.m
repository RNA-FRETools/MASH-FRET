function [vers,is_sgl,is_os] = getSiraDat(fullFname,h_fig)

vers = [];
is_sgl = false;
is_os = false;

% check if the movie can be read and is from SIRA
f = fopen(fullFname, 'r');
if f < 0
    if ~isempty(h_fig)
        updateActPan('Could not open the file, no file loaded.',h_fig,...
            'error');
    else
        disp('Error: could not open the file, no file loaded.');
    end
    fclose(f);
    return;
end

tline = fgetl_MASH(f);
% tline = fgetl(f);

if ~any(contains(tline,{'SIRA exported binary graphic',...
        'MASH smFRET exported binary graphic',...
        'MASH-FRET exported binary graphic'}))
    if ~isempty(h_fig)
        updateActPan(['Not a SIRA exported graphic file, no file ',...
            loaded.'], h_fig, 'error');
    else
        disp('Not a SIRA exported graphic file, no file loaded.');
    end
    fclose(f);
    return;
end

if isempty(tline)
    vers = 'older than 1.001';
else
    if contains(tline,'MASH-FRET exported binary graphic Version: ')
        vers = tline(...
            (length('MASH-FRET exported binary graphic Version: ')+1):end);
    elseif contains(tline,['MASH smFRET exported binary graphic ',...
            'Version'])
        vers = tline((length(['MASH smFRET exported binary graphic ' ...
            'Version: ']))+1:end);
    end
    if isempty(vers)
        vers = 'older than 1.003.37';
    else
        if str2num(vers(1:length('1.003'))) == 1.003
            subvers = getValueFromStr('1.003.', vers);
            if subvers>=39
                is_os = true;
            end
            if subvers>=41
                is_sgl = true;
            end
        %elseif str2num(vers)) > 1.003
        else
            is_os = true;
            is_sgl = true;
        end
    end
end
fclose(f);
