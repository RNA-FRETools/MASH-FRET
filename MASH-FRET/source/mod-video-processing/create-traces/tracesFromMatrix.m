function trace = tracesFromMatrix(matrix,zTot,lim,aDim,nPix,mute)

% defaults
nbytes = 0;

nCoord = numel(lim.Xinf);
aDim2 = aDim^2;
trace = zeros(zTot,nCoord);
prev = 0;
for c = 1:nCoord
    
    if ~mute && round(100*c/nCoord)>prev
        prev = round(100*c/nCoord);
        nbytes = dispProgress(['Generating intensity-time traces: ' ...
            num2str(prev) '%%\n'],nbytes);
    end
    
    y0 = lim.Yinf(c);
    x0 = lim.Xinf(c);
    
    % get average sub-image
    id_x = x0:(x0+aDim-1);
    id_y = y0:(y0+aDim-1);
    trace_vect = reshape(matrix(id_y,id_x,:),[aDim2,zTot])';
    [o,id] = sort(mean(trace_vect,1),2,'descend');

    trace(:,c) = sum(trace_vect(:,id(1:nPix)),2);

end

