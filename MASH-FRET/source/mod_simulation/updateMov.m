function updateMov(h_fig)
% updateMov create and plot the intensity-time traces of one donor and
% acceptor according to the simulated discretised FRET time course and to
% the background/noise intensity.
%
% Requires external file: setContPan.m

% Last update by MH, 6.12.2019
% >> reset PSF factorisation matrix (matGauss) when coordinates are 
%  imported from a pre-set file and some are excluded along the way: size 
%  conflict was happenning after two successive "generate" runs
%
% Last update: 7th of March 2018 by Richard Börner
% >> Comments adapted for Boerner et al 2017
%
% Created the 23rd of April 2014 by Mélodie C.A.S Hadzic

h = guidata(h_fig);

if isfield(h, 'results') && isfield(h.results, 'sim') && ...
        isfield(h.results.sim, 'mix') && ~isempty(h.results.sim.mix)
    
    setContPan('Updating intensity data...', 'process', h_fig);
    
    mix = h.results.sim.mix;
    discr_seq = h.results.sim.discr_seq;
    totInt = h.param.sim.totInt;
    Itot_w = h.param.sim.totInt_width;
    gamma = h.param.sim.gamma;
    gammaW = h.param.sim.gammaW;
    genCoord = h.param.sim.genCoord;
    impPrm = h.param.sim.impPrm;
    molPrm = h.param.sim.molPrm;
    fretVal_id = h.param.sim.stateVal;
    fret_w = h.param.sim.FRETw;
    matGauss = h.param.sim.matGauss;
    N = h.param.sim.nbFrames;
    
    if size(mix{1},2)<N
        setContPan({['Error: The kinetic model has to few data points ' ...
            'to satisfy the parameter length'], ['Push the "Generate" ' ...
            'button to re-simulate the model.']}, 'error', h_fig);
        return;
    end

    res_x = h.param.sim.movDim(1);
    res_y = h.param.sim.movDim(2);
    Iacc = {};
    Iacc_id = {};
    Idon = {};
    Idon_id = {};
    discr = cell(1,size(mix,2));
    
    if ~(impPrm && isfield(molPrm, 'coord'))
        genCoord = 1;
    end
    
    if genCoord && (size(h.param.sim.coord,1)~=size(mix,2) || ...
            size(h.param.sim.coord,2)~=4 || ...
            size(matGauss{1},2)~=size(mix,2))
        coord = zeros(size(mix,2),4);
        matGauss = cell(1,4);
        newCoord = 1;
        
    else
        newCoord = 0;
        if impPrm && isfield(molPrm, 'coord')
            coord = molPrm.coord;
        else
            coord = h.param.sim.coord;
        end
    end
    
    max_n = min([size(mix,2) size(coord,1)]);
    if max_n == 0
        if ~genCoord
            setContPan('Error: no coordinates loaded.', 'error', h_fig);
        else
            setContPan('Error: the number of molecules must be > 0.', ...
                'error', h_fig);
        end
        return;
    end
    
    str = {};
    excl = [];
    for n = 1:max_n
        if ~genCoord && ~(size(coord,1) >= n && coord(n,1) > 0 && ...
                coord(n,1) < round(res_x/2) && coord(n,3) >= ...
                round(res_x/2) && coord(n,3) < res_x && ...
                sum(double(coord(n,[2 4]) > 0)) &&...
                sum(double(coord(n,[2 4]) < res_y)))
            excl = [excl n];
            if size(coord,1) >= n
                str = [str ['coordinates ' num2str(coord(n,:)) ...
                    ' excluded']];
            end
        else
            if newCoord
                coord(n,1:2) = [rand(1)*round(res_x/2) rand(1)*res_y];
                coord(n,3:4) = [(coord(n,1)+round(res_x/2)) coord(n,2)];
            end
            
            mix{n} = mix{n}(:,1:N);
            discr_seq{n} = discr_seq{n}(1:N,:);
            
            if impPrm && isfield(molPrm, 'stateVal')
                fretVal = molPrm.stateVal(n,:);
            else
                fretVal = random('norm', fretVal_id, fret_w);
            end
            fretVal(fretVal<0) = 0;
            fretVal(fretVal>1) = 1;
            
            discr{n} = sum(repmat(fretVal',[1 size(mix{n},2)]).*mix{n},1)';
            discr{n}(discr{n}<0 | isnan(discr{n})) = -1;
            
            if impPrm && isfield(molPrm, 'totInt');
                I_sum = random('norm', molPrm.totInt(n), ...
                    molPrm.totInt_width(n));
            else
                I_sum = random('norm', totInt, Itot_w);
            end
            I_sum(I_sum<0) = 0;
            
            if impPrm && isfield(molPrm, 'gamma');
                g_mol = random('norm', molPrm.gamma(n), molPrm.gammaW(n));
            else
                g_mol = random('norm', gamma, gammaW);
            end
            g_mol(g_mol<0) = 0;
        
            Iacc_id{size(Iacc_id,2)+1} = discr{n}*I_sum;
            Iacc_id{size(Iacc_id,2)}(Iacc_id{size(Iacc_id,2)}==-I_sum) = 0;
            Iacc{size(Iacc,2)+1} = Iacc_id{size(Iacc_id,2)};

            Idon_id{size(Idon_id,2)+1} = (1-discr{n})*I_sum;
            Idon_id{size(Idon_id,2)}(Idon_id{size(Idon_id,2)}==2*I_sum) ...
                = 0;
            
            % inverse gamma correction for the different quantum and detection efficiencies of donor and acceptor 
            % Idon_exp = Idon_id/gamma
            Idon{size(Idon,2)+1} = Idon_id{size(Idon_id,2)}/g_mol;
        end
    end
    
    discr_seq(excl) = [];
    discr(excl) = [];
    coord(excl,:) = [];
    
    % added by MH, 6.12.2019
    if sum(excl) && impPrm && isfield(molPrm, 'coord') 
        matGauss = cell(2,1);
    else
        if ~isempty(p.matGauss{1})
            matGauss{1}(excl) = [];
        end
        if ~isempty(p.matGauss{2})
            matGauss{2}(excl) = [];
        end
    end
    
    h.results.sim.dat = {Idon Iacc coord};
    h.results.sim.dat_id = {Idon_id Iacc_id discr discr_seq};
    h.param.sim.coord = coord;
    h.param.sim.matGauss = matGauss;
    guidata(h_fig, h);

    setSimCoordTable(h.param.sim.coord, h.uitable_simCoord);
    
    
    plotExample(h_fig);
    
    setContPan([str ['Success: A set of ' num2str(size(discr,2)) ...
        ' time traces has been successfully simulated from the kinetic' ...
        'model !'] ['The first traces of the set and the first frame ' ...
        'of the movie are shown.']], 'success', h_fig);
    
else
    setContPan({'Error: The kinetic model has to be defined first', ...
                'Push the "Generate" button first"'}, 'error', h_fig);
end



