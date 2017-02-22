
# SESODS_lib

Matlab toolbox to learn a GMM based first and second order dynamical system. This package is developed provide several approximations LPV based dynamical systems. All the systems are based on Gaussian Mixture models. Please cite this paper if you use this package:





# Dependences 

- Yalmip: https://github.com/yalmip/YALMIP
  - Convex and Non convex solvers
    - Personally, I use sedumi, PENLAB and mosek solvers.I've also used Cplex and it is Nice:D 
    
# Features:
- GMR based stable first order dynamical systems.
- GMR based stable second order dynamical systems.
- Several different implementations: Convex or Non convex solvers.
- Signal processing and calculating velocity and acceleration from positions are also included.

# How to run
- If you want to use non-convex solver, you need to run [Main_File.m](https://github.com/sinamr66/SESODS_lib/blob/master/Non_convex/Main_File.m)
- If you want to use convex solver, you need to run [Stable_systems_analysis.m](https://github.com/sinamr66/SESODS_lib/blob/master/Convex/Stable_systems_analysis.m)



This work has been done in collaboration with Alireza Karimi. 
For more information contact Sina Mirrazavi.
