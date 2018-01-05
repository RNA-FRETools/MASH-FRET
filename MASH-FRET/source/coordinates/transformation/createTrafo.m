function tr = createTrafo(method, refCoord)
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
    case 3
        tform_type = 'similarity';
        tform_name = 'sim';
    case 4
        tform_type = 'affine';
        tform_name = 'aff';
    case 5
        tform_type = 'projective';
        tform_name = 'proj';
    case 6
        tform_type = 'polynomial';
        tform_order = 2;
        tform_name = 'pol2';
    case 7
        tform_type = 'polynomial';
        tform_order = 3;
        tform_name = 'pol3';
    case 8
        tform_type = 'polynomial';
        tform_order = 4;
        tform_name = 'pol4';
    case 9
        tform_type = 'piecewise linear';
        tform_name = 'plin';
    case 10
        tform_type = 'lwm';
        tform_name = 'lwm';
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

