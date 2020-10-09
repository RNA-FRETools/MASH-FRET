function set_S_camNoise(n,prm,h_fig)
% set_S_camNoise(n,prm,h_fig)
%
% Set panel Camera SNR characteristics to proper values and update interface parameters
%
% n: index in list of chosen camera noise
% prm: [N-by-6] parameters ofthe N noise distributions
% h_fig: handle to main figure

h = guidata(h_fig);

set(h.popupmenu_noiseType,'value',n);
popupmenu_noiseType_Callback(h.popupmenu_noiseType,[],h_fig);

if sum(n==[1,2,3,4,5])
    set(h.edit_camNoise_01,'string',num2str(prm(n,1)));
    edit_camNoise_01_Callback(h.edit_camNoise_01,[],h_fig);
end
if sum(n==[2,3,5])
    set(h.edit_camNoise_02,'string',num2str(prm(n,2)));
    edit_camNoise_02_Callback(h.edit_camNoise_02,[],h_fig);
end
if sum(n==[1,2,3,5])
    set(h.edit_camNoise_03,'string',num2str(prm(n,3)));
    edit_camNoise_03_Callback(h.edit_camNoise_03,[],h_fig);
end
if sum(n==[2,3,5])
    set(h.edit_camNoise_04,'string',num2str(prm(n,4)));
    edit_camNoise_04_Callback(h.edit_camNoise_04,[],h_fig);
end
if sum(n==[2,3,5])
    set(h.edit_camNoise_05,'string',num2str(prm(n,5)));
    edit_camNoise_05_Callback(h.edit_camNoise_05,[],h_fig);
end
if sum(n==[3,5])
    set(h.edit_camNoise_06,'string',num2str(prm(n,6)));
    edit_camNoise_06_Callback(h.edit_camNoise_06,[],h_fig);
end
