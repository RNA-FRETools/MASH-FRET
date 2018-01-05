function routine_SFproc_eval(h_fig)


%% defines user param
% method: [1-by-M] spotfinder methods to be applied
% 1 none, 2 ISS, 3 HP, 4 Sch, 5 2tone
method = [2 3 4 5];
M = numel(method);

% NHoodSize: {M-by-1}[1-by-P1(M)] NHooSize parameter values to be applied for each method
% units as display in MASH's GUI
NHoodSize = {1:2:11; ... % ISS
    1:2:11; ... % HP
    5; ... % Sch
    1:2:11}; % 2tone

% thresh: {M-by-1}[1-by-P2(M)] thresh parameter values to be applied for each method
% units as display in MASH's GUI
thresh = {0:1000:20000; ... % ISS
    0:1000:20000; ... % HP
    0:0.1:4.5; ... % Sch
    0:250:5000}; % 2tone

% tolRad: tolerance radius to be considered around a reference coordinate
tolRad = 1;

%% defines user files
% simulated movie files (full path), piled in one cell column
movFiles = {'C:\Users\Mélodie\Documents\Uncharted\20160607_method_seminar\DATA\movie_processing\average_images\simulation_ave.sira'};

% reference coordinate files (full path), piled in one cell column
crdRefFiles = {'C:\Users\Mélodie\Documents\Uncharted\20160607_method_seminar\DATA\simulations\coordinates\simulation.crd'};

% output directory
pathName = 'C:\Users\Mélodie\Documents\Uncharted\20160607_method_seminar\DATA\simulations\';

% check consistency in the number of movie and reference coordinate files
MOV = size(movFiles,1);
if MOV~=size(crdRefFiles)
    fprintf(['\nABORT: The number of reference coordinate files ' ...
        '(%i) is not equal to the number of movies files (%i).\n'], ...
        size(crdRefFiles), MOV);
    return;
end

%% uses MASH
for mov = 1:MOV % for each movie

    % equivalent to activate pushbutton load movie
    [pnameMov,fnameMov,fextMov] = fileparts(movFiles{mov});
    if ~loadMovFile(1, {[pnameMov filesep],[fnameMov fextMov]}, 1, h_fig)
        fprintf('\nABORT: Error while loading movie file:\n%s\n', ...
            movFiles{mov});
        return;
    end

    h = guidata(h_fig);
    h.param.movPr.itg_movFullPth = [h.movie.path h.movie.file];
    h.param.movPr.rate = h.movie.cyctime;
    guidata(h_fig, h);
    updateFields(h_fig, 'imgAxes');

    coordRef = load(crdRefFiles{mov,1},'-ascii');
    coordRef = [coordRef(:,[1,2]);coordRef(:,[3,4])];
    C = size(coordRef,1);

    for m = 1:M % for each method

        Efficiency = zeros(numel(thresh{m}),numel(NHoodSize{m}));

        set(h.popupmenu_SF,'Value',method(m));
        popupmenu_SF_Callback(h.popupmenu_SF,[], h);

        h = guidata(h_fig);

        for p1 = 1:numel(NHoodSize{m}) % for each NHoodSize value

            for p2 = 1:numel(thresh{m}) % for each thresh value

                set(h.edit_SFintThresh,'String',num2str(thresh{m}(p2)));
                edit_SFintThresh_Callback(h.edit_SFintThresh,[],h);
                h = guidata(h_fig);

                set(h.edit_SFparam_w,'String',num2str(NHoodSize{m}(p1)));
                edit_SFparam_w_Callback(h.edit_SFparam_w,[],h);
                h = guidata(h_fig);

                set(h.edit_SFparam_h,'String',num2str(NHoodSize{m}(p1)));
                edit_SFparam_h_Callback(h.edit_SFparam_h,[],h);
                h = guidata(h_fig);

                set(h.edit_SFparam_darkW,'String',num2str(NHoodSize{m}(p1)));
                edit_SFparam_darkW_Callback(h.edit_SFparam_darkW,[],h);
                h = guidata(h_fig);

                set(h.edit_SFparam_darkH,'String',num2str(NHoodSize{m}(p1)));
                edit_SFparam_darkH_Callback(h.edit_SFparam_darkH,[],h);
                h = guidata(h_fig);

                pushbutton_SFgo_Callback(h.pushbutton_SFgo,[],h);
                h = guidata(h_fig);
                p = h.param.movPr;
                if size(p.SFres{2,1},1)>0
                    coord = [p.SFres{2,1}(:,[1,2]);p.SFres{2,1}(:,[1,2])];
                else
                    coord = [];
                end

                TP=0; FN=0;
                for c = 1:C
                    if size(coord,1)>0
                        xref = coordRef(c,1);
                        yref = coordRef(c,2);
                        [minDiff_x,id] = min(abs(floor(coord(:,1))- ...
                            floor(xref)));
                        minDiff_y = abs(floor(coord(id,2))- ...
                            floor(yref));
                        if minDiff_x<=tolRad && minDiff_y<=tolRad
                            TP = TP + 1;
                            coord(id,:) = [];
                        else
                            FN = FN + 1;
                        end
                    else
                        FN = FN + 1;
                    end
                end
                FP = size(coord,1);

                Efficiency(p2,p1) = (TP-FP)/(TP+FN);
            end
        end

        TDP = zeros(numel(thresh{m})+1,numel(NHoodSize{m})+1);
        TDP(1,2:end) = NHoodSize{m};
        TDP(2:end,1) = thresh{m}';
        TDP(2:end,2:end) = Efficiency;

        n=0;
        fname = [pathName sprintf(cat(2,fnameMov,'_method_%i_bis'),method(m))];
        while exist([fname '.txt'],'file')
            n=n+1;
            fname = [pathName ...
                sprintf(cat(2,fnameMov,'_method_%i'),method(m)) '(' ...
                num2str(n) ')'];
        end
        save([fname '.txt'],'TDP','-ascii');
    end
end
