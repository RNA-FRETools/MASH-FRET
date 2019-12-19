function [p,errmsg] = setSimPrm(s, movDim)
% function p = setSimPrm(s, movDim)
%
% Import parameters of N molecule specified in the structure s
%
% s.FRET >> [J-by-2-by-N] matrix containing values (odd column nb.) and 
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

% Last update by MH, 18.12.2019
% >> change second input argument J (number of states, unused) to movDim 
%  (video dimensions)
% >> fix error when importing FRET states by adjusting size of FRET matrix
% >> cancel import of FRET values when transition rates are ill-defined
% >> maintain empty field "coord" even if all coordinates in presets 
%  file were discarded (allows re-sorting when video dimensions change)
% >> return error messages in errmsg to inform the user via the control 
%  panel (more visible)
%
% update: 19.4.2019 by MH
% >> Manage communication with user by handling ill-defined presets
%
% update: the 16th of September 2018 by Richard Börner

% initialize returned variables
p = [];
errmsg = {};

if isfield(s,'FRET') && ~isempty(s.FRET)
    if size(s.FRET,2)==2
        
        % modified by MH, 18.12.2019
%         p.stateVal = s.FRET(:,1,:);
%         p.FRETw = s.FRET(:,2,:);
        p.stateVal = permute(s.FRET(:,1,:),[3,1,2]);
        p.FRETw = permute(s.FRET(:,2,:),[3,1,2]);
        
        p.molNb = size(s.FRET,3);
        p.nbStates = size(s.FRET,1);
    else
        errmsg = cat(2,errmsg,'No FRET matrix imported:',cat(2,'>> the ',...
            'number of columns in the FRET matrix is not consistent: at ',...
            'least two columns are expected for FRET values and FRET ',...
            'deviations.'),' ');
    end
end

if isfield(s, 'trans_rates') && ~isempty(s.trans_rates)
    if isfield(p,'molNb') && isfield(p, 'nbStates') % FRET matrix loaded
        if size(s.trans_rates,3)==p.molNb && ...
                size(s.trans_rates,2)==p.nbStates
            p.kx = s.trans_rates;
            disp(cat(2,'Import presets for ',num2str(p.molNb),' molecules and',...
                ' ',num2str(p.nbStates),' FRET states ...'));
            disp('FRET values and deviations successfully imported');
            
            disp('Transition rates successfully imported');
            
        elseif size(s.trans_rates,3)~=p.molNb
            errmsg = cat(2,errmsg,cat(2,'No FRET or transition rate ',...
                'matrices imported:'),cat(2,'>> the numbers of molecules ',...
                'defined by transition rates and by the FRET matrix are ',...
                'not consistent.'),' ');
            
            % added by MH, 18.12.2019
            p = rmfield(p,{'stateVal','FRETw','molNb','nbStates'});
            
        else
            errmsg = cat(2,errmsg,cat(2,'No FRET or transition rate ',...
                'matrices imported:'),cat(2,'>> the numbers of states ',...
                'defined in transition rate matrices and in the FRET ',...
                'matrix are not consistent.'),' ');
            
            % added by MH, 18.12.2019
            p = rmfield(p,{'stateVal','FRETw','molNb','nbStates'});
            
        end
        
    else % FRET matrix not loaded
        p.kx = s.trans_rates;
        p.molNb = size(s.trans_rates,3);
        p.nbStates = size(s.trans_rates,2);
        disp(cat(2,'Import presets for ',num2str(p.molNb),' molecules and',...
            ' ',num2str(p.nbStates),' FRET states ...'));
        disp('Transition rates successfully imported');
    end
end

if isfield(s, 'gamma') && ~isempty(s.gamma)
    if isfield(p,'molNb') % FRET and/or transition rate matrix loaded
        if size(s.gamma,1)==p.molNb && size(s.gamma,2)==2
            p.gamma = s.gamma(:,1);
            p.gammaW = s.gamma(:,2);
            disp('Gamma factors successfully imported');
        elseif size(s.gamma,1)~=p.molNb
            errmsg = cat(2,errmsg,'No gamma factor matrix imported:',...
                cat(2,'>> the numbers of molecules defined in the gamma ',...
                'factors matrix and in the FRET/transition rate matrices ',...
                'are not consistent.'),' ');
        else
            errmsg = cat(2,errmsg,'No gamma factor matrix imported:',...
                cat(2,'>> the number of columns in the gamma factor ',...
                'matrix is not consistent: at least two columns are ',...
                'expected for factor values and factor deviations.'),' ');
        end
        
    elseif size(s.gamma,2)==2 % no FRET or transition rate matrices loaded
        p.molNb = size(s.gamma,1);
        p.gamma = s.gamma(:,1);
        p.gammaW = s.gamma(:,2);
        disp(cat(2,'Import presets for ',num2str(p.molNb),' molecules'));
        disp('Gamma factors successfully imported');
        
    else
        errmsg = cat(2,errmsg,'No gamma factor matrix imported:',...
            cat(2,'>> the number of columns in the gamma factor ',...
            'matrix is not consistent: at least two columns are ',...
            'expected for factor values and factor deviations.'),' ');
    end
end

if isfield(s, 'tot_intensity') && ~isempty(s.tot_intensity)
    if isfield(p, 'molNb') % FRET, transition rate or gamma factor matrices loaded
        if size(s.tot_intensity,1)==p.molNb && size(s.tot_intensity,2)==2
            p.totInt = s.tot_intensity(:,1);
            p.totInt_width = s.tot_intensity(:,2);
            disp('Intensities successfully imported');
        elseif size(s.tot_intensity,1)~=p.molNb
            errmsg = cat(2,errmsg,'No intensity matrix imported:',...
                cat(2,'>> the numbers of molecules defined in the ',...
                'intensity matrix and in the FRET/transition rate/gamma ',...
                'factor matrices are not consistent.'),' ');
        else
            errmsg = cat(2,errmsg,'No intensity matrix imported:',...
                cat(2,'>> the number of columns in the intensity matrix ',...
                'is not consistent: at least two columns are expected for',...
                ' intensity values and intensity deviations.'),' ');
        end
        
    elseif size(s.tot_intensity,2)==2 % no FRET, transition rate or gamma factor matrices loaded
        p.molNb = size(s.tot_intensity,1);
        p.totInt = s.tot_intensity(:,1);
        p.totInt_width = s.tot_intensity(:,2);
        disp(cat(2,'Import presets for ',num2str(p.molNb),' molecules'));
        disp('Intensities successfully imported');
    else
        errmsg = cat(2,errmsg,'No intensity matrix imported:',...
            cat(2,'>> the number of columns in the intensity matrix ',...
            'is not consistent: at least two columns are expected for',...
            ' intensity values and intensity deviations.'),' ');
    end
end

if isfield(s, 'coordinates') && ~isempty(s.coordinates)
    if isfield(p,'molNb') % FRET, transition rate, gamma factor and/or intensity matrices loaded
        N_0 = p.molNb;
    else % no FRET, transition rate, gamma factor and/or intensity matrices loaded
        N_0 = 0;
    end
    [ferr,coord,errmsg] = sortSimCoord(s.coordinates, movDim, N_0);
    if ferr || isempty(coord)
        if iscell(errmsg)
            for i = 1:numel(errmsg)
                disp(errmsg{i});
            end
        else
            disp(errmsg);
        end
        if ~ferr
            % if error is not due to file data, keep empty field 'coord' in 
            % structure to indicates that coordinates are present in file but 
            % are out of current video dimensions
            p.coord = [];
        end
    else
        if ~isfield(p,'molNb') % no FRET, transition rate, gamma factor and/or intensity matrices loaded
            disp(cat(2,'Import presets for ',num2str(p.molNb),' molecules'));
            p.molNb = size(coord,1);
        end
        p.coord = coord;
        disp('Coordinates successfully imported');
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
            errmsg = cat(2,errmsg,'No PSF width imported:',...
                cat(2,'>> the number of PSF widths is not consistent ',...
                'with the number of molecules defined in the FRET, ',...
                'transition rate, gamma factors, intensity and/or ',...
                'coordinates matrix.'),' ');
        else
            errmsg = cat(2,errmsg,'No PSF widths imported:',...
                cat(2,'>> the number of columns in the PSF width ',...
                'matrix is not consistent: at least one column is ',...
                'expected for widths in the left channel, and at most two',...
                'columns for widths in the left and right channels.'),' ');
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
        errmsg = cat(2,errmsg,'No PSF widths imported:',cat(2,'>> the ',...
            'number of columns in the PSF width matrix is not consistent:',...
            ' at least one column is expected for widths in the left ',...
            'channel, and at most two columns for widths in the left and ',...
            'right channels.'),' ');
    end
end


