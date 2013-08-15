function [pc_p,pc_q,normbest] = nnmf_custom(a,varargin)

error(nargchk(1,Inf,nargin,'struct'))
[m,n] = size(a); % may remove


% Process optional arguments
pnames = {'mode' 'threshold_m' 'threshold_n' 'replicates' 'tolerance' 'num_pc' 'centerOption' 'max_iter'};
dflts  = {'b'       150               15          1          0.001      10          0             50    };
[eid,emsg,mode,threshold_m,threshold_n,replicates,tolerance, num_pc, centerOption, max_iter] = ...
        internal.stats.getargs(pnames,dflts,varargin{:});
if ~isempty(eid)
    error(sprintf('nnmf_custom:%s',eid),emsg)
end

%error checking that num_pc is a valid number
if ~isscalar(num_pc) || ~isnumeric(num_pc) || num_pc<1 || num_pc>min(m,n) || num_pc~=round(num_pc)
    error('nnmf_custom:BadK',...
          'num_pc must be a positive integer no larger than the number of rows or columns in A.');
end
%error checking that replicates is a valid number
if ~isscalar(replicates) || ~isnumeric(replicates) || replicates<1 || replicates~=round(replicates)
    error('stats:nnmf:BadReplicates',...
          'REPLCATES must be a positive integer.');
end

%Form sparse matrix
M = CenteredMat(a, centerOption);

%form options
options = Util.make_option( threshold_m, threshold_n, tolerance, max_iter, num_pc, mode, centerOption );
% Prepare to start iterations
normbest = Inf;

pc_p=[];
pc_q=[];

for i = 1 : num_pc
    p=[];
    q=[];
    for j=1:replicates
        %decide what initialization to use 
        options.useHighestVariance = (j==1);
        
        % Perform a factorization
        [pn, qn, dnorm] = power_iteration(M, options);
        

        
        % Save if this is the best so far
        if dnorm<normbest
            p = pn;
            q = qn;
            normbest = dnorm;
        end
        
    end

    if (mode == 'b')
        q = [q;zeros(n-size(q, 1),1)];
    end
    pc_p=[pc_p, p]; %#ok<*AGROW>
    pc_q=[pc_q, q];
    
    %p_ind = find(p);
    q_ind = find(q);
    % either remove the columns or subtract the dyad given by the pc's
    if (options.mode == 'b')
        M.removeCol(q_ind); %#ok<FNDSB>
    else
        M.subMat(p, q);
    end
end
if (options.mode == 'b')
    pc_q = Util.remap(pc_q);
end

if normbest==Inf
    error('stats:nnmf:NoSolution',...
          'Algorithm could not converge to a finite solution.')
end
end