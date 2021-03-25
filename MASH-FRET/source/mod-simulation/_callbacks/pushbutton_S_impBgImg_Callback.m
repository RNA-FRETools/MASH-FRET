function pushbutton_S_impBgImg_Callback(obj,evd,h_fig)

if iscell(obj)
    file2sub = [obj{1},filesep,obj{2}];
    d = getFile2sub('Pick a BG pattern image', h_fig, file2sub);
else
    d = getFile2sub('Pick a BG pattern image', h_fig);
end
if isempty(d)
    return
end

h = guidata(h_fig);
p = h.param.sim;

if strcmp(p.intUnits, 'electron')
    [o,K,eta] = getCamParam(p.noiseType,p.camNoise);
    d.frameCur = ele2phtn(d.frameCur,K,eta);
    if size(d.frameCur,3)>1
        d.frameCur = sum(d.frameCur,3);
    end
    if size(d.frameCur,1)~=p.movDim(1) || size(d.frameCur,2)~=p.movDim(2)
        setContPan(cat(2,'Dimensions of the background image are not ',...
            'consistent with video dimensions: please adjust video ',...
            'dimensions or modify the dimensions of the background ',...
            'image.'),'error',h_fig);
        return
    end
end

p.bgImg = d;

h.param.sim = p;
guidata(h_fig,h);

ud_S_expSetupPan(h_fig);
