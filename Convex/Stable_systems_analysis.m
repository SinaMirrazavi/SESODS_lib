close all
clc
% clear
% Unstable systems analysis
addpath([pwd, '/Unstable_systems_analysis']);
addpath([pwd, '/Stable_systems_analysis']);
cd ..
addpath([pwd, '/YALMIP-master']);
load('matlab.mat','Input_S')
Training_N=[1,9,12,13,10,7,17,4,2,5,15]; %'matlab.mat'
Testing_N=[3,6,8,11,14,16,18,19,20];
% Training_N=[1,2,3,6,11,13,14,16,17,18,20]; % 'matlab_2.mat'
% Testing_N=[4,5,7,8,9,10,12,15,19];
% Training_N=[3,4,5,7,8,9,11,12,16,17,20]; % 'matlab_3.mat'
% Testing_N=[1,2,6,10,13,14,15,18,19];
dt = 1; %The time step of the demonstrations
tol_cutting = 0; % A threshold on velocity that will be used for trimming demos
options.K=3;  %Number of Gaussian funcitons
for i=1:size(Training_N,2)
    Data_Set{1,i}=Input_S{1,Training_N(1,i)}'; %#ok<SAGROW>
end
for i=1:size(Testing_N,2)
    Data_Set_T{1,i}=Input_S{1,Testing_N(1,i)}'; %#ok<SAGROW>
end
close all
% for i=1:20
%    plot(Input_S{1,i}(:,1),Input_S{1,i}(:,2),'DisplayName',sprintf('%f', i),'LineWidth',i)
%    hold on
% end
[~ , ~, DatA, ~] = preprocess_demos(Data_Set,dt,tol_cutting);
[~ , ~, DatA_T, ~] = preprocess_demos(Data_Set_T,dt,tol_cutting);
for counter=1:1
    counter
    options.K=1;  %Number of Gaussian funcitons
    [Unstable_EM.prior,Unstable_EM.Mu,Unstable_EM.Sigma,Unstable_EM.A,Unstable_EM.b,~,~,~,~]=Traing_EM(DatA,options);
%     [Unstable_con{counter}.prior,Unstable_con{counter}.Mu,Unstable_con{counter}.Sigma,Unstable_con{counter}.A,time_CON(counter)]=Learn_The_convex_problem(Unstable_EM.prior,Unstable_EM.Mu,Unstable_EM.Sigma,DatA);
%     Stable{counter}=Unstable_con{counter};
%     [~,Stable{counter}.A,time]=Solve_LMI_Optimze_Delta(Unstable_con{counter}.A);
%     time_CON(counter)=time_CON(counter)+time;
        [Stable{counter}.prior,Stable{counter}.Mu,Stable{counter}.Sigma,Stable{counter}.A,time_CON(counter)]=Learn_The_convex_Stable_problem(Unstable_EM.prior,Unstable_EM.Mu,Unstable_EM.Sigma,DatA);
%          [Stable_CL{counter}.prior,Stable_CL{counter}.Mu,Stable_CL{counter}.Sigma,Stable_CL{counter}.A,time_CON(counter)]=Learn_The_convex_Stable_CL_problem(Unstable_EM.prior,Unstable_EM.Mu,Unstable_EM.Sigma,DatA);
%     [SEDS{counter}.prior, SEDS{counter}.Mu, SEDS{counter}.Sigma, SEDS{counter}.A,time_SEDS(counter)]=SEDS_P(DatA,options.K);
    %
    %     ERROR_CON(counter)=Cross_Validation(DatA,Unstable_con{counter}.prior,Unstable_con{counter}.Mu,Unstable_con{counter}.Sigma,Unstable_con{counter}.A);
    %     ERROR_CON_T(counter)=Cross_Validation(DatA_T,Unstable_con{counter}.prior,Unstable_con{counter}.Mu,Unstable_con{counter}.Sigma,Unstable_con{counter}.A);
        ERROR_Stable(counter)=Cross_Validation(DatA,Stable{counter}.prior,Stable{counter}.Mu,Stable{counter}.Sigma,Stable{counter}.A);
        ERROR_Stable_T(counter)=Cross_Validation(DatA_T,Stable{counter}.prior,Stable{counter}.Mu,Stable{counter}.Sigma,Stable{counter}.A);
    % %     ERROR_Stable_CL(counter)=Cross_Validation(DatA,Stable_CL{counter}.prior,Stable_CL{counter}.Mu,Stable_CL{counter}.Sigma,Stable_CL{counter}.A);
    %     ERROR_Stable_CL_T(counter)=Cross_Validation(DatA_T,Stable_CL{counter}.prior,Stable_CL{counter}.Mu,Stable_CL{counter}.Sigma,Stable_CL{counter}.A);
%         ERROR_SEDS(counter)=Cross_Validation(DatA,SEDS{counter}.prior,SEDS{counter}.Mu,SEDS{counter}.Sigma,SEDS{counter}.A);
%         ERROR_SEDS_T(counter)=Cross_Validation(DatA_T,SEDS{counter}.prior,SEDS{counter}.Mu,SEDS{counter}.Sigma,SEDS{counter}.A);
    
%     DatA_temp{1}=DatA(size(DatA,1)-1:size(DatA,1),:);
%     DatA_T_temp{1}=DatA_T(size(DatA,1)-1:size(DatA,1),:);
%     [~ , ~, DatA_temp_t, ~] = preprocess_demos(DatA_temp,dt,tol_cutting);
%     d{counter}=size(DatA,1);
%     DatA=[DatA(1:2,:);DatA(d{counter}/2+1:d{counter},:);DatA(d{counter}/2+1:d{counter},:);DatA_temp_t(3:4,:)];
%     [~ , ~, DatA_temp_t_T, ~] = preprocess_demos(DatA_T_temp,dt,tol_cutting);
%     DatA_T=[DatA_T(1:2,:);DatA_T(d{counter}/2+1:d{counter},:);DatA_T(d{counter}/2+1:d{counter},:);DatA_temp_t_T(3:4,:)] ;
    
end
