function f = writeSiraFile(mode,varargin)
% Format and write video metadata and pixel data to a .sira file.
%
% mode: writing stage ('init','append')
% varargin: for stage 'init' {1} MASH-FRET version string and {2} [1-by-4] video metadata (1) exposure time, (2) video pixel width, (3) video pixel height, (4) video length; for stage 'append', {1} pixel data of one video frame, {2} number of pixels in one video frame
% varargin: for stage 'append' {1} .sira file identifier, {2} video frame pixel data, {3} number of pixels in video frame
%
% f: .sira file identifier

% Created by MH, 5.12.2019

if strcmp(mode,'init')
    fullfname = varargin{1};
    vers = varargin{2};
    metadat = varargin{3};
    
    % open file to export
    f = fopen(fullfname, 'w');
    if f == -1
        return;
    end
    
    % write video meta data
    fprintf(f, 'MASH-FRET exported binary graphic Version: %s\r',vers);
    fwrite(f, double(metadat(1)),'double');
    fwrite(f, single(metadat(2)),'single');
    fwrite(f, single(metadat(3)),'single');
    fwrite(f, single(metadat(4)),'single');
    
elseif strcmp(mode,'append')
    f = varargin{1};
    img = varargin{2};
    nPix = varargin{3};
    
    min_img = min(min(img));
    if min_img >= 0
        min_img = 0;
    end

    img = single(img+abs(min_img));
    imgBin = [reshape(img,1,nPix) single(abs(min_img))];

    fwrite(f,imgBin,'single');
end

