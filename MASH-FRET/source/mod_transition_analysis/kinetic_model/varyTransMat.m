function [mat,bestgof] = varyTransMat(mat,gof,j1s,degen,step,r,expPrm,opt,h_fig)
% [mat,bestgof] = varyTransMat(mat,gof,j1s,degen,step,r,expPrm,opt,h_fig)
%
% Increment each cell of the input matrix up to the maximum value and decrement down to he minimum value while the goodness of fit of the corresponding kinetic model is increasing. 
% Returns the matrix giving the best fit.
%
% mat: matrix to vary
% gof: goodness of fit for the input matrix (-Inf if no previous fit)
% j1s: vector containing row indexes of the matrix to be processed
% degen: {1-by-V} column vectors grouping indexes of degenerated states
% step: increment (positive or negative)
% r: transition rate constants restricted to 2 states (in s-1)
% expPrm: structure containing experimental data and parameters, with fields:
%  expPrm.dt: [nDt-by-3] dwell times (seconds) and state indexes before and after transition
%  expPrm.Ls: [1-by-N] experimental trajectory lengths
%  expPrm.expT: binning time
%  expPrm.fitPrm: fitting parameters
%  expPrm.excl: (1) to exclude first and last dwell times of each sequence, (0) otherwise
%  expPrm.isFixed: (only for opt=='n')
%  expPrm.sumConstr: (only for opt=='n')
% opt: 'n','w' or 'tp' to optimize the matrix of number of transitions (fixed restricted rates), the repartition probability matrix (fixed restricted rates) or the transition probability matrix respectively
% bestgof: goodness of fit of best optimization

% defaults
valmax = 1;
valmin = 0;

J = size(mat,2);
if strcmp(opt,'n') || strcmp(opt,'k')
    degenTrans = false(J);
    V = numel(degen);
    for v = 1:V
        degenTrans(degen{v}(1):degen{v}(end),degen{v}(1):degen{v}(end)) = true;
    end
    Ntot = sum(mat(~degenTrans)); % total number of transitions excluding transitions between degenerated states
end

alliter = mat;
allgof = gof;
for j1 = j1s
    for j2 = 1:J
        if j2==j1
            continue
        end
        if strcmp(opt,'n') || strcmp(opt,'k')
            if expPrm.isFixed(j1,j2)
                continue
            end
            valmax = min(min(...
                expPrm.sumConstr{j1,j2}(expPrm.sumConstr{j1,j2}>0)));
            if isinf(valmax) % transition between degenerated states
                valmax = Ntot;
            end
        end
        
%         vardown = true;
%         varup = true;
%         if mat(j1,j2)<=valmin
%             vardown = false;
%         end
%         if mat(j1,j2)>=valmax
%             varup = false;
%         end
        
        % chose sens of variation (increment or decrement or both)
        vardown = false;
        varup = false;
        if mat(j1,j2)>valmin
            if strcmp(opt,'n') || strcmp(opt,'k') % decreases number of transitions
                mat_down = incrConstRowColSumMat(mat,j1,j2,-step,...
                    expPrm.isFixed,expPrm.sumConstr); 
            else % decreases transition probability
                    mat_down = setTransProb(mat,j1,j2,-step,opt); 
            end
            
            if ~isempty(mat_down)
                [gof_down,res] = ...
                    kinMdlGOF(degen,mat_down,r,expPrm,opt,h_fig);
                if ~isempty(res)
                    switch opt
                        case 'w'
                            mat_down = res.w_exp;
                        case 'tp'
                            mat_down = res.tp_exp;
                        case 'n'
                            mat_down = res.n_exp;
                        case 'k'
                            mat_down = res.k_exp;
                    end
                end
                if gof_down>gof
                    vardown = true;
                end
            end
        end
        if mat(j1,j2)<valmax
            if strcmp(opt,'n') || strcmp(opt,'k') % increases number of transitions
                mat_up = incrConstRowColSumMat(mat,j1,j2,step,...
                    expPrm.isFixed,expPrm.sumConstr); 
            else % increases transition probability
                mat_up = setTransProb(mat,j1,j2,step,opt); 
            end
            if ~isempty(mat_up)
                [gof_up,res] = kinMdlGOF(degen,mat_up,r,expPrm,opt,h_fig);
                if ~isempty(res)
                    switch opt
                        case 'w'
                            mat_up = res.w_exp;
                        case 'tp'
                            mat_up = res.tp_exp;
                        case 'n'
                            mat_up = res.n_exp;
                        case 'k'
                            mat_down = res.k_exp;
                    end
                end
                if gof_up>gof
                    varup = true;
                end
            end
        end
        
        % up iteration
        if varup
%             fact = 0;
%             allgof = cat(2,allgof,-Inf);
%             alliter = cat(3,alliter,zeros(J));
%             mat_up = mat;
%             prevVal = -Inf;
%             while mat_up(j1,j2)<valmax && mat_up(j1,j2)>prevVal
%                 prevVal = mat_up(j1,j2);
%                 fact = fact+1;
%                 switch opt
%                     case 'n' % increases number of transitions
%                         mat_up = incrConstRowColSumMat(mat,j1,j2,fact*step,...
%                             expPrm.isFixed,expPrm.sumConstr);
%                     otherwise % increases transition probability
%                         mat_up = setTransProb(mat,j1,j2,fact*step,opt);
%                 end
%                 if isempty(mat_up)
%                     break
%                 end
%                 [gof_up,res] = kinMdlGOF(degen,mat_up,r,expPrm,opt,h_fig);
%                 if ~isempty(res)
%                     switch opt
%                         case 'w'
%                             mat_up = res.w_exp;
%                         case 'tp'
%                             mat_up = res.tp_exp;
%                         case 'n'
%                             mat_up = res.n_exp;
%                     end
%                 end
%                 if gof_up>allgof(end)
%                     alliter(:,:,end) = mat_up;
%                     allgof(end) = gof_up;
%                 end
%             end
            
            gof_up_prev = gof;
            while gof_up>gof_up_prev

                gof_up_prev = gof_up;
                mat_up_prev = mat_up;
                if mat_up(j1,j2)==valmax
                    break
                end
                if strcmp(opt,'n') || strcmp(opt,'k') % increases number of transitions
                    mat_up = incrConstRowColSumMat(mat_up,j1,j2,step,...
                        expPrm.isFixed,expPrm.sumConstr);
                else% increases transition probability
                    mat_up = setTransProb(mat_up,j1,j2,step,opt);
                end
                if isempty(mat_up)
                    mat_up = mat_up_prev;
                    gof_up = gof_up_prev;
                    break
                end
                [gof_up,res] = kinMdlGOF(degen,mat_up,r,expPrm,opt,h_fig);
                if ~isempty(res)
                    switch opt
                        case 'w'
                            mat_up = res.w_exp;
                        case 'tp'
                            mat_up = res.tp_exp;
                        case 'n'
                            mat_up = res.n_exp;
                        case 'k'
                            mat_down = res.k_exp;
                    end
                end
                if gof_up<=gof_up_prev
                    mat_up = mat_up_prev;
                    gof_up = gof_up_prev;
                end
            end
            alliter = cat(3,alliter,mat_up);
            allgof = cat(2,allgof,gof_up);
        end

        % down iteration
        if vardown
%             mat_down = mat;
%             fact = 0;
%             allgof = cat(2,allgof,-Inf);
%             alliter = cat(3,alliter,zeros(J));
%             prevVal = Inf;
%             while mat_down(j1,j2)>valmin && mat_down(j1,j2)<prevVal
%                 prevVal = mat_down(j1,j2);
%                 fact = fact+1;
%                 switch opt
%                     case 'n' % increases number of transitions
%                         mat_down = incrConstRowColSumMat(mat,j1,j2,-fact*step,...
%                             expPrm.isFixed,expPrm.sumConstr);
%                     otherwise % increases transition probability
%                         mat_down = setTransProb(mat,j1,j2,-fact*step,opt);
%                 end
%                 if isempty(mat_down)
%                     break
%                 end
%                 [gof_down,res] = kinMdlGOF(degen,mat_down,r,expPrm,opt,h_fig);
%                 if ~isempty(res)
%                     switch opt
%                         case 'w'
%                             mat_down = res.w_exp;
%                         case 'tp'
%                             mat_down = res.tp_exp;
%                         case 'n'
%                             mat_down = res.n_exp;
%                     end
%                 end
%                 if gof_down>allgof(end)
%                     alliter(:,:,end) = mat_down;
%                     allgof(end) = gof_down;
%                 end
%             end

            gof_down_prev = gof;
            while gof_down>gof_down_prev

                gof_down_prev = gof_down;
                mat_down_prev = mat_down;
                if mat_down(j1,j2)==valmin
                    break
                end
                if strcmp(opt,'n') || strcmp(opt,'k') % decreases number of transitions
                    mat_down = incrConstRowColSumMat(mat_down,j1,j2,...
                        -step,expPrm.isFixed,expPrm.sumConstr);
                else % decreases transition probability
                    mat_down = setTransProb(mat_down,j1,j2,-step,opt);
                end
                if isempty(mat_down)
                    mat_down = mat_down_prev;
                    gof_down = gof_down_prev;
                    break
                end
                [gof_down,res] = ...
                    kinMdlGOF(degen,mat_down,r,expPrm,opt,h_fig);
                if ~isempty(res)
                    switch opt
                        case 'w'
                            mat_down = res.w_exp;
                        case 'tp'
                            mat_down = res.tp_exp;
                        case 'n'
                            mat_down = res.n_exp;
                        case 'k'
                            mat_down = res.k_exp;
                    end
                end
                if gof_down<=gof_down_prev
                    mat_down = mat_down_prev;
                    gof_down = gof_down_prev;
                end
            end
            alliter = cat(3,alliter,mat_down);
            allgof = cat(2,allgof,gof_down);
        end
    end
end

[bestgof,bestiter] = max(allgof);
mat = alliter(:,:,bestiter);

