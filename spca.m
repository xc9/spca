fid=fopen('sparseMatrix.csv','r');
ijv=textscan(fid,'%f %f %f','delimiter',',');
fclose(fid);
X=sparse(ijv{1}+1,ijv{2}+1,ijv{3});
fid=fopen('wordlist.csv','r');
words=textscan(fid,'%s %*d','delimiter',',');
fclose(fid);
words=words{1};
   n=size(X,2);
   A=X'*X;
   k=16;
   x=zeros(n,1);
   ind=randperm(n);
   x(ind(1:k*5))=1;
   x=x/norm(x);
   obj0=x'*(A*x);
   converged=0;iter=0;max_iteration=1000;tolerance=.0001;

   while ~converged
      x=A*x;
      [temp,ind]=sort(full(abs(x)),'descend');
      z=x(ind(1:k))/norm(x(ind(1:k)));
      obj1=z'*(A(ind(1:k),ind(1:k))*z);
      if obj1-obj0 <= tolerance || iter>=max_iteration
         converged=1;
      end
      x=zeros(n,1);x(ind(1:k))=z;
      iter=iter+1;obj0=obj1;
  end
  x1=x;
   x1b=x1(x1>0);
   x1w=words(x1>0);
   [sort_x1b,index]=sort(x1b,'descend');
   x1b=x1b(index);
   x1w=x1w(index);
   for i=1:length(x1w)
     fprintf(' %s %.4f',x1w{i},x1b(i));
   end