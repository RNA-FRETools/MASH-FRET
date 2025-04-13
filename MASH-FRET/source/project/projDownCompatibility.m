function p = projDownCompatibility(p,projs)
% p = projDownCompatibility(p,projs)
%
% Check fields of project structure and manage compatibility with older
% versions
%
% p: structure containing interface parameters
% projs: indexes of projects

for i = projs
    if ~isfield(p.proj{i},'folderRoot')
        p.proj{i}.folderRoot = pwd;
    end

    if ~isfield(p.proj{i},'sim')
        p.proj{i}.sim = [];
    end
    
    % down compatibility
    if ~isfield(p.proj{i},'VP')
        p.proj{i}.VP = [];
    end

    if ~isfield(p.proj{i},'TP')
        p.proj{i}.TP = [];
        if isfield(p.proj{i}, 'fix')
            p.proj{i}.TP.fix = p.proj{i}.fix;
            p.proj{i} = rmfield(p.proj{i},'fix');
        elseif isfield(p.proj{i}, 'fixTT')
            p.proj{i}.TP.fix = p.proj{i}.fixTT;
            p.proj{i} = rmfield(p.proj{i},'fixTT');
        end
        if isfield(p.proj{i}, 'expTT')
            p.proj{i}.TP.exp = p.proj{i}.expTT;
            p.proj{i} = rmfield(p.proj{i},'expTT');
        end
        if isfield(p.proj{i}, 'prmTT')
            p.proj{i}.TP.prm = p.proj{i}.prmTT;
            p.proj{i} = rmfield(p.proj{i}, 'prmTT');
        end
    end
    
    if ~isfield(p.proj{i},'HA')
        p.proj{i}.HA = [];
        if isfield(p.proj{i},'prmThm')
            p.proj{i}.HA.prm = p.proj{i}.prmThm;
            p.proj{i} = rmfield(p.proj{i}, 'prmThm');
        end
        if isfield(p.proj{i},'expThm')
            p.proj{i}.HA.exp = p.proj{i}.expThm;
            p.proj{i} = rmfield(p.proj{i}, 'expThm');
        end
    end

    if ~isfield(p.proj{i},'TA')
        p.proj{i}.TA = [];
        if isfield(p.proj{i},'prmTDP')
            p.proj{i}.TA.prm = p.proj{i}.prmTDP;
            p.proj{i} = rmfield(p.proj{i}, 'prmTDP');
        end
        if isfield(p.proj{i}, 'expTDP')
            p.proj{i}.TA.exp = p.proj{i}.expTDP;
            p.proj{i} = rmfield(p.proj{i}, 'expTDP');
        end
    end
    
    % tag project
    if isfield(p.proj{i},'intensities') && ~isempty(p.proj{i}.intensities)
        if p.proj{i}.is_movie && p.proj{i}.is_coord
            if ~isfield(p.proj{i}.VP,'from')
                p.proj{i}.VP.from = 'VP';
                p.proj{i}.TP.from = 'VP';
                p.proj{i}.HA.from = 'VP';
                p.proj{i}.TA.from = 'VP';
            end
        elseif ~isfield(p.proj{i}.TP,'from')
            p.proj{i}.TP.from = 'TP';
            p.proj{i}.HA.from = 'TP';
            p.proj{i}.TA.from = 'TP';
        end
    end
    
    % adapt trajectory file structure parameters to new format
    if isfield(p.proj{i},'traj_import_opt') && ...
            ~isempty(p.proj{i}.traj_import_opt) && ...
            numel(p.proj{i}.traj_import_opt)>=1 && ...
            numel(p.proj{i}.traj_import_opt{1})~=5
        opt = p.proj{i}.traj_import_opt{1};
        newopt = cell(1,5);
        newopt{1} = [opt{1}([1:4,7,9]),1]; % add onemol
        newopt{2} = opt{1}{2};
        newopt{3} = [repmat((opt{1}{1}(5):opt{1}{1}(6))',[1,2]),...
            zeros(p.proj{i}.nb_channel,0)]; % add skip
        for l = 1:size(opt{1}{3},1)
            newopt{4} = cat(3,newopt{4},...
                [repmat((opt{1}{3}(l,1):opt{1}{3}(l,2))',[1,2]),...
                zeros(p.proj{i}.nb_channel,0)]); % add skip
        end
        newopt{5} = [...
            repmat((opt{1}{1}(10):opt{1}{1}(12):opt{1}{1}(11))',[1,2]),...
            zeros(size(p.proj{i}.FRET,1),0)];
        p.proj{i}.traj_import_opt{1} = newopt;
    end
    
    % 2.12.2022: add field "FRET_DTA_import"
    if ~isfield(p.proj{i},'FRET_DTA_import')
        p.proj{i}.FRET_DTA_import = [];
    end
    
    % 28.11.2023: replace field "frame_rate" by "sampling_time" and add 
    % field "resampling_time
    if isfield(p.proj{i},'frame_rate')
        p.proj{i}.sampling_time = p.proj{i}.frame_rate;
        p.proj{i} = rmfield(p.proj{i},'frame_rate');
    end
    if ~isfield(p.proj{i},'resampling_time')
        p.proj{i}.resampling_time = p.proj{i}.sampling_time;
    end
    
    % 16.02.2024: add field "intensities_bin"
    if ~isfield(p.proj{i},'intensities_bin')
        p.proj{i}.intensities_bin = p.proj{i}.intensities_bgCorr;
    end

    % 12.04.2025: add field "emitter_is_on"
    if ~isfield(p.proj{i},'emitter_is_on')
        p.proj{i}.emitter_is_on = reshape(...
            repmat(p.proj{i}.bool_intensities,nChan,1),...
            [size(p.proj{i}.bool_intensities,1),[]]);
    end
end
