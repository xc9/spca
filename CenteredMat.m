classdef CenteredMat <handle
    %Class for representing implicitly centered sparse matrices
    
    properties
        %uncentered matrix
        ucM;
        %averages for each column/row depending on centerOption
        colrowAvg;
        %option for row (1) /col (2) /no centering (0)
        centerOption
    end
    
    methods
        % Constructor, M is the sparse, uncentered matrix
        % inputs:
        % M             The actual matrix, may be sparse
        % centerOption  0, 1 or 2, see centerOption under properties
        function cm = CenteredMat(M, centerOption)
            cm.ucM = M;
            cm.centerOption = centerOption;
            if (centerOption == 1) % center each row
                cm.colrowAvg = zeros(1, size(cm.ucM, 1));
                for i = 1:length(cm.colrowAvg)
                    cm.colrowAvg(i) = sum(M(i,:))/size(cm.ucM, 2);
                end
            elseif (centerOption == 2) % center each column
                cm.colrowAvg = zeros(1, size(cm.ucM, 2));
                for i = 1:length(cm.colrowAvg)
                    cm.colrowAvg(i) = sum(M(:,i))/size(cm.ucM, 1);
                end
            end
                
            
        end
        
        % recenters the matrix 
        function recenter(obj)
            if (obj.centerOption == 1) % center each row
                obj.colrowAvg = zeros(1, size(obj.ucM, 1));
                for i = 1:length(obj.colrowAvg)
                    obj.colrowAvg(i) = sum(obj.ucM(i,:))/size(obj.ucM, 2);
                end
            elseif (obj.centerOption == 2) % center each column
                obj.colrowAvg = zeros(1, size(obj.ucM, 2));
                for i = 1:length(obj.colrowAvg)
                    obj.colrowAvg(i) = sum(obj.ucM(:,i))/size(obj.ucM, 1);
                end
            end
        end
        
        % horizVec * matrix
        % Function for performing multiplication of form M * p where p is a
        % vertical vector
        % inputs:
        % p                     The vertical vector described above
        % outputs:
        % v                     The result of M * p, it is horizontal
        function v = mvMul(obj, p)
            if (obj.centerOption==0)
                toSubtract = 0;
            elseif (obj.centerOption==1)
                toSubtract = obj.colrowAvg'*sum(p);
            elseif (obj.centerOption==2)
                toSubtract = obj.colrowAvg*p;
            end
            v = obj.ucM*p-toSubtract;
        end
        
        % horizVec * matrix
        % Function for performing multiplication of form p * M where p is a
        % horizontal vector
        % inputs:
        % p                     The horizontal vector described above
        % outputs:
        % v                     The result of M * p, it is horizontal
        function v = vmMul(obj, p)
            if (obj.centerOption==0)
                toSubtract = 0;
            elseif (obj.centerOption==1)
                toSubtract = obj.colrowAvg*p;
            elseif (obj.centerOption==2)
                toSubtract = obj.colrowAvg'*sum(p);
            end
            v = obj.ucM'* p-toSubtract;
        end
        
        % get the sub matrix specified by arrays of row/col indices
        function m = getMat(obj, rowInd, colInd)
            m = full(obj.ucM(rowInd, colInd));
            if (obj.centerOption == 1)
                for i = 1:length(rowInd)
                    m(:, i) = m(i, :) - obj.colrowAvg(rowInd(i));
                end
            end
            if (obj.centerOption == 2)
                for i = 1:length(colInd)
                    m(:, i) = m(:, i) - obj.colrowAvg(colInd(i));
                end
            end
        end
        
        % subtract a dyad (given by subCol * subRow') from M
        function subMat(obj, subCol, subRow)
            obj.ucM = obj.ucM - subCol * subRow';
        end
        
        % remove columns from M given by colInd
        function removeCol(obj, colInd)
            obj.ucM(:, colInd) = [];
            if (obj.centerOption == 2)
                obj.colrowAvg(:, colInd) =[];
            end
            obj.recenter();
        end
        
        % either subtract dyad
        
    end
    
    methods (Access = private)
    end
    
end

