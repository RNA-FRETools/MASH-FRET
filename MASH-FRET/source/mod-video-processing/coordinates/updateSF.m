function prm = updateSF(img, lb, prm, h_fig)
% prm = updateSF(img, lb, prm, h_fig)
%
% Find spots in the image and select coordinates according to selection rules.
%
% img: current video frame
% lb: 1 if a loading bar is already opened, 0 otherwise
% prm: processing parameters
% h_fig: handle to main figure

% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic

% collect processing parameters
meth = prm.gen_crd{2}{1}(1);
sfcoord = prm.gen_crd{2}{4};

if meth<=1
    return
end

% no result: run spotfinder
if all(cellfun('isempty',sfcoord))
    [spots,ok] = determineSpots(img, lb, prm, h_fig);
    if ~ok
        return
    end
    prm.gen_crd{2}{4} = spots;

% recover results from previous spotfinder run
else
    spots = prm.gen_crd{2}{4};
end

% apply selection rules
[imgY,imgX] = cellfun(@size,img);
prm.gen_crd{2}{5} = selectSpots(spots,imgX,imgY,prm);


function [spots,ok] = determineSpots(cellimg, lb, prm, h_fig)
% [spots,ok] = determineSpots(cellimg, lb, p, h_fig)
%
% Target bright spots in the image and return their coordinates.
%
% cellimg: {1-by-nMov} input image
% lb: 1 if a loading bar is already opened, 0 otherwise
% prm: processing parameters
% h_fig: handle to main figure
% "spots" >> {1-by-n}cell array, contains coordinates of targetted spots in
% each of the n channels

% Requires external functions: isScreen, loading_bar, spotGaussFit
% Last update: 5th of February 2014 by Mélodie C.A.S Hadzic


% collect processing parameters
meth = prm.gen_crd{2}{1}(1);
gaussfit = prm.gen_crd{2}{1}(2);
sfprm = prm.gen_crd{2}{2};
nChan = size(sfprm,1);
multichanvid = numel(cellimg)==1;

% initialize output
ok = 1;
spots = cell(1,nChan);

warning('on', 'verbose');
warning('off', 'stats:nlinfit:IterationLimitExceeded');
warning('off', 'stats:nlinfit:IllConditionedJacobian');
warning('off', 'stats:nlinfit:ModelConstantWRTParam');
warning('off', 'MATLAB:nearlySingularMatrix');
warning('off', 'MATLAB:rankDeficientMatrix');
warning('off', 'MATLAB:singularMatrix');

for i = 1:nChan
    
    if multichanvid
        img = cellimg{1};
        [imgY,imgX] = size(img);
        peaksNb = imgX*imgY;
        sub_w = floor(imgX/nChan);
        int = img(:,((c-1)*sub_w+1):c*sub_w);
    else
        img = cellimg{c};
        [imgY,imgX] = size(img);
        peaksNb = imgX*imgY;
        sub_w = 0;
        int = img;
    end

    minInt = sfprm(i,1);
    ratioInt = sfprm(i,2);
    darkArea = sfprm(i,[3,4]);
    spotSize = sfprm(i,[5,6]);
    
    switch meth
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
            if exist('forloop','file')~=3
                h = guidata(h_fig);
                if h.mute_actions
                    disp('MASH-FRET will proceed to file compilation...');
                else
                    setContPan(cat(2,'MASH-FRET will proceed to file ',...
                        'compilation...'),'warning',h_fig);
                end
                mex(which('forloop.c'));
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

    if ~gaussfit
        continue
    end
    
    % cancelled by MH, 9.2.2020
%     spots = selectSpots(spots, imgX, imgY);

    N = size(spots{i},1);
    if ~lb
        if loading_bar('init',h_fig,N,...
                sprintf('Fitting peaks in channel %i',i))
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



