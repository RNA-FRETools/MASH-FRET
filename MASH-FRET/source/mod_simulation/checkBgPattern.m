function [ok, p] = checkBgPattern(p, h_fig)

% Last update: 20.4.2019 by Mélodie Hadzic
% >> correct intensity units conversion
% >> control dimensions of background image and manage communication with
%    user.

ok = 1;

if ~isfield(p, 'bgImg') || isempty(p.bgImg)
    data = getFile2sub('Pick a BG pattern image', h_fig);
    if isempty(data)
        ok = 0;
        return;
    end
    if strcmp(p.intUnits, 'electron')
        [mu_y_dark,K,eta] = getCamParam(p.noiseType,p.camNoise);
        data.frameCur = ele2phtn(data.frameCur,K,eta);
        if size(data.frameCur,3)>1
            data.frameCur = sum(data.frameCur,3);
        end
        if size(data.frameCur,1)~=p.movDim(1) || ...
                size(data.frameCur,2)~=p.movDim(2)
            setContPan(cat(2,'Dimensions of the background image are not ',...
                'consistent with video dimensions: please adjust video ',...
                'dimensions or modify the dimensions of the background ',...
                'image.'),'error',h_fig);
            ok = 0;
            return;
        end
    end
    p.bgImg = data;
else
    loadBG = questdlg('Load another BG pattern?', ...
        'Background image', 'Yes', 'No', 'No');
    if isempty(loadBG)
        ok = 0;
        return;
    elseif strcmp(loadBG, 'Yes')
        data = getFile2sub('Pick a BG pattern image', h_fig);
        if isempty(data)
            ok = 0;
            return;
        end
        if strcmp(p.intUnits, 'electron')
            [mu_y_dark,K,eta] = getCamParam(p.noiseType,p.camNoise);
            data.frameCur = ele2phtn(data.frameCur,K,eta);
            if size(data.frameCur,3)>1
                data.frameCur = sum(data.frameCur,3);
            end
            if size(data.frameCur,1)~=p.movDim(1) || ...
                    size(data.frameCur,2)~=p.movDim(2)
                setContPan(cat(2,'Dimensions of the background image are ',...
                    'not consistent with video dimensions: please adjust ',...
                    'video dimensions or modify the dimensions of the ',...
                    'background image.'),'error',h_fig);
                ok = 0;
                return;
            end
        end
        p.bgImg = data;
    end
end
