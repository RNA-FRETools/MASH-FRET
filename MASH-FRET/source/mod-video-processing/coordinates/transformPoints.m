function [xy_tr,ok] = transformPoints(tr,xy,nChan,h_fig)

ok = 1;

xy_tr = cell(1,nChan);
for i = 1:nChan
    xy_tr{i} = cell(1,nChan);
    xy_tr{i}{i} = xy{i};
end

for i = 1:nChan
    for j = 1:size(tr,1)
        
        tr_ij = tr{j,2};
            
        % old transformation file (<=2016a)
        if isfield(tr{j,2},'forward_fcn') && ~isempty(tr{j,2}.forward_fcn)
            cin = tr{j,1}(1);
            if cin == i
                cout = tr{j,1}(2);
                try
                    xy_tr{cout}{i} = tformfwd(tr_ij, xy{i});

                % manage error in case an old transformation file is used in a
                % nwer MATLAB version that does not support it
                catch err
                    updateActPan(['Impossible to apply transformation: ',...
                        'your transformation file might be written in an ',...
                        'old format, which is not supported by MATLAB ',...
                        'anymore.\n\nYou may re-create the transformation',...
                        ' file from your reference coordinates and try ',...
                        'again.\n\n,Error message:' err.message],h_fig, ...
                        'error');
                    ok = 0;
                    return
                end
            end

        % old transformation file (<=2016a)
        elseif isfield(tr{j,2},'inverse_fcn') && ...
                ~isempty(tr{j,2}.inverse_fcn)
            cout = tr{j,1}(2);
            if cout == i
                cin = tr{j,1}(1);
                try
                    xy_tr{cin}{i} = tforminv(tr_ij, xy{i});
                    ok = 1;
                    
                % manage error in case an old transformation file is used in a
                % nwer MATLAB version that does not support it
                catch err
                    updateActPan(['Impossible to apply transformation: ',...
                        'your transformation file might be written in an ',...
                        'old format, which is not supported by MATLAB ',...
                        'anymore.\n\nYou may re-create the transformation',...
                        ' file from your reference coordinates and try ',...
                        'again.\n\n,Error message:' err.message],h_fig, ...
                        'error');
                    ok = 0;
                    return
                end
            end

        % new transformation file (>2016a)
        elseif isa(tr{j,2},'projective2d') || isa(tr{j,2},'affine2d')
            cin = tr{j,1}(1);
            if cin == i
                cout = tr{j,1}(2);
                [xy_tr{cout}{i}(:,1),xy_tr{cout}{i}(:,2)] = ...
                    transformPointsForward(tr_ij,xy{i}(:,1),xy{i}(:,2));
                ok = 1;
            end

        % new transformation file (>2016a)
        elseif isa(tr{j,2},...
                'images.geotrans.LocalWeightedMeanTransformation2D') || ...
                isa(tr{j,2},'images.geotrans.PolynomialTransformation2D') ...
                || isa(tr{j,2},...
                'images.geotrans.PiecewiseLinearTransformation2D')
            cout = tr{j,1}(2);
            if cout == i
                cin = tr{j,1}(1);
                [xy_tr{cin}{i}(:,1),xy_tr{cin}{i}(:,2)] = ...
                    transformPointsInverse(tr_ij,xy{i}(:,1),xy{i}(:,2));
                ok = 1;
            end

        % corrupted transformation file
        else
            updateActPan(['Empty transform matrices.\nPlease check the import ' ...
                'options.'], h_fig, 'error');
            ok = 0;
            return
        end
    end
end