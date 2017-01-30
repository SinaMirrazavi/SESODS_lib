close all
clc
 clear
%% Unstable systems analysis
addpath([pwd, '/Unstable_systems_analysis']);
load('matlab_2.mat','Input_S')
% Training_N=[1,9,12,13,10,7,17,4,2,5,15]; %'matlab.mat'
% Testing_N=[3,6,8,11,14,16,18,19,20];
Training_N=[1,2,3,6,11,13,14,16,17,18,20]; % 'matlab_2.mat'
Testing_N=[4,5,7,8,9,10,12,15,19];
% Training_N=[3,4,5,7,8,9,11,12,16,17,20]; % 'matlab_3.mat'
% Testing_N=[1,2,6,10,13,14,15,18,19];
dt = 1; %The time step of the demonstrations
tol_cutting = 0.0; % A threshold on velocity that will be used for trimming demos
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
% [prior_out,Mu_out,Sigma_out,prior_N,Mu_N,Sigma_N,A,Time]=Solve_The_convex_SMEM(DatA)
Discription='Algorithm_1'
for counter=1:25
    counter
    options.K=25;  %Number of Gaussian funcitons
    [Unstable_EM{counter}.prior,Unstable_EM{counter}.Mu,Unstable_EM{counter}.Sigma,Unstable_EM{counter}.A,Unstable_EM{counter}.b,Ustable_ini.prior,Ustable_ini.Mu,Ustable_ini.Sigma,time_EM(counter)]=Traing_EM(DatA,options);
    [Unstable_con{counter}.prior,Unstable_con{counter}.Mu,Unstable_con{counter}.Sigma,Unstable_con{counter}.A,time_CON(counter)]=Learn_The_convex_problem(Ustable_ini.prior,Ustable_ini.Mu,Ustable_ini.Sigma,DatA);
    [Unstable_con_A{counter}.prior,Unstable_con_A{counter}.Mu,Unstable_con_A{counter}.Sigma,Unstable_con_A{counter}.A,time_CON_A(counter)]=Learn_The_convex_problem_Algorithm_2(Ustable_ini.prior,Ustable_ini.Mu,Ustable_ini.Sigma,DatA);
    ERROR_EM(counter)=Cross_Validation(DatA,Unstable_EM{counter}.prior,Unstable_EM{counter}.Mu,Unstable_EM{counter}.Sigma,Unstable_EM{counter}.A);
    ERROR_EM_T(counter)=Cross_Validation(DatA_T,Unstable_EM{counter}.prior,Unstable_EM{counter}.Mu,Unstable_EM{counter}.Sigma,Unstable_EM{counter}.A);
    ERROR_CON(counter)=Cross_Validation(DatA,Unstable_con{counter}.prior,Unstable_con{counter}.Mu,Unstable_con{counter}.Sigma,Unstable_con{counter}.A);
    ERROR_CON_T(counter)=Cross_Validation(DatA_T,Unstable_con{counter}.prior,Unstable_con{counter}.Mu,Unstable_con{counter}.Sigma,Unstable_con{counter}.A);
    ERROR_CON_A(counter)=Cross_Validation(DatA,Unstable_con_A{counter}.prior,Unstable_con_A{counter}.Mu,Unstable_con_A{counter}.Sigma,Unstable_con_A{counter}.A);
    ERROR_CON_T_A(counter)=Cross_Validation(DatA_T,Unstable_con_A{counter}.prior,Unstable_con_A{counter}.Mu,Unstable_con_A{counter}.Sigma,Unstable_con_A{counter}.A);
%     %         DatA_temp{1}=DatA(size(DatA,1)-1:size(DatA,1),:);
%             DatA_T_temp{1}=DatA_T(size(DatA,1)-1:size(DatA,1),:);
%             [~ , ~, DatA_temp_t, ~] = preprocess_demos(DatA_temp,dt,tol_cutting);
%             d{counter}=size(DatA,1);
%             DatA=[DatA(1:2,:);DatA(d{counter}/2+1:d{counter},:);DatA(d{counter}/2+1:d{counter},:);DatA_temp_t(3:4,:)];
%             [~ , ~, DatA_temp_t_T, ~] = preprocess_demos(DatA_T_temp,dt,tol_cutting);
%              DatA_T=[DatA_T(1:2,:);DatA_T(d{counter}/2+1:d{counter},:);DatA_T(d{counter}/2+1:d{counter},:);DatA_temp_t_T(3:4,:)] ;
%     %     DatA_temp{1}=DatA;
%     %     DatA_T_temp{1}=DatA_T;
%     %     [~ , ~, DatA, ~] = preprocess_demos(DatA_temp,dt,tol_cutting);
%     %     [~ , ~, DatA_T, ~] = preprocess_demos(DatA_T_temp,dt,tol_cutting);
end
