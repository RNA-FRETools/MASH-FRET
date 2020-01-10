% FS added 8.1.2018
function pushbutton_optGamma_Callback(obj, evd, h_fig)

% Last update: by MH, 3.4.2019
% >> use the same button to load gamma files (in manual mode) or open 
%    photobleaching-based parameters

h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{6}{2}(1);
    
    % modified by MH, 3.4.2019
%     gammaOpt(h_fig);
    switch method
        case 0 % manual: load gamma from files
            pushbutton_loadGamma_Callback(0,[],h_fig);
            
        case 1 % photobleaching-based: photo-bleaching otpions
            gammaOpt(h_fig);
        
        case 2 % photobleaching-based: photo-bleaching otpions
            ESlinRegOpt(h_fig);
    end
end