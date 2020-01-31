function saveTDP(h_fig)
% Export files from Transition analysis

% Last update: the 25th of February 2019 by Mélodie Hadzic
% --> adapt to the new clustering result structure
% update: The 23rd of February 2019 by Mélodie Hadzic
% --> remove option to export readjusted data (no use)
% --> update action display

setContPan('Export transition analysis data ...', 'process', h_fig);

%% collect parameters

% general parameters
h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
q = p.proj{proj}.exp;
str_tpe = get(h.popupmenu_TDPdataType, 'String');
str_tag = get(h.popupmenu_TDPtag, 'String');
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
prm = p.proj{proj}.prm{tag,tpe};

% export parameters for TDP
TDPascii = q{2}(1);
TDPimg = q{2}(2);
TDPascii_fmt = q{2}(3);
TDPimg_fmt = q{2}(4);
TDPclust = q{2}(5);

% export parameters for kinetic analysis
kinDtHist = q{3}(1);
kinFit = q{3}(2);
kinBoba = q{3}(3);

if ~(TDPascii || TDPimg || TDPclust || kinDtHist || kinFit || kinBoba)
    setContPan('There is no data to export.', 'warning', h_fig);
    return
end

% build file name
[o,fname_proj,o] = fileparts(p.proj{proj}.proj_file);

defName = [setCorrectPath('tdp_analysis', h_fig) fname_proj];
[fname, pname] = uiputfile({ ...
    '*.tdp;*.txt;*.hdt;*.fit','TDP analysis files'; ...
    '*.txt;*.dt;*.hd','Trace processing files'; ...
    '*.pdf;*.png;*.jpeg','Figure files'; ...
    '*.*','All Files (*.*)'}, 'Export data', defName);

if ~sum(fname)
    return;
end

fname = getCorrName(fname, [], h_fig);
[o,name,o] = fileparts(fname);

str_act = '';

%% Export TDP

tdp_mat = TDPascii & (TDPascii_fmt==1 | TDPascii_fmt==4);
tdp_conv = TDPascii & (TDPascii_fmt==2 | TDPascii_fmt==4);
tdp_coord = TDPascii & (TDPascii_fmt==3 | TDPascii_fmt==4);
tdp_png = TDPimg & (TDPimg_fmt==1 | TDPimg_fmt==3);
tdp_png_conv = TDPimg & (TDPimg_fmt==2 | TDPimg_fmt==3);
bol_tdp = [tdp_mat tdp_conv tdp_coord tdp_png tdp_png_conv TDPclust];

if sum(bol_tdp)
    
    setContPan('Export TDP and clustering results ...', 'process', h_fig);

    pname_tdp = setCorrectPath([pname 'clustering'], h_fig);

    if numel(prm.plot{2})==1 && isnan(prm.plot{2})
        disp(['no TDP built for data ' str_tpe{tpe}]);
    elseif isempty(prm.plot{2})
        if tag==1
            disp(['no TDP built for data ' str_tpe{tpe}]);
        else
            disp(['no TDP built for data ' str_tpe{tpe} ...
                ' and molecule subgroup ' ...
                removeHtml(str_tag{tag})]);
        end
    else
        if tag==1
            name_tdp = cat(2,name,'_',str_tpe{tpe});
        else
            name_tdp = cat(2,name,'_',str_tpe{tpe},'_',...
                removeHtml(str_tag{tag}));
        end
        [ok,str_tdp] = save_tdpDat(prm,pname_tdp,name_tdp,bol_tdp,...
            h_fig);
        if ~ok
            return;
        end
        str_act = cat(2,str_act,str_tdp);
    end
end


%% Export kinetic files

bol_kin = [kinDtHist kinFit kinBoba];

if sum(bol_kin)
    setContPan('Export kinetic results ...', 'process', h_fig);
    
    pname_kin = setCorrectPath([pname 'kinetics'], h_fig);
    
    % export dwell-time histogram files & fitting results (if)
    J = prm.kin_start{2}(1);
    mat = prm.clst_start{1}(4);
    clstDiag = prm.clst_start{1}(9);
    if ~isempty(prm.clst_res{4}) && J>0

        if tag==1
            name_kin0 = cat(2,name,'_',str_tpe{tpe});
        else
            name_kin0 = cat(2,name,'_',str_tpe{tpe},'_',...
                removeHtml(str_tag{tag}));
        end
        
        nTrs = getClusterNb(J,mat,clstDiag);
        for k = 1:nTrs
            if ~(size(prm.clst_res{4},2)>=k && ...
                    ~isempty(prm.clst_res{4}{k}))
                continue
            end
            val = round(100*prm.clst_res{1}.mu{J}(k,:))/100;

            name_kin = cat(2,name_kin0,'_',num2str(val(1)),'to',...
                num2str(val(2)));

            [ok,str_kin] = save_kinDat(bol_kin, prm,k, pname_kin, name_kin, ...
                h_fig);
            if ~ok
                return
            end
            str_act = cat(2,str_act,str_kin);
        end
    end
end

str_act = str_act(1:end-2); % remove last '\n'
setContPan(cat(2,'Export completed\n',str_act),'success',h_fig);


