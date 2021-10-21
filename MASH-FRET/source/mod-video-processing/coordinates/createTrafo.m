function tr = createTrafo(method, refCoord, h_fig)
% Create the matrices of spatial transformations calculated from reference 
% coordinates file, to obtain acceptor from donor (tform2) and donor from
% acceptor (tform1) and save it to a *_trafo.mat file.

% Requires external function: updateActPan, setCorrectPath,
%                             setCorrectFname.

% MH, last update 27.03.2019
% >> adapt the function for newer versions of MATLAB: transformation are
%    calculated using the MATLAB's fitgeotrans function

tr = {};
nChan = size(refCoord,2)/2;

% check MATLAB version for compatibility.
% cp2tform works fine on MATLAB 2016a (9.0), even though 
% fitgeotrans was introduced with MATLAB 2013b (8.2)
matlabver = ver;
for v = 1:numel(matlabver)
    if strcmp(matlabver(v).Name,'MATLAB')
        matlabver = str2num(matlabver(v).Version);
        break
    end
end
    
% Perform spatial transformation
switch method
    case 1
        if matlabver<=9
            tform_type = 'nonreflective similarity';
        else
            tform_type = 'nonreflectivesimilarity';
        end
        tform_name = 'nrsim';
        n_min = 2;
    case 2
        tform_type = 'similarity';
        tform_name = 'sim';
        n_min = 3;
    case 3
        tform_type = 'affine';
        tform_name = 'aff';
        n_min = 3;
    case 4
        tform_type = 'projective';
        tform_name = 'proj';
        n_min = 4;
    case 5
        tform_type = 'polynomial';
        tform_order = 2;
        tform_name = 'pol2';
        n_min = 6;
    case 6
        tform_type = 'polynomial';
        tform_order = 3;
        tform_name = 'pol3';
        n_min = 10;
    case 7
        tform_type = 'polynomial';
        tform_order = 4;
        tform_name = 'pol4';
        n_min = 15;
    case 8
        if matlabver<=9
            tform_type = 'piecewise linear';
        else
            tform_type = 'pwl';
        end
        tform_name = 'plin';
        n_min = 4;
        
    case 9
        tform_type = 'lwm';
        tform_name = 'lwm';
        tform_order = 12; % MATLAB default
        n_min = 12;
        
    otherwise
        setContPan(cat(2,'Transformation type no supported'),'error',...
            h_fig);
        return
end

if size(refCoord,1)<n_min
    setContPan(cat(2,'At least ',num2str(n_min),' non-collinear points ',...
        'needed to infer ',tform_type,' (',tform_name,') transform'),...
        'error',h_fig);
    return
end


tr = cell(nChan*(nChan-1),2);
l = 1;
for i = 1:nChan
    for j = 1:nChan
        if i ~= j
            % tr(j-->i) = obtain channel i from channel j
            tr{l,1} = [j i];
            
            if exist('tform_order', 'var') && tform_order >= 2
                
                if matlabver<=9
                    tr{l,2} = cp2tform(refCoord(:,2*j-1:2*j), ...
                                       refCoord(:,2*i-1:2*i), ...
                                       tform_type, tform_order);
                else
                    tr{l,2} = fitgeotrans(refCoord(:,2*j-1:2*j), ...
                                       refCoord(:,2*i-1:2*i), ...
                                       tform_type, tform_order);
                end

            elseif ~exist('tform_order', 'var')
                if matlabver<=9
                    tr{l,2} = cp2tform(refCoord(:,2*j-1:2*j), ...
                                       refCoord(:,2*i-1:2*i), ...
                                       tform_type);
                else
                    tr{l,2} = fitgeotrans(refCoord(:,2*j-1:2*j), ...
                                       refCoord(:,2*i-1:2*i), ...
                                       tform_type);
                end
            end
            l = l+1;
        end
    end
end

