function menu_binTimeAxis_Callback(obj,evd,varargin)
% menu_binTimeAxis_Callback([],[])
% menu_binTimeAxis_Callback([],[],expT)
% menu_binTimeAxis_Callback([],[],expT,pname)
% menu_binTimeAxis_Callback([],[],expT,pname,fileheaders)
% menu_binTimeAxis_Callback([],[],expT,pname,fileheaders,pname_out)
%
% expT: desired time bin (in second)
% pname: source directory
% fileheaders: cellstring file headers that specify data to export
% pname_out: destination directory

if isempty(varargin)
    expT = inputdlg('Please define a new time bin (in seconds):',...
        'New time bin');
    if isempty(expT)
        return
    end
    if numel(str2double(expT{1}))~=1
        disp('Bin time is ill defined.');
        return
    end
    binTrajFiles(str2double(expT{1}));
    
else
    expT = varargin{1};
    if size(varargin,2)>=2
        pname = varargin{2};
        if size(varargin,2)>=3
            fileheaders = varargin{3};
            if size(varargin,2)>=4
                pname_out = varargin{4};
                binTrajFiles(expT,pname,fileheaders,pname_out);
            else
                binTrajFiles(expT,pname,fileheaders);
            end
        else
            binTrajFiles(expT,pname);
        end
    else
        binTrajFiles(expT);
    end
end
