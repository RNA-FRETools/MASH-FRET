function pushbutton_trImpOpt_ok_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);

% adjust import parameters
nChan_imp = m{1}{1}(7);
for i = 1:nChan_imp
    if i > size(m{3}{3}{1},1)
        m{3}{3}{1}(i,1:2) = m{3}{3}{1}(i-1,1:2) + 2;
    end
end

% adjust user-defined experimental conditions
nExc_imp = m{1}{1}(8);
exc_imp = m{1}{2};
expcond_imp = m{5}(1:4,:);
for i = 1:nExc_imp
    expcond_imp = cat(1,expcond_imp,...
        {['Power(',num2str(round(exc_imp(i))),'nm)'],'','mW'});
end
ind = max(find(~cellfun('isempty',strfind(m{5}(:,1),'Power')),1));
if isempty(ind)
    ind = 4;
end
exc_imp = cat(1,expcond_imp,m{5}((ind+1):end,:));
m{5} = exc_imp;

% save podifications
h.param.ttPr.impPrm = m;
guidata(h_fig, h);

% close option window
close(h.figure_trImpOpt);


