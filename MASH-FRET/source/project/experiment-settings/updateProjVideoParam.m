function proj = updateProjVideoParam(proj,multichan)
% proj = updateProjVideoParam(proj,multichan)
%
% Resets project video parameters and resizes parameters according to
% import mode.
%
% proj: project's data structure
% multichan: 1 for multi-channel video or 0 for single-channel videos import modes

switch multichan
    case 1 % multi-channel video
        if all(~cellfun('isempty',proj.movie_file))
            movie_file = proj.movie_file(1);
            movie_dat = proj.movie_dat(1);
            movie_dim = proj.movie_dim(1);
            aveImg = proj.aveImg(1,:);
        else
            movie_file = {[]};
            movie_dat = {[]};
            movie_dim = {[]};
            aveImg = cell(1,proj.nb_excitations+1);
        end
        
    case 0 % single-channel videos
        movie_file = cell(1,proj.nb_channel);
        movie_dat = cell(1,proj.nb_channel);
        movie_dim = cell(1,proj.nb_channel);
        aveImg = cell(proj.nb_channel,proj.nb_excitations+1);
        if size(proj.aveImg,2)~=(proj.nb_excitations+1)
            proj.aveImg = aveImg;
        end

        for c = 1:min([numel(proj.movie_file),proj.nb_channel])
            if ~isempty(proj.movie_file{c})
                movie_file{c} = proj.movie_file{c};
                movie_dat{c} = proj.movie_dat{c};
                movie_dim{c} = proj.movie_dim{c};
                aveImg(c,:) = proj.aveImg(c,:);
            end
        end
        
    otherwise
        disp('updateProjVideoParam: unknown mode.');
        return
end

proj.movie_file = movie_file;
proj.movie_dat = movie_dat;
proj.movie_dim = movie_dim;
proj.aveImg = aveImg;
proj.is_movie = all(~cellfun('isempty',movie_file));
