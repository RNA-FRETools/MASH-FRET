% FS added 8.1.2018
function pushbutton_optGamma_Callback(obj, evd, h)

% Last update: by MH, 3.4.2019
% >> use the same button to load gamma files (in manual mode) or open 
%    photobleaching-based parameters

p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{5}{4}(1);
    
    % modified by MH, 3.4.2019
%     gammaOpt(h.figure_MASH);
    switch method
        case 0 % manual: load gamma from files
            pushbutton_loadGamma_Callback(0,[],h.figure_MASH);
            
        case 1 % photobleaching-based: photo-bleaching otpions
            gammaOpt(h.figure_MASH);
    end
end