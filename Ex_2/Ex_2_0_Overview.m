%[text] # Class 2 - Drone Simulation
%[text] ## Learning Objectives
%[text] 1. Be able to simulate a general N-rotor vehicle for the purpose of testing and tuning controller and estimator designs.
%[text] 2. Be able to explain how flight performance is affected by changes in the parameters of the N-rotor vehicle, for example mass, centre of gravity location, propeller aerodynamics. \
%%
%[text] ## Overview
%[text] In this exercise we will implement and simulate a drone in Simulink. The model of the drone will be based on the equation of motions covered in the class. The template Simulink model is set up in a way that many blocks contain pointers to variables in the MATLAB workspace. When the model is loaded a preload callback runs the scripts in the helper folder of the exercise and creates the required variables in the MATLAB workspace. During model simulation Simulink accesses the MATLAB workspace to uses those values.
%[text] To evaluate the controller we are going to alter some of the parameters in the Simulink model. To streamline this we like to use MATLAB features such as e.g. plotting, loops or interactive Live Controls. To change variables from within MATLAB we can use the command line or the set\_param function. But while doing so we have to be cautious to also make changes to parameters that are derived from the changed variable. Therefore it is better to change parameters using short scripts that automatically change the derived parameters as well. This approach can be done in a Live Script or in user defined functions. We will use both in this course.
%%
%[text] ## Preparation
%[text] - Read through Section 3.1.2 in the script, which provides a brief explanation of the Simulink template provided for this exercise sheet.
%[text] - You should also read through the comments in the file [exercise02\_simulation\_parameters.m](file:.\helpers\exercise02_simulation_parameters.m) for hints and to understand what variables are available for use in the Simulink model. \
%%
%[text] ## Scripts with individual tasks
%[text] - [Implementation of EoM and Simulation of Quadcopter](file:.\Ex_2_1_Equation_of_Motion.m)
%[text] - [Sensitivity Analysis](file:.\Ex_2_2_Sensitivity.m)
%[text] - [Calculation of Equilibrium Thrusts](file:.\Ex_2_3_Equilibrium_Thrusts.m)
%[text] - [Dependence on Sensor Sample Rate and Controller Pace](file:.\Ex_2_4_ControllerFrequency.m)
%[text] - [Additional Tasks](file:.\Ex_2_5_AdditionalTasks.m) \
%%
%[text] 

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
