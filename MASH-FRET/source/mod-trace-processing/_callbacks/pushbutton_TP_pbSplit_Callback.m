function pushbutton_TP_pbSplit_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
n = p.ttPr.curr_mol(proj);
N = numel(p.proj{proj}.coord_incl);
nC = p.proj{proj}.nb_channel;
nL = p.proj{proj}.nb_excitations;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
expt0 = p.proj{proj}.sampling_time;
expt = p.proj{proj}.resampling_time;
meth = p.proj{proj}.TP.curr{n}{2}{1}(2);
cutOff0 = round(p.proj{proj}.TP.curr{n}{2}{1}(4+meth)/nL);
if cutOff0>=sum(p.proj{proj}.bool_intensities(:,n))
    return
end

% convert cutoff to original sampling
cutOff = ceil(cutOff0*expt/expt0);

if ~h.mute_actions
    choice = questdlg({cat(2,'The right-side of the trace will be saved to ',...
        'molecule ',num2str(n+1),'. This operation in irreversible'),...
        cat(2,'After splitting, the following functionalites must not be used',...
        ' on molecule ',num2str(n+1),':'),...
        '-  "recenter" option in panel Sub-images',...
        '-  dynamic background correction',...
        '',...
        'Do you want to continue?'},'Confirm trace split','Yes, split it',...
        'Cancel','Cancel');
    if ~strcmp(choice,'Yes, split it')
        return
    end
end

% show process
setContPan('Splitting trajectories...','process',h_fig);

% calculate indexes
mol_id = [1:n,n:N];
int_id = repmat((mol_id-1)*nC,[nC,1])+repmat((1:nC)',[1,size(mol_id,2)]);
int_id = int_id(:)';
fret_id = repmat((mol_id-1)*nFRET,[nFRET,1])+...
    repmat((1:nFRET)',[1,size(mol_id,2)]);
fret_id = fret_id(:)';
s_id = repmat((mol_id-1)*nS,[nS,1])+repmat((1:nS)',[1,size(mol_id,2)]);
s_id = s_id(:)';

% duplicate project data
if ~isempty(p.proj{proj}.coord)
    p.proj{proj}.coord = p.proj{proj}.coord(mol_id,:);
end
p.proj{proj}.coord_incl = p.proj{proj}.coord_incl(mol_id);
p.proj{proj}.intensities = p.proj{proj}.intensities(:,int_id,:);
p.proj{proj}.intensities_bgCorr = ...
    p.proj{proj}.intensities_bgCorr(:,int_id,:);
p.proj{proj}.intensities_bin = p.proj{proj}.intensities_bin(:,int_id,:);
p.proj{proj}.intensities_crossCorr = ...
    p.proj{proj}.intensities_crossCorr(:,int_id,:);
p.proj{proj}.intensities_denoise = ...
    p.proj{proj}.intensities_denoise(:,int_id,:);
p.proj{proj}.intensities_DTA = p.proj{proj}.intensities_DTA(:,int_id,:);
p.proj{proj}.ES = cell(size(p.proj{proj}.ES));
if ~isempty(p.proj{proj}.FRET_DTA)
    p.proj{proj}.FRET_DTA = p.proj{proj}.FRET_DTA(:,fret_id);
end
if ~isempty(p.proj{proj}.S_DTA)
    p.proj{proj}.S_DTA = p.proj{proj}.S_DTA(:,s_id);
end
if ~isempty(p.proj{proj}.FRET_DTA_import)
    p.proj{proj}.FRET_DTA_import = p.proj{proj}.FRET_DTA_import(:,fret_id);
end
p.proj{proj}.bool_intensities = p.proj{proj}.bool_intensities(:,mol_id);
p.proj{proj}.dt = {};
p.proj{proj}.molTag = p.proj{proj}.molTag(mol_id,:);

% copy right side of the orginal trace to duplicate molecule
chan_id_n = ((n-1)*nC+1):n*nC;
chan_id_dup = (n*nC+1):(n+1)*nC;
fret_id_n = ((n-1)*nFRET+1):n*nFRET;
fret_id_dup = (n*nFRET+1):(n+1)*nFRET;
s_id_n = ((n-1)*nS+1):n*nS;
s_id_dup = (n*nS+1):(n+1)*nS;
L = size(p.proj{proj}.intensities,1);
frames_right = (cutOff+1):L;
L_right = numel(frames_right);

p.proj{proj}.intensities(:,chan_id_dup,:) = NaN;
p.proj{proj}.intensities(1:L_right,chan_id_dup,:) = ...
    p.proj{proj}.intensities((cutOff+1):end,chan_id_n,:);

p.proj{proj}.intensities_bgCorr(:,chan_id_dup,:) = NaN;
p.proj{proj}.intensities_bgCorr(1:L_right,chan_id_dup,:) = ...
    p.proj{proj}.intensities_bgCorr((cutOff+1):end,chan_id_n,:);

% p.proj{proj}.intensities_crossCorr(:,chan_id_dup,:) = NaN;
% p.proj{proj}.intensities_crossCorr(1:L_right,chan_id_dup,:) = ...
%     p.proj{proj}.intensities_crossCorr((cutOff+1):end,chan_id_n,:);
% 
% p.proj{proj}.intensities_denoise(:,chan_id_dup,:) = NaN;
% p.proj{proj}.intensities_denoise(1:L_right,chan_id_dup,:) = ...
%     p.proj{proj}.intensities_denoise((cutOff+1):end,chan_id_n,:);
% 
% p.proj{proj}.intensities_DTA(:,chan_id_dup,:) = NaN;
% p.proj{proj}.intensities_DTA(1:L_right,chan_id_dup,:) = ...
%     p.proj{proj}.intensities_DTA((cutOff+1):end,chan_id_n,:);
% 
% p.proj{proj}.bool_intensities(:,n+1) = false;
% p.proj{proj}.bool_intensities(1:L_right,n+1) = true;
% 
% if ~isempty(p.proj{proj}.FRET_DTA)
%     p.proj{proj}.FRET_DTA(:,fret_id_dup,:) = NaN;
%     p.proj{proj}.FRET_DTA(1:L_right,fret_id_dup,:) = ...
%     	p.proj{proj}.FRET_DTA((cutOff+1):(cutOff+L_right),fret_id_n,:);
% end
% if ~isempty(p.proj{proj}.S_DTA)
%     p.proj{proj}.S_DTA(:,s_id_dup,:) = NaN;
%     p.proj{proj}.S_DTA(1:L_right,s_id_dup,:) = ...
%         p.proj{proj}.S_DTA((cutOff+1):(cutOff+L_right),s_id_n,:);
% end

% set unprocessed duplicated traces to NaN
p.proj{proj}.intensities_bin(:,[chan_id_n,chan_id_dup],:) = NaN;
p.proj{proj}.intensities_crossCorr(:,[chan_id_n,chan_id_dup],:) = NaN;
p.proj{proj}.intensities_denoise(:,[chan_id_n,chan_id_dup],:) = NaN;
p.proj{proj}.intensities_DTA(:,[chan_id_n,chan_id_dup],:) = NaN;
p.proj{proj}.bool_intensities(:,[n,n+1]) = false;
p.proj{proj}.bool_intensities(1:cutOff0,n) = true;
p.proj{proj}.bool_intensities((cutOff0+1):end,n+1) = true;
if ~isempty(p.proj{proj}.FRET_DTA)
    p.proj{proj}.FRET_DTA(:,[fret_id_n,fret_id_dup],:) = NaN;
end
if ~isempty(p.proj{proj}.S_DTA)
    p.proj{proj}.S_DTA(:,[s_id_n,s_id_dup],:) = NaN;
end
if ~isempty(p.proj{proj}.FRET_DTA_import)
    p.proj{proj}.FRET_DTA_import(:,[fret_id_n,fret_id_dup],:) = NaN;
end

% set right side of the original trace to NaN
p.proj{proj}.intensities(frames_right,chan_id_n,:) = NaN;
p.proj{proj}.intensities_bgCorr(frames_right,chan_id_n,:) = NaN;
% p.proj{proj}.intensities_crossCorr(frames_right,chan_id_n,:) = NaN;
% p.proj{proj}.intensities_denoise(frames_right,chan_id_n,:) = NaN;
% p.proj{proj}.intensities_DTA(frames_right,chan_id_n,:) = NaN;
% p.proj{proj}.bool_intensities(frames_right,chan_id_n,:) = false;
% if ~isempty(p.proj{proj}.FRET_DTA)
%     p.proj{proj}.FRET_DTA(frames_right,fret_id_n,:) = NaN;
% end
% if ~isempty(p.proj{proj}.S_DTA)
%     p.proj{proj}.S_DTA(frames_right,s_id_n,:) = NaN;
% end

% update processing parameters
p.proj{proj}.TP.prm = p.proj{proj}.TP.prm(mol_id);
p.proj{proj}.TP.curr = p.proj{proj}.TP.curr(mol_id);
p.proj{proj}.TP.curr{n+1}{2}{1}(4) =  1;
p.proj{proj}.TP.curr{n+1}{2}{1}(4+meth) = L_right*nL;
p.proj{proj}.TP.curr{n}{2}{1}(1) = true;

% add tag
if ~sum(~cellfun('isempty',strfind(p.proj{proj}.molTagNames,'split')))
    p.proj{proj}.molTagNames = cat(2,p.proj{proj}.molTagNames,'split');
    p.proj{proj}.molTagClr = cat(2,p.proj{proj}.molTagClr,'#bdbdbd');
    p.proj{proj}.molTag = cat(2,p.proj{proj}.molTag,...
        false(size(p.proj{proj}.molTag,1),1));
end
p.proj{proj}.molTag([n,n+1],...
    ~cellfun('isempty',strfind(p.proj{proj}.molTagNames,'split'))) = true;

set(h.text_molTot, 'String', ['total: ' num2str(N+1) ' molecules']);

h.param = p;
guidata(h_fig,h);

updateFields(h_fig,'ttPr');

% show success
setContPan(['Trajectories of molecule',num2str(n),' were successfully ',...
    'split at position ',num2str(cutOff),'!'],'success',h_fig);

