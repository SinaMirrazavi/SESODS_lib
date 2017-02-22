close all
clc
clear
addpath([pwd, '/Unstable_systems_analysis']);
addpath([pwd, '/Stable_systems_analysis']);
cd ..
addpath(genpath([pwd, '/Non_convex']));
cd Convex
load('Data/matlab.mat','Input_S') % Other options are matlab_3.mat matlab_2.mat
Training_N=[1,9,12,13,10,7,17,4,2,5,15]; %'matlab.mat'
Testing_N=[3,6,8,11,14,16,18,19,20];
for i=1:size(Training_N,2)
    Data_Set{1,i}=Input_S{1,Training_N(1,i)}'; %#ok<SAGROW>
end
for i=1:size(Testing_N,2)
    Data_Set_T{1,i}=Input_S{1,Testing_N(1,i)}'; %#ok<SAGROW>
end

%% Initialization
options.dt = 0.1; %The time step of the demonstrations
options.tol_cutting = 0.00001; % A threshold on velocity that will be used for trimming demos

% Training parameters
options.K =3; %Number of Gaussian
options.d=2; % Dimention  of Demostrations
options.I=1; % It's a reduced factor. Leave it one if you want the dynamical system is trainded according to all the data.
options.tol_mat_bias = 10^-18; % A very small positive scalar to avoid  instabilities in Gaussian kernel
options.display = 1;          % An option to control whether the algorithm displays the output of each iterations [default: true]
options.tol_stopping=10^(-6);  % A small positive scalar defining the stoppping tolerance for the optimization solver [default: 10^-10]
options.max_iter = 1000; % Maximum number of iteration for the solver [default: i_max=1000]
options.TolCon = 1e-2;   % Tolerance on the constraint violation, a positive scalar. The default is 1e-6.
options.Normilizing='False'; % If the number of the training data points need to be normalized along the path.
options.Velocity='False'; % Velocity and Position of the demostrations are provided by the user.
% If you put it false, make sure that the name of demostrations are demo_P, and demo_V with same lengh.
options.method='APA'; % APA to construct J-SD
% SYM to constract S-SD
options.smoothing='False'; % Recunstracting the demostrations from velocity profile.
options.Method=1; % Two types for initilizing are provied. First one is based on a one mapping from velocities and Positions to accelerartions.
% Second one is based on a seperate mapping from velocities and Positions to accelerartions
options.Method_For_APA='NSYM'; % SYM to use the result of S-DS to coustract a J-SD
options.LPV=1; % convert the output of the optimization to LPV GMR based system
if options.LPV==1
    options.method='APA'; % APA to construct J-SD
    options.Method_For_APA='NSYM'; % SYM to use the result of S-DS to coustract a J-SD
end
%% SESODS

if (strcmp(options.Velocity,'False')==1)
    demos_P=[];
    demos_V=[];
end
% Initialization

[Priors_0_P,Mu_0_P,Sigma_0_P,Priors_0_V, Mu_0_V, Sigma_0_V, Data_P_A, Data_V_A,Data_A,demos_P,demos_V,demos,Time]=Initialization(Data_Set,demos_P,demos_V,options);
DatA=[Data_P_A(1:options.d,:);Data_V_A(1:options.d,:);Data_V_A(1:options.d,:);Data_V_A(options.d+1:2*options.d,:)];
[Unstable_EM.prior,Unstable_EM.Mu,Unstable_EM.Sigma,Unstable_EM.A,Unstable_EM.b,~,~,~,~]=Traing_EM(DatA,options);
[Stable.prior,Stable.Mu,Stable.Sigma,Stable.A,time_CON]=Learn_The_convex_Stable_problem_second(Unstable_EM.prior,Unstable_EM.Mu,Unstable_EM.Sigma,DatA);
%% Simulation