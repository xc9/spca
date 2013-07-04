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
% output:
% p         optimal thresholded document vector
% q         optimal thresholded term vector
    %% set problem size and parameters
    % problem size
    m = size(M, 1);
    n = size(M, 2);
    k_p = options.threshold_m;
    k_q = options.threshold_n;
    tolerance = options.tolerance;
    max_iteration = options.max_iteration;


    %% power iteration algorithm
    p = zeros(m, 1);
    ind_p = randperm(m);
    ind_p = ind_p(1:min(k_p*5, size(p,1)));
    p(ind_p)=1;
    p = sparse(p);
    p = p/norm(p);
    q = zeros(n, 1);
    ind_q = randperm(n);
    ind_q = ind_q(1:min(k_q*5, size(q,1)));
    q(ind_q)=1;
    q = q/norm(q);
    frob_m = norm(M, 'fro'); %save the frob norm of m
    
    p = ones (m, 1);    % initialize to all-ones vector
    p = p/norm(p);
    q = ones (n, 1);    % initialize to all-ones vector
    q = q/norm(q);
    
    
    obj0 = inf;
    %obj0= frob_m - norm(M(p_ind, q_ind),'fro') + norm(M-p*q','fro'); %initial objective

    converged=0;
    iter=0;

    % begin iterations
    while ~converged
      % obtain new p vector
      p_new = M * q;
      [p, ind_p] = Util.thresh(p_new, k_p);
      p = p/norm(p);
      
      % obtain new q vector
      q_new = M' * p;
      [q, ind_q] = Util.thresh(q_new, k_q);      
      
      relevantM = M(ind_p,ind_q);
      obj1 = frob_m - norm(relevantM, 'fro') + norm (relevantM - p(ind_p)*q(ind_q)', 'fro'); % update objective
                
      if  abs(obj1-obj0) <= tolerance || iter>=max_iteration
         converged=1;
      end
      iter=iter+1;
      obj0=obj1;
    end
end

