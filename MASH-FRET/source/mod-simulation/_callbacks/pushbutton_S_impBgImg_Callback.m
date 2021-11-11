function pushbutton_S_impBgImg_Callback(obj,evd,h_fig)

if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
    file2sub = [pname,fname];
    d = getFile2sub('Pick a BG pattern image', h_fig, file2sub);
else
    d = getFile2sub('Pick a BG pattern image', h_fig);
end
if isempty(d)
    return
end

% retrieve project content
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
curr = p.proj{proj}.sim.curr;

% collect simulation parameters
inun = curr.gen_dat{3}{2};
noisetype = curr.gen_dat{1}{2}{4};
noiseprm = curr.gen_dat{1}{2}{5};
viddim = curr.gen_dat{1}{2}{1};

if strcmp(inun, 'electron')
    [o,K,eta] = getCamParam(noisetype,noiseprm);
    d.frameCur = ele2phtn(d.frameCur,K,eta);
    if size(d.frameCur,3)>1
        d.frameCur = sum(d.frameCur,3);
    end
    if size(d.frameCur,1)~=viddim(1) || size(d.frameCur,2)~=viddim(2)
        setContPan(cat(2,'Dimensions of the background image are not ',...
            'consistent with video dimensions: please adjust video ',...
            'dimensions or modify the dimensions of the background ',...
            'image.'),'error',h_fig);
        return
    end
end

curr.gen_dat{8}{4}{1} = d.frameCur;
curr.gen_dat{8}{4}{2} = d.file;

% save modifications
p.proj{proj}.sim.curr = curr;
h.param = p;
guidata(h_fig,h);

ud_S_expSetupPan(h_fig);
