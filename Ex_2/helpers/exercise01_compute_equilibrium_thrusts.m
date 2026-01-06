%[text] # Function to Compute the Equilibrium Thrusts
%[text] This function calculates the equilibrium thrusts as the solution to the following optimization problem.
%[text] ```matlabCodeExample
%[text] % Second, compute the equilibrium thrust as the solution of the
%[text] % following minimisation problem:
%[text] %     
%[text] %     minimise       sum_{i=1}^{N} thrust_i^2
%[text] %
%[text] %     subject to:    nrotor_vehicle_M * [ thrust_1 ; ... ; thrust_N ] ...
%[text] %                          == [ mass*g ; 0 ; 0 ; 0 ]
%[text] %
%[text] %     For which the solution satisfies
%[text] %     [ eye(N) , nrotor_vehicle_M' ; nrotor_vehicle_M , zeros(4,4) ] ...
%[text] %                   == [ zeros(N,1) ; mass*g ; 0 ; 0 ; 0 ]
%[text] ```
%[text] Task: change the function so that the equilibrium thrust is computed using the inverse of the layout matrix $M\_{layout$ instead.
function equilibrium_thrust = exercise01_compute_equilibrium_thrusts(layout,mass,g)
%[text] ```matlabCodeExample
%[text] % INPUT ARGUMENTS:
%[text] % >> "layout"   The layout of the N-rotor vehicle, as defined in the
%[text] %               "exercise01_get_vehicle_paramters.m" file
%[text] % >> "mass"     The total mass of the vehicle, in [kilograms]
%[text] % >> "g"        The acceleration due to gravity, in [meters/second^2]
%[text] 
%[text] % RETURN VARIABLE:
%[text] % >> "equilibrium_thrust"   A column vector of length N that is the
%[text] %                           equilibrium (feed-forward) thrust for each
%[text] %                           propeller of the vehicle.
%[text] ```
% Construct the "propeller-force-to-actuator" conversion matrix:
nrotor_vehicle_M = [...
        ones(1,size(layout,2)) ;...
        layout(2,:) ;...
       -layout(1,:) ;...
        layout(3,:)  ...
    ];

% Put the number of rotors into a variable with a shorter name:
nu = size(layout,2);
%%
% Compute the solution of the optimization problem (this section is to be commented out by the student):
temp_solution = ...
    [ eye(nu) , nrotor_vehicle_M' ; nrotor_vehicle_M , zeros(4,4) ] ...
        \ [ zeros(nu,1) ; mass*g ; 0 ; 0 ; 0 ];

% Extract the equilibrium thrusts from the solution
equilibrium_thrust = temp_solution(1:nu,1);
%%
% Student solution to be added here:
%  equilibrium_thrust=...
%%
end % END OF: "function [...] = exercise01_compute_equilibrium_thrusts(...)"

%[appendix]{"version":"1.0"}
%---
