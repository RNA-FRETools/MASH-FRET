function routine_mov2SNR(h_fig)

h = guidata(h_fig);
p = h.param.movPr;
Npix = 1:25;
Ibg = 281.4191;

[data,ok] = getFrames(p.itg_movFullPth, 1, [], h_fig);
if ~ok
    return;
end
fCurs = data.fCurs;
res_x = data.pixelX;
res_y = data.pixelY;
nFrames = data.frameLen;
if isfield(h, 'movie') && ~isempty(h.movie.movie)
    fCurs = h.movie.movie;
end
fDat = {p.itg_movFullPth, fCurs, [res_y res_x], nFrames};
nExc = p.itg_nLasers;
nCoord = size(p.coordItg,1);
nFrames_min = floor(nFrames/nExc);

SNR = zeros(1,numel(Npix));
I_expl = zeros(nFrames_min,numel(Npix));

for n = 1:numel(Npix)

    set(h.edit_intNpix,'String',num2str(Npix(n)));
    edit_intNpix_Callback(h.edit_intNpix,[],h)
    h = guidata(h_fig);
    p = h.param.movPr;

    [o,traces] = create_trace(p.coordItg, ...
        p.itg_dim, p.itg_n, fDat);

    I = zeros(nFrames_min,p.nChan*nCoord,nExc);
    for i = 1:nExc
        I(:,:,i) = traces(i:nExc:nFrames_min*nExc,:);
    end
    I = I - Npix(n)*Ibg;
    SNR_I = mean(I(:,1:p.nChan:end,1),1)./ ...
        (2*std(I(:,1:p.nChan:end,1),0,1));
    SNR(1,n) = mean(SNR_I,2);
    SNR(2,n) = std(SNR_I);
    I_expl(:,n) = I(:,round(size(I,2)/2),1);
end

I_expl = [Npix;I_expl];
SNR = [Npix' SNR'];
save(['C:\Users\Mélodie\Documents\MATLAB\data\' ...
    '20151201_encD135L14_RT_12\movie_processing\' ...
    'coordinates\spotfinder\Iexpl.txt'],'I_expl','-ascii');
save(['C:\Users\Mélodie\Documents\MATLAB\data\' ...
    '20151201_encD135L14_RT_12\movie_processing\' ...
    'coordinates\spotfinder\SNR.txt'],'SNR','-ascii');

