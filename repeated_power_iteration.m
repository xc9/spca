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
    pc_p = [];
    pc_q = [];
    for i = 1 : options.num_pc
        [p, q] = power_iteration(M, options);
        pc_p=[pc_p, p]; %#ok<*AGROW>
        pc_q=[pc_q, q];
        
        p_ind = find(abs(p)>0);
        q_ind = find(abs(q)>0);

        M(p_ind,q_ind) = M(p_ind,q_ind) - p(p_ind)*q(q_ind)';
        if (options.mode == 'b')
            M(:,q_ind)=0;
    end
end

