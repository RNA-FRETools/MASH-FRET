function [img_bg,err] = getBackgroundImage(p)
% Create fluorescent background image (background values in photon count per frame)
%
% p: structure containing simulation parameters that must have fields:
%   p.movDim: video dimensions in the x- and y- dimensions (in pixels)
%   p.bgType: fluorescent background type (1, 2 or 3)
%   p.bgInt_don: BG intensities in pc (for p.bgType 1 or 2)
%   p.bgInt_acc: BG intensities in pc (for p.bgType 1 or 2)
%   p.TIRFdim: TIRF profile widths (for p.bgType 2)
%   p.bgImg.frameCur: patterned background matrix (for p.bgType 3)
%
% img_bg: fluorescent background image
% err: potential error message

% Last update: 29.11.2019 by MH
% >> move script from plotExample.m to this separate file; this allows to 
%    call the same script from plotExample.m and exportResults.m,
%    preventing unilateral modifications
%
% update: 20.4.2019 by Mélodie Hadzic
% >> correct "Pattern" background: the background image is now split in two
%    with donor and acceptor channel having the left and right half images 
%    as background.

% initialize returned arguments
err = '';
img_bg = [];

% initialize background image
res_x = p.movDim(1); % movie with
res_y = p.movDim(2); % movie height
splt = round(res_x/2);
img_bg_don = zeros(res_y,splt);
img_bg_acc = zeros(res_y,res_x-splt);

switch p.bgType
    case 1 % constant
        img_bg_don = p.bgInt_don*ones(res_y,splt);
        img_bg_acc = p.bgInt_acc*ones(res_y,(res_x-splt));

    case 2 % TIRF profile
        lim_don.x = [1,splt]; 
        lim_don.y = [1,res_y];
        q.amp = p.bgInt_don;
        q.mu(1) = round(res_x/4);
        q.mu(2) = round(res_y/2);
        q.sig = p.TIRFdim;
        [img_bg_don,o] = getImgGauss(lim_don,q,0);
        
        lim_acc.x = [1,res_x-splt]; 
        lim_acc.y = [1,res_y];
        q.amp = p.bgInt_acc;
        [img_bg_acc,o] = getImgGauss(lim_acc,q,0);

    case 3 % patterned
        if isfield(p,'bgImg') && ~isempty(p.bgImg)
            bgImg = p.bgImg.frameCur;
            img_bg_don = bgImg(:,1:size(img_bg_don,2));
            img_bg_acc = bgImg(:,size(img_bg_don,2)+1:end);
        else
            err = 'No BG pattern loaded.';
            return;
        end
end

img_bg = [img_bg_don,img_bg_acc];
