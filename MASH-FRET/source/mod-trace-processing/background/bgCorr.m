function p = bgCorr(mol, p, h_fig)
proj = p.curr_proj;
nC = p.proj{proj}.nb_channel;

isBgCorr = ~isempty(p.proj{proj}.intensities_bgCorr) && ...
    ~all(sum(sum(isnan(p.proj{proj}.intensities_bgCorr(:, ...
    ((mol-1)*nC+1):mol*nC,:)),2),3));

if isBgCorr
    return
end
isCoord = p.proj{proj}.is_coord;
isMov = p.proj{proj}.is_movie;

I = p.proj{proj}.intensities(:,((mol-1)*nC+1):mol*nC,:);
I_bgCorr = I;

if ~(isCoord && isMov)
    for c = 1:size(I,2)
        for l = 1:size(I,3)
            p.proj{proj}.TP.prm{mol}{3}{2}(l,c) = 1; % method manual
        end
    end
end

bgcorrprm = p.proj{proj}.TP.prm{mol}{3};
for c = 1:size(I,2)
    for l = 1:size(I,3)
        
        dynbg = bgcorrprm{1}(l,c,2);
        meth = bgcorrprm{2}(l,c);
        methprm = bgcorrprm{3}{l,c}(meth,:);
        [bg,darkcoord] = calcbgint(mol,l,c,dynbg,meth,methprm,p.proj{proj},...
            h_fig);
        
        % save (mean) background intensity
        method = p.proj{proj}.TP.prm{mol}{3}{2}(l,c);
        p.proj{proj}.TP.prm{mol}{3}{3}{l,c}(method,3) = mean(bg);
        if method==6
            p.proj{proj}.TP.prm{mol}{3}{3}{l,c}(method,4:5) = darkcoord;
        end
        
        % subtract background to molecule trajectory
        apply = p.proj{proj}.TP.prm{mol}{3}{1}(l,c,1);
        if apply
            I_bgCorr(:,c,l) = I(:,c,l)-bg(:);
        end
    end
end

p.proj{proj}.intensities_bgCorr(:,((mol-1)*nC+1):mol*nC,:) = ...
    I_bgCorr;
p.proj{proj}.intensities_bin(:,((mol-1)*nC+1):mol*nC,:) = NaN;

