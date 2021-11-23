function ud_lstMolStr(p, h_lb)

% update 24.4.2019 by MH: (1) adjust code with tag colors as a project parameters, (2) add colors for all molecule tags in molecule list

proj = p.curr_proj;
incl = p.proj{proj}.coord_incl;
molTag = p.proj{proj}.molTag;
N = size(incl,2);
str_lst = cell(1,N);

% added by MH, 24.4.2019
colorlist = p.proj{proj}.molTagClr;

for m = 1:N
    if incl(m)
        str_lst{m} = num2str(m); 

        % color according to molecule tag; added by FS, 24.4.2018
        % modified by MH, 24.4.2019
%         if molTag(m) > 1
%             colorlist = {'transparent', '#4298B5', '#DD5F32', '#92B06A', '#ADC4CC', '#E19D29'};
%             str_lst{m} = ['<html><body  bgcolor="' colorlist{molTag(m)} '">' ...
%             '<font color="white">' num2str(m) '</font></body></html>'];
        tag = find(molTag(m,:));
        if ~isempty(tag)
            if sum(double((hex2rgb(colorlist{tag(1)})/255)>0.5))==3
                fntClr = 'black';
            else
                fntClr = 'white';
            end
            str_lst{m} = ['<html><span  bgcolor="' colorlist{tag(1)} ...
                '"><font color=',fntClr,'>' num2str(m) ...
                '</font></span>'];

            for t = 2:numel(tag)
                str_lst{m} = [str_lst{m},'<span  bgcolor="' ...
                    colorlist{tag(t)} '">&#160;&#160;</span>'];
            end

            str_lst{m} = [str_lst{m},'</html>'];
        end

    else
        str_lst{m} = ['<html><body  bgcolor="#232323">' ...
            '<font color="white">' num2str(m) '</font></body></html>'];
    end
end
currMol = p.ttPr.curr_mol(proj);
top = get(h_lb,'Listboxtop');
if top>numel(str_lst)
    top = numel(str_lst);
end
set(h_lb, 'String', str_lst, 'Value', currMol,'Listboxtop',top);
