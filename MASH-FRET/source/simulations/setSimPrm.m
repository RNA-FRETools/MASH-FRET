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

% Created by Mélodie C.A.S. Hadzic the 24th of April 2014
% Last update: the 25th of April by Mélodie C.A.S. Hadzic

p = [];

if isfield(s, 'FRET')
    if size(s.FRET,2) > 0 && mod(size(s.FRET,2),2) == 0
        p.stateVal = s.FRET(:,1:2:end);
        p.FRETw = s.FRET(:,2:2:end);
        p.molNb = size(s.FRET,1);
        p.nbStates = size(s.FRET,2)/2;
    else
        disp('The column nb. in FRET matrix is not consistent.');
    end
end

if isfield(s, 'trans_rates')
    if (isfield(p, 'molNb') && size(s.trans_rates,3) >= p.molNb) || ...
            ~isfield(p, 'molNb')
        if ~isfield(p, 'molNb')
            p.molNb = size(s.trans_rates,3);
        end
        if ~isfield(p, 'nbStates')
            p.nbStates = size(s.trans_rates,2);
        end
        p.kx = s.trans_rates;
    else
        disp(['The z-length of the transition rate matrix is not ' ...
            'consistent with the number of molecule.']);
    end
end

if isfield(s, 'gamma')
    if (isfield(p, 'molNb') && size(s.gamma,1) >= p.molNb) || ...
            ~isfield(p, 'molNb')
        if ~isfield(p, 'molNb')
            p.molNb = size(s.gamma_val,1);
        end
        p.gamma = s.gamma(:,1);
        p.gammaW = s.gamma(:,2);
    else
        disp(['The row nb. in gamma matrix is not consistent with the ' ...
            'number of molecule.']);
    end
end

if isfield(s, 'tot_intensity')
    if (isfield(p, 'molNb') && size(s.tot_intensity,1) >= p.molNb) || ...
            ~isfield(p, 'molNb')
        if ~isfield(p, 'molNb')
            p.molNb = size(s.tot_intensity,1);
        end
        p.totInt = s.tot_intensity(1:p.molNb,1);
        p.totInt_width = s.tot_intensity(1:p.molNb,2);
    else
        disp(['The row nb. in total intensity matrix is not consistent' ...
            'with the number of molecule.']);
    end
end

if isfield(s, 'coordinates')
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
            disp(['Coordinates in right channel automatically ' ...
                'calculated.']);
            x2 = x1+round(res_x/2);
            y2 = y1;

        elseif isempty(x1) && ~isempty(x2)
            disp(['Coordinates in left channel automatically ' ...
                'calculated.']);
            x1 = x2-round(res_x/2);
            y1 = y2;

        else
            minN = min([numel(x1) numel(x2)]);
            x1 = x1(1:minN,1); y1 = y1(1:minN,1);
            x2 = x2(1:minN,1); y2 = y2(1:minN,1);
        end
        coord = [x1 y1 x2 y2];
    else
        disp('Coordinates are out of movie dimension range.');
    end
    
    if (isfield(p, 'molNb') && size(coord,1) >= p.molNb) || ...
            ~isfield(p, 'molNb')
        if ~isfield(p, 'molNb')
            p.molNb = size(coord,1);
        end
        p.coord = coord(1:p.molNb,:);
        
    else
        disp(['The row nb. in coordinates matrix is not consistent' ...
            'with the number of molecules.']);
    end
end

if isfield(s, 'psf_width')
    fwhm = s.psf_width(:,1);
    if size(s.psf_width,2)>1
        fwhm = [fwhm s.psf_width(:,2)];
    else
        fwhm = [fwhm fwhm];
    end

    if (isfield(p, 'molNb') && size(fwhm,1)>=p.molNb) || ...
            ~isfield(p, 'molNb')
        if ~isfield(p, 'molNb')
            p.molNb = size(fwhm,1);
        end
        p.psf_width = fwhm(1:p.molNb,:);
        
    else
        disp(['The row nb. in PSF FWHM matrix is not consistent' ...
            'with the number of molecules.']);
    end
end


