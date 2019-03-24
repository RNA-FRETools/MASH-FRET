function tr = createTrafo(method, refCoord, h_fig)
% Create the matrices of spatial transformations calculated from reference 
% coordinates file, to obtain acceptor from donor (tform2) and donor from
% acceptor (tform1) and save it to a *_trafo.mat file.

% Requires external function: updateActPan, setCorrectPath,
%                             setCorrectFname.
% Last update the 5th of February 2014 by Mélodie C.A.S. Hadzic

tr = {};
nChan = size(refCoord,2)/2;
    
% Perform spatial transformation
switch method
    case 2
        tform_type = 'nonreflective similarity';
        tform_name = 'nrsim';
        n_min = 2;
    case 3
        tform_type = 'similarity';
        tform_name = 'sim';
        n_min = 3;
    case 4
        tform_type = 'affine';
        tform_name = 'aff';
        n_min = 3;
    case 5
        tform_type = 'projective';
        tform_name = 'proj';
        n_min = 4;
    case 6
        tform_type = 'polynomial';
        tform_order = 2;
        tform_name = 'pol2';
        n_min = 6;
    case 7
        tform_type = 'polynomial';
        tform_order = 3;
        tform_name = 'pol3';
        n_min = 10;
    case 8
        tform_type = 'polynomial';
        tform_order = 4;
        tform_name = 'pol4';
        n_min = 15;
    case 9
        tform_type = 'piecewise linear';
        tform_name = 'plin';
        n_min = 4;
    case 10
        tform_type = 'lwm';
        tform_name = 'lwm';
        n_min = 12;
        
    otherwise
        setContPan(cat(2,'Transformation type no supported'),'error',...
            h_fig);
        return;
end

if size(refCoord,1)<n_min
    setContPan(cat(2,'At least ',num2str(n_min),' non-collinear points ',...
        'needed to infer ',tform_type,' (',tform_name,') transform'),...
        'error',h_fig);
    return;
end


tr = cell(nChan*(nChan-1),2);
l = 1;
for i = 1:nChan
    for j = 1:nChan
        if i ~= j
            % tr(j-->i) = obtain channel i from channel j
            tr{l,1} = [j i];

            if exist('tform_order', 'var') && tform_order >= 2
                tr{l,2} = cp2tform(refCoord(:,2*j-1:2*j), ...
                                   refCoord(:,2*i-1:2*i), ...
                                   tform_type, tform_order);

            elseif ~exist('tform_order', 'var')
                tr{l,2} = cp2tform(refCoord(:,2*j-1:2*j), ...
                                   refCoord(:,2*i-1:2*i), ...
                                   tform_type);
            end
            l = l+1;
        end
    end
end

