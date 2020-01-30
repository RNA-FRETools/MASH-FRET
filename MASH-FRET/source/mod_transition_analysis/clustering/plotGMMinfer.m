function plotGMMinfer(mat,clstDiag,J,mu,sig,w,h_axes)

nTrs = getClusterNb(J,mat,clstDiag);
[j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);

if mat
    trs = [mu(j1,1),mu(j2,1)];
else
    trs = mu;
end

obj = gmdistribution(trs, sig, w');

try
    Z = reshape(pdf(obj, [x_v y_v]), numel(y), numel(x));
    surface(h_axes, X, Y, Z, 'EdgeColor', 'none');
    set(h_axes, 'nextplot', 'add');
    plot3(h_axes, trs(:,1), trs(:,2), repmat(max(max(Z)),[nTrs 1]), '+r');
    title(h_axes, ['fit (J=' num2str(J) ')']);
    drawnow;
    
catch err
    disp(err.message);
end
