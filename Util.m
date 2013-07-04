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
    end
    
end

