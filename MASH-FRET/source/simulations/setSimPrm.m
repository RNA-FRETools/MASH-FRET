function p = setSimPrm(s, movDim)
% function p = setSimPrm(s, J)
%
% Import parameters of N molecule specified in the structure s
%
% s.FRET >> [N-by-2*J] matrix containing values (odd column nb.) and 
%           distribution width (even column nb.) of the J FRET states
% s.trans_rates >> [J-by-J-by-N] matrix containing transition rates from
%                  the state j (row nb.) to the state i (column nb.)
% s.gamma >> [N-by-2] matrix containing values (1st column) and 
%            distribution width (2nd column) of the gamma factors
% s.tot_intensity >> [N-by-2] matrix containing values (1st column) and 
%                    distribution width (2nd column) of the total 
%                    intensities (donor + acceptor)
% s.coordinates >> [N-by-2] or [N-by-4] matrix containing moelcule 
%                  coordinates

% Last update: 19.4.2019 by MH
% >> Manage communication with user by handling ill-defined presets
%
% update: the 16th of September 2018 by Richard Börner

p = [];

if isfield(s,'FRET') && ~isempty(s.FRET)
    if size(s.FRET,2)==2
        p.stateVal = s.FRET(:,1,:);
        p.FRETw = s.FRET(:,2,:);
        p.molNb = size(s.FRET,3);
        p.nbStates = size(s.FRET,1);
        disp(cat(2,'Import presets for ',num2str(p.molNb),' molecules and',...
            ' ',num2str(p.nbStates),' FRET states ...'));
        disp('FRET values and deviations successfully imported');
    else
        disp('No FRET matrix imported:');
        disp(cat(2,'>> the number of columns in the FRET matrix is not ',...
            'consistent: at least two columns are expected for FRET ',...
            'values and FRET deviations.'));
    end
end

if isfield(s, 'trans_rates') && ~isempty(s.trans_rates)
    if isfield(p,'molNb') && isfield(p, 'nbStates') % FRET matrix loaded
        if size(s.trans_rates,3)==p.molNb && ...
                size(s.trans_rates,2)==p.nbStates
            p.kx = s.trans_rates;
            disp('transition rates successfully imported');
            
        elseif size(s.trans_rates,3)~=p.molNb
            disp('No transition rate matrix imported:');
            disp(cat(2,'>> the number of transition rate matrices is not ', ...
                'consistent with the number of molecules defined in the FRET ',...
                'matrix.'));
        else
            disp('No transition rate matrix imported:');
            disp(cat(2,'>> the number of states defined in transition',...
                'rate matrices is not consistent with the number of ',...
                'states defined in the FRET matrix.'));
        end
        
    else % FRET matrix not loaded
        p.kx = s.trans_rates;
        p.molNb = size(s.trans_rates,3);
        p.nbStates = size(s.trans_rates,2);
        disp(cat(2,'Import presets for ',num2str(p.molNb),' molecules and',...
            ' ',num2str(p.nbStates),' FRET states ...'));
        disp('transition rates successfully imported');
    end
end

if isfield(s, 'gamma') && ~isempty(s.gamma)
    if isfield(p,'molNb') % FRET and/or transition rate matrix loaded
        if size(s.gamma,1)==p.molNb && size(s.gamma,2)==2
            p.gamma = s.gamma(:,1);
            p.gammaW = s.gamma(:,2);
            disp('gamma factors successfully imported');
        elseif size(s.gamma,1)~=p.molNb
            disp('No gamma factor matrix imported:');
            disp(cat(2,'>> the number of gamma factors is not consistent ',...
                'with the number of molecules defined in the FRET ',...
                'and/or transition rate matrix.'));
        else
            disp('No gamma factor matrix imported:');
            disp(cat(2,'>> the number of columns in the gamma factor ',...
                'matrix is not consistent: at least two columns are ',...
                'expected for factor values and factor deviations.'));
        end
        
    elseif size(s.gamma,2)==2 % no FRET or transition rate matrices loaded
        p.molNb = size(s.gamma,1);
        p.gamma = s.gamma(:,1);
        p.gammaW = s.gamma(:,2);
        disp(cat(2,'Import presets for ',num2str(p.molNb),' molecules'));
        disp('gamma factors successfully imported');
        
    else
        disp('No gamma factor matrix imported:');
        disp(cat(2,'>> the number of columns in the gamma factor ',...
            'matrix is not consistent: at least two columns are ',...
            'expected for factor values and factor deviations.'));
    end
end

if isfield(s, 'tot_intensity') && ~isempty(s.tot_intensity)
    if isfield(p, 'molNb') % FRET, transition rate or gamma factor matrices loaded
        if size(s.tot_intensity,1)==p.molNb && size(s.tot_intensity,2)==2
            p.totInt = s.tot_intensity(:,1);
            p.totInt_width = s.tot_intensity(:,2);
            disp('intensities successfully imported');
        elseif size(s.tot_intensity,1)~=p.molNb
            disp('No intensity matrix imported:');
            disp(cat(2,'>> the number of intensities is not consistent ',...
                'with the number of molecules defined in the FRET, ',...
                'transition rate, and/or gamma factor matrix.'));
        else
            disp('No intensity matrix imported:');
            disp(cat(2,'>> the number of columns in the intensity matrix ',...
                'is not consistent: at least two columns are expected for',...
                ' intensity values and intensity deviations.'));
        end
        
    elseif size(s.tot_intensity,2)==2 % no FRET, transition rate or gamma factor matrices loaded
        p.molNb = size(s.tot_intensity,1);
        p.totInt = s.tot_intensity(:,1);
        p.totInt_width = s.tot_intensity(:,2);
        disp(cat(2,'Import presets for ',num2str(p.molNb),' molecules'));
        disp('intensities successfully imported');
    else
        disp('No intensity matrix imported:');
        disp(cat(2,'>> the number of columns in the intensity matrix ',...
            'is not consistent: at least two columns are expected for',...
            ' intensity values and intensity deviations.'));
    end
end

if isfield(s, 'coordinates') && ~isempty(s.coordinates)
    x1 = []; y1 = []; x2 = []; y2 = [];
    res_x = movDim(1);
    for col = 1:2:size(s.coordinates,2) % x-coordinates
        x1 = [x1; s.coordinates(s.coordinates(:,col) < ...
            round(res_x/2),col)];
        y1 = [y1; s.coordinates(s.coordinates(:,col) < ...
            round(res_x/2),col+1)];
        x2 = [x2; s.coordinates(s.coordinates(:,col) >= ...
            round(res_x/2),col)];
        y2 = [y2; s.coordinates(s.coordinates(:,col) >= ...
            round(res_x/2),col+1)];
    end

    if ~(isempty(x1) && isempty(x2))
        if isempty(x2) && ~isempty(x1)
            disp(cat(2,'coordinates in right channel automatically ', ...
                'calculated.'));
            x2 = x1+round(res_x/2);
            y2 = y1;

        elseif isempty(x1) && ~isempty(x2)
            disp(cat(2,'coordinates in left channel automatically ', ...
                'calculated.'));
            x1 = x2-round(res_x/2);
            y1 = y2;

        else
            minN = min([numel(x1) numel(x2)]);
            x1 = x1(1:minN,1); y1 = y1(1:minN,1);
            x2 = x2(1:minN,1); y2 = y2(1:minN,1);
        end
        coord = [x1 y1 x2 y2];
        
        if isfield(p,'molNb') % FRET, transition rate, gamma factor and/or intensity matrices loaded
            if size(coord,1)==p.molNb
                p.coord = coord;
                disp('coordinates successfully imported');
            else
                disp('No coordinates imported:');
                disp(cat(2,'>> the number of coordinates is not consistent ',...
                    'with the number of molecules defined in the FRET, ',...
                    'transition rate, gamma factor, and/or intensity matrix.'));
            end
        else % no FRET, transition rate, gamma factor and/or intensity matrices loaded
            p.molNb = size(coord,1);
            p.coord = coord;
            disp(cat(2,'Import presets for ',num2str(p.molNb),' molecules'));
            disp('coordinates successfully imported');
        end
        
    else
        disp('No coordinates imported:');
        disp(cat(2,'>> all coordinates are out of video dimensions: ',...
            'please modify the video dimensions in panel "Video ',...
            'parameters" or review the coordinates in the pre-set file.'));
    end
end

if isfield(s, 'psf_width') && ~isempty(s.psf_width)
    if isfield(p,'molNb') % FRET, transition rate, gamma factor, intensity and/or coordinates matrices loaded
        if size(s.psf_width,1)==p.molNb && (size(s.psf_width,2)==1 || ...
                size(s.psf_width,2)==2)
            p.psf_width = s.psf_width(:,1);
            switch size(s.psf_width,2)
                case 1
                    p.psf_width = [p.psf_width,s.psf_width(:,1)];
                    disp(cat(2,'PSF widths in right channel automatically', ...
                        ' duplicated from left channel.'));
                case 2
                    p.psf_width = [p.psf_width,s.psf_width(:,2)];
            end
            disp('PSF widths successfully imported');
            
        elseif size(s.psf_width,1)~=p.molNb
            disp('No PSF width imported:');
            disp(cat(2,'>> the number of PSF widths is not consistent ',...
                'with the number of molecules defined in the FRET, ',...
                'transition rate, gamma factors, intensity and/or ',...
                'coordinates matrix.'));
        else
            disp('No PSF widths imported:');
            disp(cat(2,'>> the number of columns in the PSF width ',...
                'matrix is not consistent: at least one column is ',...
                'expected for widths in the left channel, and at most two',...
                'columns for widths in the left and right channels.'));
        end
        
    elseif size(s.psf_width,2)==1 || size(s.psf_width,2)==2 % no FRET, transition rate, gamma factor, intensity and/or coordinates matrices loaded
            p.molNb = size(s.psf_width,1);
            p.psf_width = s.psf_width(:,1);
            switch size(s.psf_width,2)
                case 1
                    p.psf_width = [p.psf_width,s.psf_width(:,1)];
                    disp(cat(2,'PSF widths in right channel automatically', ...
                        ' duplicated from left channel.'));
                case 2
                    p.psf_width = [p.psf_width,s.psf_width(:,2)];
            end
            disp(cat(2,'Import presets for ',num2str(p.molNb),' molecules'));
            disp('PSF widths successfully imported');
            
    else
        disp('No PSF widths imported:');
        disp(cat(2,'>> the number of columns in the PSF width ',...
            'matrix is not consistent: at least one column is ',...
            'expected for widths in the left channel, and at most two',...
            'columns for widths in the left and right channels.'));
    end
end


