function edit_TP_binTime_Callback(obj,evd,h_fig)

expT = str2num(get(obj,'string'));
if isempty(expT)
    return
end

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
expT0 = p.proj{proj}.frame_rate;

if expT<=expT0
    helpdlg(cat(2,'The new bin time must be larger than the current one (',...
        num2str(expT0),').'),'Binning impossible');
    return
end

I = p.proj{proj}.intensities;
I = binData(I, expT, expT0);

sz = size(p.proj{proj}.intensities);

p.proj{proj}.intensities_bgCorr = NaN(sz);
s.frame_rate
s.intensities_crossCorr
s.intensities_denoise
s.ES
s.intensities_DTA
s.FRET_DTA
s.S_DTA
s.bool_intensities


