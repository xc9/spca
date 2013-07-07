classdef Util
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods (Static = true)
        % returns a sparse matrix of same dimension as v, containing only
        % the top n largest entries.
        function [x, ind_v] = thresh (v, n)
            [~,ind_v]=sort(full(abs(v)),'descend');
            ind_v = ind_v (1:n);
            x=sparse(size(v,1),size(v,2));
            x(ind_v) = v(ind_v);
        end
        
        function conveniencePrintCSV ( outputfile, cellofstrings, arrayofweights)
            fid=fopen(outputfile,'wt');
            [rows, cols] = size(cellofstrings);

            for i=1:rows
                baseStr = '';
                for j = 1:cols
                    baseStr = [baseStr, cellofstrings{i,j}, char(9), num2str(arrayofweights(i,j)), char(9)];
                end
                baseStr = [baseStr, char(10)];
                fprintf(fid,baseStr);
            end

            fclose(fid);
        end
    end
    
end

