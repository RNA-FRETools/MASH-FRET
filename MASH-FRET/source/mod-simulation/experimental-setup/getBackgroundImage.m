function [img_bg,err] = getBackgroundImage(prm)
% Create fluorescent background image (background values in photon count per frame)
%
% prm: simulation parameters
% img_bg: fluorescent background image
% err: potential error message

% update 29.11.2019 by MH: move script from plotExample.m to this separate file; this allows to call the same script from plotExample.m and exportResults.m, preventing unilateral modifications
% update 20.4.2019 by MH: correct "Pattern" background: the background image is now split in two with donor and acceptor channel having the left and right half images as background.

% initialize returned arguments
err = '';
img_bg = [];

% collect simulation parameters
res_x =  prm.gen_dat{1}{2}{1}(1);
res_y = prm.gen_dat{1}{2}{1}(2);
bgtype = prm.gen_dat{8}{1};
bgdon = prm.gen_dat{8}{2}(1);
bgacc = prm.gen_dat{8}{2}(2);
tirfdim = prm.gen_dat{8}{3};
bgimg = prm.gen_dat{8}{4}{1};

% initialize background image
splt = round(res_x/2);
img_bg_don = zeros(res_y,splt);
img_bg_acc = zeros(res_y,res_x-splt);

switch bgtype
    case 1 % constant
        img_bg_don = bgdon*ones(res_y,splt);
        img_bg_acc = bgacc*ones(res_y,(res_x-splt));

    case 2 % TIRF profile
        lim_don.x = [1,splt]; 
        lim_don.y = [1,res_y];
        q.amp = bgdon;
        q.mu(1) = round(res_x/4);
        q.mu(2) = round(res_y/2);
        q.sig = tirfdim;
        [img_bg_don,o] = getImgGauss(lim_don,q,0);
        
        lim_acc.x = [1,res_x-splt]; 
        lim_acc.y = [1,res_y];
        q.amp = bgacc;
        [img_bg_acc,o] = getImgGauss(lim_acc,q,0);

    case 3 % patterned
        if ~isempty(bgimg)
            img_bg_don = bgimg(:,1:size(img_bg_don,2));
            img_bg_acc = bgimg(:,size(img_bg_don,2)+1:end);
        else
            err = 'No BG pattern loaded.';
            return;
        end
end

img_bg = [img_bg_don,img_bg_acc];
