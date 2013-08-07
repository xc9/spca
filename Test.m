function Test( )
    testMat = rand(10,10);
    xargs = nchoosek(1:10,5);
    yargs = nchoosek(1:10,5);
    bestp=[];
    bestq=[];
    bestnorm = Inf;
    for i = 1:size(xargs,1)    
        for j = 1:size(yargs,1)
            subMat = testMat(xargs(i,:), yargs(j,:));
            [U,S,V] = svd(subMat);
            p = zeros(size(testMat, 1),1);
            q = zeros(size(testMat, 2),1);
            p(xargs(i,:))=U(:,1)*S(1,1);
            q(yargs(j,:))=V(:,1);
            dnorm = norm(testMat - p * q', 'fro');
            if (dnorm < bestnorm)
                bestnorm = dnorm;
                bestp=p;
                bestq=q;
            end
        end
    end
    
    [p2, q2, n2] = nnmf_custom(testMat, 'threshold_m', 5, 'threshold_n',5,'num_pc',1);
    
end

