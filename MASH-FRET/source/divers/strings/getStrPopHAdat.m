function str = getStrPopHAdat(proj)

% defaults
str = {};

% collects project's parameters
lbl = proj.labels;
FRET = proj.FRET;
S = proj.S;
exc = proj.excitations;
nChan = proj.nb_channel;
chanExc = proj.chanExc;
clr = proj.colours;
fromfile = isfield(proj,'hist_file') && ~isempty(proj.hist_file);

% calculates number of total intensities
nExc = numel(exc);
em0 = find(chanExc~=0);
inclem = true(1,numel(em0));
for em = 1:numel(em0)
    if ~sum(chanExc(em)==exc)
        inclem(em) = false;
    end
end
em0 = em0(inclem);

% builds popup's string
if fromfile
    for c = 1:nChan
        clrbg = sprintf('rgb(%i,%i,%i)',round(clr{1}{1,c}(1:3)*255));
        clrfg = sprintf('rgb(%i,%i,%i)',...
            [255 255 255]*(sum(clr{1}{1,c}(1:3))<=1.5));
        str = cat(2,str, ['<html><span style= "background-color: ' ...
            clrbg ';color: ' clrfg ';">' lbl{c} '</span></html>']);
    end
    
else % for non histogram-based project
    str_exc = cell(1,nExc);
    for l = 1:nExc
        str_exc{l} = [' at ' num2str(exc(l)) 'nm'];
    end
    for l = 1:nExc
        for c = 1:nChan
            str = cat(2,str,[lbl{c} str_exc{l}]);
        end
    end
    for l = 1:nExc
        for c = 1:nChan
            str = cat(2,str,['discr. ' lbl{c} str_exc{l}]);
        end
    end
    for em = em0
        l0 = find(exc==chanExc(em));
        str = cat(2,str,['total ' lbl{em} str_exc{l0(1)}]);
    end
    for em = em0
        l0 = find(exc==chanExc(em));
        str = cat(2,str,['discr. total ' lbl{em} str_exc{l0(1)}]);
    end
    nFRET = size(FRET,1);
    for n = 1:nFRET
        str = cat(2,str,['FRET ' lbl{FRET(n,1)} '>' lbl{FRET(n,2)}]);
    end
    for n = 1:nFRET
        str = cat(2,str,['discr. FRET ' lbl{FRET(n,1)} '>' ...
            lbl{FRET(n,2)}]);
    end
    nS = size(S,1);
    for n = 1:nS
        str = cat(2,str,['S ' lbl{S(n,1)} '>' lbl{S(n,2)}]);
    end
    for n = 1:nS
        str = cat(2,str,['discr. S ' lbl{S(n,1)} '>' lbl{S(n,2)}]);
    end
end
