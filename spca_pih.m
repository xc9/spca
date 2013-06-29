%% SPCA_pih
% function [X,Z] = spca_pih(M,options)
% SPCA_pih implements the hard-thresholded power-iteration method to obtain
% a sparse rank-1 approximation to the document-term matrix.
% the objective is to find p and q
% minimize |M-pq'|^2
%     s.t. |p|_0 < options.threshold_m
%          |q|_0 < options.threshold_n
% where |.| is the Frobenius norm and |.|_0 is the cardinality

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
% p         an optimal point for the penalized problem above
% q         a near-optimal point for the original problem
% Xiang Cheng, June 2013

%% test data
%m = 100;                  % m is the number of documents
%n = 50;                   % n is the number of terms
%options.threshold_m = 50;         
%options.threshold_n = 25;          
%options.max_iteration=10000;       
%options.tolerance=.00000000001;          
%M = orth(randn(m,n)) * abs(diag(randn(1,n)*100)) * orth(randn(n,n));           % randomized A matrix

%% set problem size and parameters
% problem size
m = size(M, 1);
n = size(M, 2);
k_p = options.threshold_m;
k_q = options.threshold_n;
tolerance = options.tolerance;
max_iteration = options.max_iteration;

if (isfield(options, 'num_pc'))
    num_pc = options.num_pc;
else
    num_pc = 1;
end

 

%% Set storage variables
words = [];

%% power iteration algorithm
for i = 1 : num_pc   
    p = ones (m, 1);    % initialize to all-ones vector
    p = p/norm(p);
    q = ones (n, 1);    % initialize to all-ones vector
    q = q/norm(q);
    obj0=norm(M-p*q','fro');

    converged=0;
    iter=0;

    % begin iterations
    while ~converged
      % obtain new p vector
      p_new = M*q;
      % sort and obtain k_p top largest entries
      [~,ind_p]=sort(full(abs(p_new)),'descend');
      ind_p = ind_p (1:k_p);
      % Apply hard-thresholding, then normalize
      p_new = p_new(ind_p)/norm(p_new(ind_p));    

      % obtain new q vector
      q_new = M(ind_p,:)' * p_new;
      % sort and obtain k_q top largest entries
      [~,ind_q]=sort(full(abs(q_new)),'descend');
      ind_q = ind_q (1:k_q);
      % Apply hard-thresholding, then normalize
      q_new = q_new(ind_q);%/norm(q_new(ind_q));        

      % re-form the length-m vector
      p = zeros(m,1); p(ind_p) = p_new;           
      % re-form the length-n vector
      q = zeros(n,1); q(ind_q) = q_new;           
      obj1 = norm(M - p*q','fro');                 % update objective
      if  abs(obj1-obj0) <= tolerance || iter>=max_iteration
         converged=1;
      end
      iter=iter+1;
      %disp(obj0);disp(obj1);
      obj0=obj1;
    end
    

    
    Sigma = M*M';
    Sigma2 = M'*M;
    statistics = [obj1; p'*Sigma*p/eigs(Sigma,1);  (q/norm(q))'*Sigma2*(q/norm(q))/eigs(Sigma2,1)];
    txt = '\nObjective: %e \nVariance explained by p: %e \nVariance explained by q: %e\n';
    txt = sprintf(txt,statistics);
    disp(txt)
    disp(iter);
    
    M = M - p*q';
    words = [words, ind_q];
end
%% compare 
Sigma = M*M';
Sigma2 = M'*M;
statistics = [obj1; p'*Sigma*p/eigs(Sigma,1);  (q/norm(q))'*Sigma2*(q/norm(q))/eigs(Sigma2,1)];
txt = '\nObjective: %e \nVariance explained by p: %e \nVariance explained by q: %e\n';
txt = sprintf(txt,statistics);
disp(txt)
disp(iter);