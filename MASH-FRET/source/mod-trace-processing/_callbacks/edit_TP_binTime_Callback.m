function edit_TP_binTime_Callback(obj,evd,h_fig)

expT = str2double(get(obj,'string'));
if ~(numel(expT)==1 && expT>0)
    return
end

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
expT0 = p.proj{proj}.sampling_time;
nChan = p.proj{proj}.nb_channel;
nFRET = size(p.proj{proj}.FRET,1);
nS =  size(p.proj{proj}.S,1);

if expT<=expT0
    helpdlg(cat(2,'The new bin time must be larger than the current one (',...
        num2str(expT0),').'),'Binning impossible');
    return
end

I = p.proj{proj}.intensities;
I = binData(I, expT, expT0);
if isempty(I)
    return
end

[L,ncol,nExc] = size(I);
N = ncol/nChan;

p.proj{proj}.intensities = I;
p.proj{proj}.intensities_bgCorr = NaN(L,ncol,nExc);
p.proj{proj}.resampling_time = expT;
p.proj{proj}.intensities_crossCorr = NaN(L,ncol,nExc);
p.proj{proj}.intensities_denoise = NaN(L,ncol,nExc);
p.proj{proj}.intensities_DTA = NaN(L,ncol,nExc);
p.proj{proj}.ES = [];
p.proj{proj}.FRET_DTA = NaN(L,nFRET*N);
p.proj{proj}.S_DTA = NaN(L,nS*N);
p.proj{proj}.bool_intensities = true(L,N);


