% FS added 8.1.2018
function pushbutton_optGamma_Callback(obj, evd, h_fig)
% pushbutton_optGamma_Callback([],[],h_fig)
% pushbutton_optGamma_Callback(factor_files,[],h_fig)
%
% h_fig: handle to main figure
% factor_files: {1-by-2} source directory and files for correction factors (.bet or .gam)

% Last update by MH, 8.3.2020: allow file selection via function arguments (routine call)
% update by MH, 3.4.2019: use the same button to load gamma files (in manual mode) or open photobleaching-based parameters

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
fret = p.proj{proj}.TP.fix{3}(8);
method = p.proj{proj}.TP.curr{mol}{6}{2}(fret);

switch method
    case 0 % manual: load gamma from files
        if iscell(obj)
            pname = obj{1};
            fnames = obj{2};
            if ~strcmp(pname(end),filesep)
                pname = [pname,filesep];
            end
            pushbutton_loadFactors_Callback({pname,fnames},[],h_fig);
        else
            pushbutton_loadFactors_Callback([],[],h_fig);
        end

    case 1 % photobleaching-based: photo-bleaching otpions

        % show process
        setContPan('Opening Gamma factor calculation options...','process',...
            h_fig);
        
        gammaOpt(h_fig);

        % show success
        setContPan('Gamma factor calculation options ready!','success',...
            h_fig);

    case 2 % photobleaching-based: photo-bleaching otpions

        % show process
        setContPan('Opening Gamma factor calculation options...','process',...
            h_fig);
            
        ESlinRegOpt(h_fig);

        % show success
        setContPan('Gamma factor calculation options ready!','success',...
            h_fig);
end
