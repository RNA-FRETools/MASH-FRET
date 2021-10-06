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
        if isfield(p.proj{i}, 'fixTT')
            p.proj{i}.TP.fix = p.proj{i}.fixTT;
            p.proj{i} = rmfield(p.proj{i},'fixTT');
        end
        if isfield(p.proj{i}, 'expTT')
            p.proj{i}.TP.exp = p.proj{i}.expTT;
            p.proj{i} = rmfield(p.proj{i},'expTT');
        end
        if ~isfield(p.proj{i}, 'prmTT')
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
end