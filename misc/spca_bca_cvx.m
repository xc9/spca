%% SPCA_BCA_CVX
% function [X,Z] = spca_bca_cvx(Sigma,lambda,options)
% SPCA_BCA_CVX implements a CVX-based block-coordinate ascent method to 
% approximately solve the (primal) sparse PCA problem
%   max_Z trace(Sigma*Z)-lambda*norm(Z(:),1) : Z psd, trace(Z) = 1,
% where Sigma is psd, and lambda>=0 is a sparsity-inducing parameter. The
% code actually solves an almost equivalent, strictly convex problem
%   max_X trace(Sigma*X)-lambda*norm(X(:),1)-(1/2)*(trace(X))^2
%         +beta*log(det(X)) : norm(X,inf) <= kappa
% where beta>0 is small, and kappa = trace(Sigma)/n.
% inputs:
% Sigma     nxn psd matrix
% lambda    >= 0 sparsity-inducing parameter
% options   a cell with the following elements:
% options.nsweeps   number of sweeps through all column/rows (default: 5)
% options.beta      regularization parameter for the conic constraint
%                   (default: sqrt(eps)/n)
% output:
% X         an optimal point for the penalized problem above
% Z         a near-optimal point for the original problem
% L. El Ghaoui, May 2010

%% test data
n = 5;
A = randn(n,n); 
Sigma = A'*A;
options.nsweeps = 20;
options.beta = 0.0001;
ratio = 0.5; % ratio of lambda to lambdamax = max(diag(Sigma))

%% set problem size and parameters
% problem size
n = max(size(Sigma));

% set defaults
options.defaults = {5,sqrt(eps)/n};

% regularization parameter
lambda = ratio*max(diag(Sigma));

% number of row sweeps (a sweep is going through all the n rows)
K = options.nsweeps;

% regularization parameter for the SDP constraint
beta = options.beta;

% upper bound on solution
kappa = trace(Sigma)/n;

% we keep CVX quiet
cvx_quiet(true);

%% CVX solution
% true SPCA solution
cvx_begin
variable Z(n,n) symmetric
maximize(trace(Sigma*Z)-lambda*norm(Z(:),1))
subject to 
       trace(Z) == 1;
       Z == semidefinite(n);
cvx_end
Ztrue = Z;

% exact solution to approximate problem
cvx_begin
variable X(n,n) symmetric
maximize(trace(Sigma*X)-lambda*norm(X(:),1)- ...
    (1/2)*(trace(X))^2+beta*log_det(X))
subject to 
    X == semidefinite(n);
    max(max(abs(X))) <= kappa;
cvx_end
Xcvx = X;

% form corresponding approximate solution to true SPCA problem
Zcvx = Xcvx/trace(Xcvx);

%% block-coordinate ascent
% initialize
X = speye(n,n); % unit-trace

% loop over number of sweeps over all rows
for k = 1:K,
    % update each row
    for i = 1:n,
        % printout
        fprintf('updating row/column %d in sweep %d ...',i,k);

        % vector of indices (1,...,i-1,i+1,n)
        inds = 1:n; inds(i) = [];

        % extract relevant data from covariance matrix Sigma
        s = Sigma(inds,i);
        sigma = Sigma(i,i);

        % extract relevant fixed parts of current matrix variable X
        Y = X(inds,inds); % we won't change this matrix at this iteration
        t = trace(Y);
        
        % solve the sub-problem for the row/column via CVX
        cvx_begin
        variable y(n-1,1)
        variable x(1)
        maximize( 2*(s'*y-lambda*norm(y,1))+(sigma-lambda)*x- ...
            (1/2)*(x+t)^2+beta*log_det([Y y; y' x]) )
        subject to
            x >= 0;
            x <= kappa;
            norm(y,inf) <= kappa;
        cvx_end

        % update primal solution X
        X(inds,i) = y;
        X(i,inds) = y';
        X(i,i) = x;

        % announce end of row/column update
        fprintf(' done.\n');
        
        % end loop over all the rows
    end
    % end loop over sweeps
end

% set solution Z
Z = X/trace(X);

%% compare 
err = [norm(X-Xcvx); norm(Z-Zcvx); norm(Ztrue-Zcvx); norm(Ztrue-Z)];
txt = '\nX-Xcvx: %e \nZ-Zcvx: %e \nZtrue-Zcvx: %e \nZ-Ztrue: %e\n\n';
txt = sprintf(txt,err);
disp(txt)
