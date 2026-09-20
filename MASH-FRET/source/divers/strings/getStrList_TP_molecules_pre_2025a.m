function str_lst = getStrList_TP_molecules_pre_2025a(proj)

incl = proj.coord_incl;
molTag = proj.molTag;
colorlist = proj.molTagClr;

N = size(incl,2);
str_lst = cell(1,N);

for m = 1:N
    if incl(m)
        str_lst{m} = num2str(m); 
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
