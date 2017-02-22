close all
clc
clear
addpath([pwd, '/Unstable_systems_analysis']);
addpath([pwd, '/Stable_systems_analysis']);
cd ..
addpath(genpath([pwd, '/YALMIP']));
addpath(genpath([pwd, '/sedumi']));
cd Convex
load('Data/matlab.mat','Input_S') % Other options are matlab_3.mat matlab_2.mat
Training_N=[1,9,12,13,10,7,17,4,2,5,15]; %'matlab.mat'
Testing_N=[3,6,8,11,14,16,18,19,20];


dt = 1; %The time step of the demonstrations
tol_cutting = 0; % A threshold on velocity that will be used for trimming demos
options.K=3;  %Number of Gaussian funcitons

for i=1:size(Training_N,2)
    Data_Set{1,i}=Input_S{1,Training_N(1,i)}'; %#ok<SAGROW>
end
for i=1:size(Testing_N,2)
    Data_Set_T{1,i}=Input_S{1,Testing_N(1,i)}'; %#ok<SAGROW>
end
%% Plot
figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
xlabel('X [m]');
ylabel('Y [m]');
box(axes1,'on');
grid(axes1,'on');
set(axes1,'FontSize',24);
for i=1:size(Training_N,2)
   plot(Input_S{1,Training_N(1,i)}(:,1),Input_S{1,Training_N(1,i)}(:,2),'DisplayName','Training set','LineWidth',3,'Color',[1 0 0])
   hold on
end
for i=1:size(Testing_N,2)
   plot(Input_S{1,Testing_N(1,i)}(:,1),Input_S{1,Testing_N(1,i)}(:,2),'DisplayName','Testing set','LineWidth',3,'Color',[0 1 0])
   hold on
end
%% Learning
[~ , ~, DatA, ~] = preprocess_demos(Data_Set,dt,tol_cutting);
[~ , ~, DatA_T, ~] = preprocess_demos(Data_Set_T,dt,tol_cutting);

[Unstable_EM.prior,Unstable_EM.Mu,Unstable_EM.Sigma,Unstable_EM.A,Unstable_EM.b,~,~,~,~]=Traing_EM(DatA,options);
[Stable.prior,Stable.Mu,Stable.Sigma,Stable.A,time_CON]=Learn_The_convex_Stable_problem(Unstable_EM.prior,Unstable_EM.Mu,Unstable_EM.Sigma,DatA);
ERROR_Stable=Cross_Validation(DatA,Stable.prior,Stable.Mu,Stable.Sigma,Stable.A);
ERROR_Stable_Test_Set=Cross_Validation(DatA_T,Stable.prior,Stable.Mu,Stable.Sigma,Stable.A);


%% The out-pout is 
Stable.prior;
Stable.Mu;
Stable.Sigma;
Stable.A;