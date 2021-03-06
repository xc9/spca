function [ p , q ] = power_iteration( M, options)
%power_iteration performs the power iteration with hard thresholding steps
% inputs:
% M                         the mxn document-by-term matrix
% options.threshold_m       number of non-zeros to keep in the result 
%                           document vector (p)
% options.threshold_n       number of non-zeros to keep in the result 
%                           term vector (q)
% options.max_iteration     max iterations to run
% options.tolerance         stop when difference in objective across 2
%                           iterations < tolerance
% outputs:
% p         optimal thresholded document vector
% q         optimal thresholded term vector
    %% set problem size and parameters
    % problem size
    m = size(M.ucM, 1);
    n = size(M.ucM, 2);
    k_p = options.threshold_m;
    k_q = options.threshold_n;
    tolerance = options.tolerance;
    max_iteration = options.max_iteration;


    %% power iteration algorithm
    % initialize variables
    p = ones (m, 1);    % initialize to all-ones vector
    p = p/norm(p);
    q = ones (n, 1);    % initialize to all-ones vector
    q = q/norm(q);    
    obj0 = inf;
    converged=0;
    iter=0;

    % begin iterations
    while ~converged
      % obtain new p vector
      p_new = M.mvMul(q);
      
      [p, ind_p] = Util.thresh(p_new, k_p); % threshold
      p = p/norm(p);                        % normalize
      
      % obtain new q vector
      q_new = M.vmMul(p);
      [q, ind_q] = Util.thresh(q_new, k_q); % threshold (do not normalize)
      
      obj1 = norm(M.ucM - p*q', 'fro');

      % check termination condition
      if  abs(obj1-obj0) <= tolerance || iter>=max_iteration
         converged=1;
      end
      iter=iter+1;
      obj0=obj1;
    end
end

