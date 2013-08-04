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
% options.centerOption      1: centers rows, 2: centers columns, 0: no
%                           centering
% output:
% pc_p         top k optimal thresholded document vector (each column is a
%              pc)
% qc_q         top k optimal thresholded term vector (each column is a pc)
% *k = ontions.num_pc

    pc_p = [];
    pc_q = [];
    M = CenteredMat(M, options.centerOption);
    original_q_size = size(M.ucM, 2);
    for i = 1 : options.num_pc
        
        % where the main computation occurs
        [p, q] = power_iteration(M, options);
        
        pc_p=[pc_p, p]; %#ok<*AGROW>
        if (options.mode == 'b')
            q = [q;zeros(original_q_size-size(q, 1),1)];
        end
        pc_q=[pc_q, q];
        
        p_ind = find(p);
        q_ind = find(q);
        
        
        % either remove the columns or subtract the dyad given by the pc's
        if (options.mode == 'b')
            M.removeCol(q_ind);
        else
            M.subMat(p, q);
        end
    end
    if (options.mode == 'b')
        pc_q = Util.remap(pc_q);
    end
end

