function menu_restructFiles_Callback(obj,evd,varargin)
% menu_restructFiles_Callback([],[])
% menu_restructFiles_Callback([],[],pname)
% menu_restructFiles_Callback([],[],pname,wavelength)
% menu_restructFiles_Callback([],[],pname,wavelength,pname_out)
%
% pname: source directory
% wavelengths: 1-by-(nFRET+nS) laser wavelengths for donor- and emitter-specific illuminations used in FRET and stoichiometry calculations 
% pname_out: destination directory

if isempty(varargin)
    restruct_trace_file;
elseif size(varargin,2)>=1
    pname = varargin{1};
    if size(varargin,2)>=2
        wavelengths = varargin{2};
        if size(varargin,2)>=3
            pname_out = varargin{3};
            restruct_trace_file(pname,wavelengths,pname_out);
        else
            restruct_trace_file(pname,wavelengths);
        end
    else
        restruct_trace_file(pname);
    end
end