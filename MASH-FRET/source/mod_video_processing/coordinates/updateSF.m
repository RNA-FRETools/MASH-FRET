function p = updateSF(img, lb, p, h_fig)
% p = updateSF(img, lb, p)
%
% Find spots in the image and select coordinates according to selection rules.
%
% img: current video frame
% lb: 1 if a loading bar is already opened, 0 otherwise
% p: sutructure containing processing parameters
% h_fig: handle to main figure

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

meth = p.SF_method;
if meth<=1
    return
end

% no result: run spotfinder
if size(p.SFres,1)<1
    spots = determineSpots(p.SFprm, img, lb, p, h_fig);
    p.SFres = spots;

% recover results from previous spotfinder run
else
    spots = p.SFres(1,:);
    p.SFres = spots;
end

% apply selection rules
[imgY,imgX] = size(img);
p.SFres = cat(1,p.SFres,selectSpots(spots, imgX, imgY, p));


function [spots,ok] = determineSpots(param, img, lb, p, h_fig)
% [spots,ok] = determineSpots(param, img, lb, p, h_fig)
%
% Target bright spots in the image and return their coordinates.
%
% param: {1-by-nChan+1} cell array containing spotfinder parameters
% img: input image
% lb: 1 if a loading bar is already opened, 0 otherwise
% p: sutructure containing processing parameters
% h_fig: handle to main figure
% "spots" >> {1-by-n}cell array, contains coordinates of targetted spots in
% each of the n channels

% Requires external functions: isScreen, loading_bar, spotGaussFit
% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

% initialize output
spots = cell(1,p.nChan);
ok = 1;

[imgY,imgX] = size(img);
peaksNb = imgX*imgY;

sub_w = floor(imgX/p.nChan);
lim = [0 (1:p.nChan-1)*sub_w imgX];

warning('on', 'verbose');
warning('off', 'stats:nlinfit:IterationLimitExceeded');
warning('off', 'stats:nlinfit:IllConditionedJacobian');
warning('off', 'stats:nlinfit:ModelConstantWRTParam');
warning('off', 'MATLAB:nearlySingularMatrix');
warning('off', 'MATLAB:rankDeficientMatrix');
warning('off', 'MATLAB:singularMatrix');


for i = 1:p.nChan
    int = img(:, lim(i)+1:lim(i+1));
    spotSize = param{1,i+1}(1,:);
    darkArea = param{1,i+1}(2,:);
    minInt = param{1,i+1}(3,1);
    ratioInt = param{1,i+1}(3,2);
    
    switch p.SF_method
        case 2 % in-serie screening
            spots{i} = isScreen(int, peaksNb, minInt, darkArea);
            if ~isempty(spots{i})
                spots{i}(:,1) = spots{i}(:,1) + (i-1)*sub_w;
            end

        case 3 % houghpeaks
            peaks = houghpeaks(double(round(int)), peaksNb, 'Threshold', ...
                minInt, 'NHoodSize', [darkArea(2) darkArea(1)]);
            if ~isempty(peaks)
                I = zeros(size(peaks,1),1);
                for j = 1:size(peaks,1)
                    I(j,1) = int(peaks(j,1), peaks(j,2));
                end
                spots{i} = [peaks(:,2)-0.5 peaks(:,1)-0.5 I];
                spots{i}(:,1) = spots{i}(:,1) + (i-1)*sub_w;
            else
                spots{i} = [];
            end

        case 4 % Schmied2012

            % check for correct compilation of mex file for method Schmied2012
            if exist('forloop','file')==3
                setContPan(cat(2,'This spotfinder method can not be used:',...
                    ' problem with mex compilation.'),'error',h_fig);
                return
            end

            d_edge =darkArea(2);
            peaks = spotfinder_schmied2012_mash(double(int), ratioInt, ...
                d_edge);
            if ~isempty(peaks)
                I = zeros(size(peaks,1),1);
                for j = 1:size(peaks,1)
                    I(j,1) = int(ceil(peaks(j,2)), ceil(peaks(j,1)));
                end
                spots{i} = [peaks(:,1)-0.5 peaks(:,2)-0.5 I];
                spots{i}(:,1) = spots{i}(:,1) + (i-1)*sub_w;
            else
                spots{i} = [];
            end

        case 5 % Twotone
            peaks = spotfinder_2tone_withoutGauss_mash(int, darkArea(1), ...
                minInt);
            if ~isempty(peaks)
                I = zeros(size(peaks,1),1);
                for j = 1:size(peaks,1)
                    I(j,1) = int(ceil(peaks(j,2)), ceil(peaks(j,1)));
                end
                spots{i} = [peaks(:,1)-0.5 peaks(:,2)-0.5 I];
                spots{i}(:,1) = spots{i}(:,1) + (i-1)*sub_w;
            else
                spots{i} = [];
            end
        
    end

    if ~p.SF_gaussFit
        continue
    end
    
    % cancelled by MH, 9.2.2020
%     spots = selectSpots(spots, imgX, imgY);

    N = size(spots{i},1);
    if ~lb
        if loading_bar('init',h_fig,N,...
                sprintf('Fitting peaks in channel %i',i));
            ok = 0;
            return
        end
        h = guidata(h_fig);
        h.barData.prev_var = h.barData.curr_var;
        guidata(h_fig, h);
    end

    [spots{i},intrupt] = spotGaussFit(spots{i}, img, spotSize, lb, h_fig);
    
    if intrupt
        ok = 0;
        return
    end
    if ~lb
        loading_bar('close', h_fig);
    end
end

warning('off', 'verbose');
warning('on', 'stats:nlinfit:IterationLimitExceeded');
warning('on', 'stats:nlinfit:IllConditionedJacobian');
warning('on', 'stats:nlinfit:ModelConstantWRTParam');
warning('on', 'MATLAB:nearlySingularMatrix');
warning('on', 'MATLAB:rankDeficientMatrix');
warning('on', 'MATLAB:singularMatrix');



