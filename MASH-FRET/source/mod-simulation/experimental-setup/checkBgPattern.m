function [ok, prm] = checkBgPattern(prm, h_fig)

% 13.10.2021 by MH: adapt to new prm/curr structure
% 20.04.2019 by MH: (1) correct intensity units conversion, (2) control dimensions of background image and manage communication with user.

ok = 1;

% collect simulation parameters
viddim = prm.gen_dat{1}{2}{1};
noisetype = prm.gen_dat{1}{2}{4};
noiseprm = prm.gen_dat{1}{2}{5};
inun = prm.gen_dat{3}{2};
bgimg = prm.gen_dat{8}{4}{1};

if ~isempty(bgimg)
    return
end

data = getFile2sub('Pick a BG pattern image', h_fig);
if isempty(data)
    ok = 0;
    return
end
if strcmp(inun,'electron')
    [o,K,eta] = getCamParam(noisetype,noiseprm);
    data.frameCur = ele2phtn(data.frameCur,K,eta);
    if size(data.frameCur,3)>1
        data.frameCur = sum(data.frameCur,3);
    end
    if size(data.frameCur,1)~=viddim(1) || size(data.frameCur,2)~=viddim(2)
        setContPan(cat(2,'Dimensions of the background image are not ',...
            'consistent with video dimensions: please adjust video ',...
            'dimensions or modify the dimensions of the background ',...
            'image.'),'error',h_fig);
        ok = 0;
        return
    end
end

prm.gen_dat{8}{4}{1} = data.frameCur;
prm.gen_dat{8}{4}{2} = data.file;

