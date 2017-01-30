function [prior_out,Mu_out,Sigma_out,A,Time]=Learn_The_convex_Stable_problem(prior, Mu, Sigma,Data)
K=size(Sigma,3);
d=size(Sigma,1)/2;
tol=10^(-4);
options=sdpsettings('solver','sedumi','verbose',0);
H=H_x(prior, Mu, Sigma,Data(1:d,:));
P0=eye(d,d);

Method=2;
if Method==1
    A = sdpvar(d,d,K,'full');
    C=[];
    for i=1:K
        C=C+[A(:,:,i)'+A(:,:,i) <= -0.0001*eye(d,d)];
    end
    Fun=0;
    for i=1:K
        %     Fun=Fun+repmat(H(:,i),1,d)'.*(A(:,:,i)*Data(1:d,:)+repmat(b(:,i),1,size(Data,2)));
        Fun=Fun+repmat(H(:,i),1,d)'.*(A(:,:,i)*Data(1:d,:));
    end
    diff=Fun-Data(d+1:2*d,:);
    
    % FUN=sum((sum(diff.^2)));
    aux = sdpvar(d,length(diff));
    Fun=sum((sum(aux.^2)));
    C=C+[aux == diff];
    sol =  optimize(C,Fun);
    if sol.problem~=0
        disp('PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM')
        K
    end
    Time=sol.solvertime;
    % sol =  optimize([],sum(Fun));
    A = value(A);
    % b = value(b);
    b=zeros(d,K);
    Sigma_out=Sigma;
    prior_out=prior;
    Mu_out=Mu;
    for i=1:K
        Sigma_input_output=A(:,:,i)*Sigma(1:d,1:d,i);
        Sigma_out(d+1:2*d,1:d,i)=Sigma_input_output;
        Sigma_out(1:d,d+1:2*d,i)=Sigma_input_output';
        Mu_out(d+1:2*d,i)=A(:,:,i)*Mu(1:d,i)+b(:,i);
    end
elseif Method==2
    A = sdpvar(d,d,K,'full');
    P = sdpvar(d,d);
    C=[];
    for i=1:K
        C=C+[A(:,:,i)'*P+P*A(:,:,i) <= -0.0001*eye(d,d)];
    end
    C=C+[0.0001*eye(d,d)<=P];
    Fun=0;
    for i=1:K
        %     Fun=Fun+repmat(H(:,i),1,d)'.*(A(:,:,i)*Data(1:d,:)+repmat(b(:,i),1,size(Data,2)));
        Fun=Fun+repmat(H(:,i),1,d)'.*(A(:,:,i)*Data(1:d,:));
    end
    diff=Fun-Data(d+1:2*d,:);
    % FUN=sum((sum(diff.^2)));
    aux = sdpvar(d,length(diff));
    Fun=sum((sum(aux.^2)));
    C=C+[aux == diff];
    sol =  optimize(C,Fun);
    if sol.problem~=0
        disp('PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM')
        K
    end
    Time=sol.solvertime;
    % sol =  optimize([],sum(Fun));
    A = value(A);
    P=value(P)
    % b = value(b);
    b=zeros(d,K);
    Sigma_out=Sigma;
    prior_out=prior;
    Mu_out=Mu;
    for i=1:K
        Sigma_input_output=A(:,:,i)*Sigma(1:d,1:d,i);
        Sigma_out(d+1:2*d,1:d,i)=Sigma_input_output;
        Sigma_out(1:d,d+1:2*d,i)=Sigma_input_output';
        Mu_out(d+1:2*d,i)=A(:,:,i)*Mu(1:d,i)+b(:,i);
    end
    %     counter=1;
    %     Delta=10*eye(d,d);
    %     P0=eye(d,d);
    %     while counter<50
    %         counter=counter+1;
    %         A = sdpvar(d,d,K,'full');
    %         C=[];
    %         for i=1:K
    %             C=C+[A(:,:,i)'*(P0+Delta)+(P0+Delta)*A(:,:,i) <= -tol*eye(d,d)];
    %         end
    %         Fun=0;
    %         for i=1:K
    %             Fun=Fun+repmat(H(:,i),1,d)'.*(A(:,:,i)*Data(1:d,:));
    %         end
    %         diff=Fun-Data(d+1:2*d,:);
    %         aux = sdpvar(d,length(diff));
    %         Norm_Delta=norm(Delta);
    %         Fun=sum((sum(aux.^2)))-Norm_Delta;
    %         C=C+[aux == diff];
    %         sol =  optimize(C,Fun,options);
    %         Fun_v=value(Fun);
    %         disp( sprintf('Value of Fun is  %d ',Fun_v));
    %         if sol.problem~=0
    %             disp('PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM')
    %             K
    %         end
    %         Time=sol.solvertime;
    %         A = value(A);
    %         Delta = sdpvar(d,d);
    %         C=[];
    %         for i=1:K
    %             C=C+[A(:,:,i)'*(P0+Delta)+(P0+Delta)*A(:,:,i) <= -tol*eye(d,d)];
    %         end
    %         C=C+[tol*eye(d,d)<=P0+Delta];
    %         C=C+[Norm_Delta<=Fun_v];
    %         Norm_Delta=sum((sum(Delta.^2)));
    %         sol =  optimize(C,-Norm_Delta);
    %         Delta=value(Delta);
    %         disp( sprintf('Value of Delta is  %d ',value(Norm_Delta)));
    %         if sol.problem~=0
    %             disp('PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM PROBLEM')
    %         end
    %
    %     end
end








function beta=H_x(prior, Mu, Sigma,Data)
K=size(Sigma);
if max(size(K))==2
    K(1,3)=1;
end
d=size(Data);
Input=Data;

for i=1:K(1,3)
    Numerator(:,i)=gaussPDF(Input, Mu(1:d(1,1),i), Sigma(1:d(1,1),1:d(1,1),i));
    Pxi(:,i) = prior(i).*Numerator(:,i)+realmin;
end
Denominator=sum(Pxi,2)+realmin;
beta = Pxi./repmat(Denominator,1,K(1,3));