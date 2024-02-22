function proj = getExpSetSamplingTime(opt,proj,h_fig)
% proj = getExpSetSamplingTime(opt,proj,h_fig)
%
% Determine sampling time from video or trajectory files
%
% opt: trajectory import options
% proj: data structure
% h_fig: handle to figure "Experiment settings"

% defaults
splt = 1;

% retrieve interface content
h = guidata(h_fig);
h_fig0 = h.figure_MASH;

% determine sampling time
proj.spltime_from_video = false;
proj.spltime_from_traj = false;
if ~isempty(opt) && opt{1}{1}(3)
    rowwise = opt{1}{1}(5);
    fdat = h.table_fstrct.UserData;
    if ~isempty(fdat)
        nhline = opt{1}{1}(1);
        if rowwise==1
            tcol = opt{1}{1}(4);
            t0 = str2double(fdat{nhline+1,tcol});
            t1 = str2double(fdat{nhline+2,tcol});
            splt = t1-t0;
        else
            tcol_exc = opt{1}{2};
            nExc = numel(tcol_exc);
            t_exc = zeros(1,nExc);
            for exc = 1:nExc
                t = str2double(fdat{nhline+1,tcol_exc(exc)});
                if isempty(t)
                    break
                else
                    t_exc(exc) = t;
                end
            end
            if ~all(t_exc==0)
                [t_exc,~] = sort(t_exc);
                splt = t_exc(2)-t_exc(1);
            else
                splt = NaN;
            end
        end
        if ~isnan(splt)
            proj.spltime_from_traj = true;
        else
            splt = 1;
        end
    end
    
elseif proj.is_movie
    [dat,ok] = getFrames(proj.movie_file{1},1,[],h_fig0,true);
    if ok && dat.cycleTime~=1
        splt = dat.cycleTime;
        proj.spltime_from_video = true;
    end
end

% store new sampling time
proj.sampling_time = splt;
