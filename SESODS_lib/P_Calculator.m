function [P,F]=P_Calculator(Sigma_P,Sigma_V)

d=size(Sigma_P,1)/2;
K=size(Sigma_P);
if max(size(K))==2
    K(1,3)=1;
end
K=K(1,3);
optNLP = optimset('Algorithm', 'interior-point','Diagnostics','off', 'LargeScale', 'on',...
        'GradObj', 'off', 'GradConstr', 'off','FinDiffType','central', ...
        'Display', 'iter', 'TolX',10^(-12), 'TolFun', 10^(-12), 'TolCon', 10^(-12), ...
        'MaxFunEval', 20000, 'MaxIter', 2000, 'DiffMinChange', ...
         10^(-8), 'Hessian','bfgs','display','final','AlwaysHonorConstraints','bounds');
     p0=To_Parameters(eye(2*d,2*d),2*d);
     F=1;
for i=1:K
    A=[zeros(d,d) eye(d,d);Sigma_P(d+1:2*d,1:d,i)/(Sigma_P(1:d,1:d,i)) Sigma_V(d+1:2*d,1:d,i)/(Sigma_V(1:d,1:d,i))];
%     obj_handle = @(p)obj(p,2*d,A);
%     ctr_handle = @(p) ctr_eigenvalue(p,2*d); 
%     [popt output flag] = fmincon(obj_handle, p0,[],[],[],[],[],[],ctr_handle,optNLP);
%     if (flag==0)
%         F=0;
%     end
B=zeros(2*d);
Q=eye(2*d);
     P(:,:,i)=care(A,B,Q);
     if min(eig(P(:,:,i)))<0
         F=0;
     end
    if max(eig(A'*P(:,:,i)+P(:,:,i)*A))>0
         F=0;
     end
%     P(:,:,i) = shape_DS(popt,2*d);
end  











function [C, Ceq, Grad_C, Grad_Ceq]=ctr_eigenvalue(x,d)
[P] = shape_DS(x,d); 

%%%%%%%%%%%%%%%%%%%%%   Constrain on A
C=zeros(1,d);
Ceq=[];
Grad_Ceq=[];
Grad_C=[];
counter=1; 
for pointer_of_colum_and_row=1:d
    C(counter)=-Comstrain_on_Ak(P,pointer_of_colum_and_row);
    counter=counter+1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X] = shape_DS(p,d)

X = zeros(d,d);
hadle=1;
for j=1:d
    for i=j:d
      X (i,j)= p(hadle);
      X (j,i)= p(hadle);
      hadle=hadle+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x1 = To_Parameters(Input,d)
hadle=1;
for j=1:d
    for i=j:d
         x1(hadle) = Input(i,j);
         hadle=hadle+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function obj_handle = obj(p,d,A)
[P] = shape_DS(p,d);  
obj_handle=norm(norm(transpose(A)*P+P*A+eye(d,d)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function C=Comstrain_on_Ak(P,pointe_of_colum_and_row)
output=P;
C=det(output(1:pointe_of_colum_and_row,1:pointe_of_colum_and_row));
