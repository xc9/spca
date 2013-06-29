function [ ] = printCSV( outputfile, cellofstrings, arrayofweights)
    fid=fopen(outputfile,'wt');
    [rows, cols] = size(cellofstrings);
    for j = 1:cols
        for i=1:rows-1
            fprintf(fid,'%s:%s,',cellofstrings{i,j},arrayofweights(i,j));
        end
        fprintf(fid,'%s:%s\n',cellofstrings{end,j},arrayofweights(i,j));
    end

    fclose(fid);

end

