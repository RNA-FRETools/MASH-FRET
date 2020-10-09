function pushbutton_trMap_Callback(obj, evd, h_fig)
% pushbutton_trMap_Callback([],[],h_fig)
% pushbutton_trMap_Callback(refImgFile,[],h_fig)
%
% h_fig: handle to main figure
% refImageFile: {1-by-2} source folder and file containing reference image

% get image file to map
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname,'filesep')
        pname = cat(2,pname,filesep);
    end
else
    [fname,pname,o] = uigetfile({'*.png;*.tif','Image file(*.png;*.tif)';
        '*.*', 'All Files (*.*)'},'Select an image file for mapping', ...
        setCorrectPath('average_images', h_fig));
end
if ~sum(fname)
    return
end
[o,o,fext] = fileparts(fname);
if ~(strcmp(fext,'.png') || strcmp(fext,'.tif'))
    updateActPan('Wrong file format. Only PNG and TIF files are supported', ...
        h_fig, 'success');
    return
end
cd(pname);

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% import image
img = imread([pname fname]);

% open mapping tool
nC = p.nChan;
res_x = size(img,2);
lim_x = [0 (1:nC-1)*round(res_x/nC) res_x];

openMapping(img, lim_x, h_fig, fname);
