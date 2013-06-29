function [ M ] = UpdateSparse( M, p_ind, q_ind, p, q)
%UpdateSparse updates a sparse matrix efficiently
%   Detailed explanation goes here
    diffMat = p(p_ind) * q(q_ind)';
    tmpMat=sparse([]);
    for i = 1:max(size(q_ind))
        index = q_ind(i);
        tmpCol = full(M(:, index));
        tmpCol(p_ind) = tmpCol(p_ind) - diffMat(:, i);
        M = [M(:, 1:index-1), sparse(tmpCol), M(:, index+1:end)];
    end

end

