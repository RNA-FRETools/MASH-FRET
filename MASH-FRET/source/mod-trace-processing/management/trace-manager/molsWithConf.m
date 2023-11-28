function molIncl = molsWithConf(dat,dat_type,prm,varargin)

units = prm(3,1);
meth = prm(3,2);

switch dat_type
    
    case 'trace'
        incl = varargin{1};
        M = size(incl,2);
        molIncl = false(1,M);
        
        id_end = 0;
        for m = 1:M
            id_start = id_end + 1;
            id_end = id_start + sum(incl(:,m)) - 1;
            N0 = numel(id_start:id_end);
            
            if size(dat,2)==1 % 1D
                N = sum(dat(id_start:id_end,1)>=prm(1,1) & ...
                    dat(id_start:id_end,1)<=prm(1,2));
            else % 2D
                N = sum(dat(id_start:id_end,1)>=prm(1,1) & ...
                    dat(id_start:id_end,1)<=prm(1,2) & ...
                    dat(id_start:id_end,2)>=prm(2,1) & ...
                    dat(id_start:id_end,2)<=prm(2,2));
            end
                
            switch meth
                case 1 % at least
                    if units==1 && 100*(N/N0)>=prm(4,1) % percent
                        molIncl(m) = true;
                    elseif units==2 && N>=prm(4,1) % absolute count
                        molIncl(m) = true;
                    end

                case 2 % at most
                    if units==1 && 100*(N/N0)<=prm(4,1) % percent
                        molIncl(m) = true;
                    elseif units==2 && N<=prm(4,1) % absolute count
                        molIncl(m) = true;
                    end

                case 3 % between
                    if units==1 && 100*(N/N0)>=prm(4,1) && ...
                            100*(N/N0)<=prm(4,2) % percent
                        molIncl(m) = true;
                    elseif units==2 && N>=prm(4,1) && ...
                            N<=prm(4,2) % absolute count
                        molIncl(m) = true;
                    end
            end
        end
        
    case 'value'
        if size(dat,2)==1 % 1D
            molIncl = dat'>=prm(1,1) & dat'<=prm(1,2);
        else % 2D
            molIncl = dat(:,1)'>=prm(1,1) & dat(:,1)'<=prm(1,2) & ...
                dat(:,2)'>=prm(2,1) & dat(:,2)'<=prm(2,2);
        end
        
    case 'state' % 2D
        if size(dat,2)==2 % 1D
            states = dat(:,1)'>=prm(1,1) & dat(:,1)'<=prm(1,2);
        else % 2D
            states = dat(:,2)'==dat(:,4)' & ...
                dat(:,1)'>=prm(1,1) & dat(:,1)'<=prm(1,2) & ...
                dat(:,3)'>=prm(2,1) & dat(:,3)'<=prm(2,2);
        end
        
        mols = unique(dat(:,2))';
        match = unique(dat(states,2))';
        molIds = [];
        for m = match
            molIds = cat(2,molIds,find(mols==m,1));
        end
        M = numel(mols);
        molIncl = false(1,M);
        molIncl(molIds) = true;
        
end
