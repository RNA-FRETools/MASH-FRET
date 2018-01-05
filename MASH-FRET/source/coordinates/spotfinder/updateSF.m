function updateSF(img, lb, h_fig)
% Find spots in the image and select coordinates according to selection
% rules.
% "img" >> image
% "h_fig" >> MASH figure handle
% "spotImg" >> image containing circles around selected coordinates

% Requires external functions: determineSpots, selectSpots, showSpots.
% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

h = guidata(h_fig);
method = h.param.movPr.SF_method;
if method > 1
    nChan = h.param.movPr.nChan;
    if size(h.param.movPr.SFres,2) <= nChan+1
        spots_raw = determineSpots(h.param.movPr.SFres, img, lb, h_fig);
        for i = 1:nChan
            h.param.movPr.SFres{1,1+nChan+i} = spots_raw{1,i};
        end
        guidata(h_fig, h);
    else
        for i = 1:nChan
            spots_raw{1,i} = h.param.movPr.SFres{1,1+nChan+i};
        end
    end

    spots = selectSpots(spots_raw, h_fig);
    for i = 1:nChan
        h.param.movPr.SFres{2,i} = spots{1,i};
    end
    guidata(h_fig, h);
end



function spots = determineSpots(param, img, lb, h_fig)
% Target bright spots in the img and return their coordinates.
% "param" >> {1-by-n+1} cell array containing targetting parameters for
% each of the n channels (start in 2nd cell)
% "img" >> image
% "h_fig" >> MASH figure handle
% "spots" >> {1-by-n}cell array, contains coordinates of targetted spots in
% each of the n channels

% Requires external functions: isScreen, loading_bar, spotGaussFit
% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

h = guidata(h_fig);
p = h.param.movPr;

nChan = p.nChan;
spots = cell(1,nChan);

SFtype = p.SF_method;
imgY = h.movie.pixelY;
imgX = h.movie.pixelX;
peaksNb = imgX*imgY;
gaussFit = p.SF_gaussFit;

sub_w = floor(imgX/nChan);
lim = [0 (1:nChan-1)*sub_w imgX];

warning('on', 'verbose');
warning('off', 'stats:nlinfit:IterationLimitExceeded');
warning('off', 'stats:nlinfit:IllConditionedJacobian');
warning('off', 'stats:nlinfit:ModelConstantWRTParam');
warning('off', 'MATLAB:nearlySingularMatrix');
warning('off', 'MATLAB:rankDeficientMatrix');
warning('off', 'MATLAB:singularMatrix');


for i = 1:nChan
    int = img(:, lim(i)+1:lim(i+1));
    spotSize = param{1,i+1}(1,:);
    darkArea = param{1,i+1}(2,:);
    minInt = param{1,i+1}(3,1);
    ratioInt = param{1,i+1}(3,2);
    
    if SFtype == 2 % in-serie screening
        spots{1,i} = isScreen(int, peaksNb, minInt, darkArea);
        if ~isempty(spots{1,i})
            spots{1,i}(:,1) = spots{1,i}(:,1) + (i-1)*sub_w;
        end

    elseif SFtype == 3 % houghpeaks
        peaks = houghpeaks(double(round(int)), peaksNb, 'Threshold', minInt, ...
            'NHoodSize', [darkArea(2) darkArea(1)]);
        if ~isempty(peaks)
            I = zeros(size(peaks,1),1);
            for j = 1:size(peaks,1)
                I(j,1) = int(peaks(j,1), peaks(j,2));
            end
            spots{1,i} = [peaks(:,2)-0.5 peaks(:,1)-0.5 I];
            spots{1,i}(:,1) = spots{1,i}(:,1) + (i-1)*sub_w;
        else
            spots{1,i} = [];
        end
        
    elseif SFtype == 4 % Schmied2012
        d_edge =darkArea(2);
        peaks = spotfinder_schmied2012_mash(double(int), ratioInt, d_edge);
        if ~isempty(peaks)
            I = zeros(size(peaks,1),1);
            for j = 1:size(peaks,1)
                I(j,1) = int(ceil(peaks(j,2)), ceil(peaks(j,1)));
            end
            spots{1,i} = [peaks(:,1)-0.5 peaks(:,2)-0.5 I];
            spots{1,i}(:,1) = spots{1,i}(:,1) + (i-1)*sub_w;
        else
            spots{1,i} = [];
        end
        
    elseif SFtype == 5 % Twotone
        peaks = spotfinder_2tone_withoutGauss_mash(int, darkArea(1), ...
            minInt);
        if ~isempty(peaks)
            I = zeros(size(peaks,1),1);
            for j = 1:size(peaks,1)
                I(j,1) = int(ceil(peaks(j,2)), ceil(peaks(j,1)));
            end
            spots{1,i} = [peaks(:,1)-0.5 peaks(:,2)-0.5 I];
            spots{1,i}(:,1) = spots{1,i}(:,1) + (i-1)*sub_w;
        else
            spots{1,i} = [];
        end
        
    end

    if gaussFit
        spots_itrm = selectSpots(spots, h_fig);
        nbSpots = size(spots_itrm{1,i},1);
        if ~lb
            % loading bar parameters---------------------------------------
            intrupt = loading_bar('init', h_fig, nbSpots, ...
                ['Fitting peaks in channel ' num2str(i) '...']);
            if intrupt
                return;
            end
            h = guidata(h_fig);
            h.barData.prev_var = h.barData.curr_var;
            guidata(h_fig, h);
            % -------------------------------------------------------------
        end

        [res intrupt] = spotGaussFit(spots_itrm{1,i}, img, spotSize, ...
            lb, h_fig);
        spots{1,i} = res;

        if ~lb && ~intrupt
            loading_bar('close', h_fig);
        end
    end
end

warning('off', 'verbose');
warning('on', 'stats:nlinfit:IterationLimitExceeded');
warning('on', 'stats:nlinfit:IllConditionedJacobian');
warning('on', 'stats:nlinfit:ModelConstantWRTParam');
warning('on', 'MATLAB:nearlySingularMatrix');
warning('on', 'MATLAB:rankDeficientMatrix');
warning('on', 'MATLAB:singularMatrix');



