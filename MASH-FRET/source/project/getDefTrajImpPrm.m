function impTrajPrm = getDefTrajImpPrm(nChan,nExc)

impTrajPrm = {{[1 1 1 1 1 0 1],ones(1,nExc),repmat([1,1,0],nChan,1),...
    repmat([1,1,0],nChan,1,nExc),[]} ... % trajectory file structure
    {0,''} ... % video file
    {0,'',{reshape(1:2*nChan,2,nChan)',1},256} ... % coordinates file, file structure, video width
    [0,1] ... % coordinates in trajectory file
    [] ... % obsolete: old experimental parameters
    {0,'',{},0,'',{}}}; % gamma files, beta files