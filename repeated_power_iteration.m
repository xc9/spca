function [ pc_p, pc_q] = repeated_power_iteration( M, options)
%repeated_power_iteration a wrapper that finds top k principal components
%using power_iteration
% inputs:
% M                         the mxn document-by-term matrix
% options.threshold_m       number of non-zeros to keep in the result 
%                           document vector (p)
% options.threshold_n       number of non-zeros to keep in the result 
%                           term vector (q)
% options.max_iteration     max iterations to run
% options.tolerance         stop when difference in objective across 2
%                           iterations < tolerance
% options.mode              can be 'a' or 'b'
% options.num_pc            number of principal components to return
% output:
% pc_p         top k optimal thresholded document vector
% qc_q         top k optimal thresholded term vector
% *k = ontions.num_pc
%M = M' * M;
    pc_p = [];
    pc_q = [];
    diff_p = [];
    diff_q = [];
    diffMat = sparse(zeros(size(M, 2), 1)) * sparse(zeros(size(M,2), 1))';
    for i = 1 : options.num_pc
        [p, q] = power_iteration(M, options, diffMat, diff_p, diff_q);
        if (options.mode == 'b')
            q = [q;zeros((i-1)*options.threshold_n, 1)];
        end
        pc_q=[pc_q, q];
        p_ind = find(abs(p)>0);
        q_ind = find(abs(q)>0);
        if (options.mode == 'b')
            M(:,q_ind)=[];
            M(q_ind,:)=[];
            diffMat(:,q_ind)=[];
            diffMat(q_ind,:)=[];
        else
            %M(p_ind,q_ind) = M(p_ind,q_ind) - p(p_ind)*q(q_ind)';
            diffMat = diffMat + sparse(p)*sparse(q');
            diff_p = [diff_p, sparse(p)];
            diff_q = [diff_q, sparse(q)];
            %diffMat = [diffMat, sparse(q)];
            %disp(sparse(p)'-sparse(q)'/norm(sparse(q)));
        end
    end
end

