function v = writeAviFile(mode,varargin)
% Format and write video metadata and pixel data to a .avi file.
%
% mode: writing stage ('init','append')
% varargin: for stage 'init', {1} path to destination file and {2} exposure time (in seconds)
% varargin: for stage 'append', {1} videoWriter object, {2} video frame pixel data
%
% v: created or updated videoWriter object

% Created by MH, 5.12.2019

if strcmp(mode,'init')
    fullfname = varargin{1};
    expt = varargin{2};
    
    v = VideoWriter(fullfname,'Uncompressed AVI');
    v.FrameRate = 1/expt;
    open(v);
    
elseif strcmp(mode,'append')
    v = varargin{1};
    img = varargin{2};
    
    img_avi = cat(3,img,img,img);
    img_avi = uint8(255*(img_avi-min(min(img)))/...
        (max(max(img))-min(min(img))));
    writeVideo(v,img_avi);

%         imgAvi = typecast(uint16(img(:)),'uint8');
%         imgAvi = reshape(imgAvi,2,res_y*res_x);
%         imgFin = uint8(zeros(res_y,res_x,3));
%         for r = 1:2
%             imgFin(:,:,r) = uint8(reshape(imgAvi(r,:),res_y,res_x));
%         end
%         writeVideo(v,imgFin);
end
