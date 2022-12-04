function proj = downCompatibilityVP(proj)
% proj = downCompatibilityVP(proj)
%
% Manage down-compatibility of video processing parameters for older projects

nChan = proj.nb_channel;
res_x = proj.movie_dim{1}(1);
prm = proj.VP.prm;

% adapt to single-channel videos
if ~iscell(prm.res_plot{1})
    % adapt images
    prm.res_plot{1} = prm.res_plot(1); % multi-channel video frames
    prm.res_plot{2} = prm.res_plot(2); % multi-channel average images
    
    % adapt coordinates
    chansplit = [0,prm.plot{2},res_x];
    coordsf = cell(1,nChan);
    for c = 1:nChan
        coordsf{c} = prm.res_crd{1}(...
            prm.res_crd{1}(:,2)>=chansplit(2*(c-1)+1) && ...
            prm.res_crd{1}(:,2)<chansplit(2*c),:);
    end
    prm.res_crd{1} = coordsf;
end

proj.VP.prm = prm;