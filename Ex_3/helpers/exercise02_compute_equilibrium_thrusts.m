function equilibrium_thrust = exercise02_compute_equilibrium_thrusts(layout,mass,g)
%  ---------------------------------------------------------------------  %
%   EEEEE   QQQ   U   U  III  L      III  BBBB   RRRRI  III  U   U  M   M
%   E      Q   Q  U   U   I   L       I   B   B  R   R   I   U   U  MM MM
%   EEE    Q   Q  U   U   I   L       I   BBBB   RRRR    I   U   U  M M M
%   E      Q  Q   U   U   I   L       I   B   B  R  R    I   U   U  M   M
%   EEEEE   QQ Q   UUU   III  LLLLL  III  BBBB   R   R  III   UUU   M   M
%
%   TTTTT  H   H  RRRR   U   U   SSSS  TTTTT   SSSS
%     T    H   H  R   R  U   U  S        T    S
%     T    HHHHH  RRRR   U   U   SSS     T     SSS
%     T    H   H  R  R   U   U      S    T        S
%     T    H   H  R   R   UUU   SSSS     T    SSSS
%  ---------------------------------------------------------------------  %
%% COMPUTE THE EQUILIBRIUM THRUSTS

% INPUT ARGUMENTS:
% >> "layout"   The the layout of the N-rotor vehicle, as defined in the
%               "exercise01_get_vehicle_paramters.m" file
% >> "mass"     The total mass of the vehicle, in [kilograms]
% >> "g"        The acceleration due to gravity, in [meters/second^2]

% RETURN VARIABLE:
% >> "equilibrium_thrust"   A column vector of length N that is the
%                           equilibrium (feed-forward) thrust for each
%                           propeller of the vehicle.

%  ---------------------------------------------------------------------  %
%% TO COMPLETE THE EXERCISE, FIRST DELETE (OR COMMENT) THE CODE BELOW HERE


% STEP 1:
% Construct the "propeller-force-to-actuator" conversion matrix:
nrotor_vehicle_M = [...
        ones(1,size(layout,2)) ;...
        layout(2,:) ;...
       -layout(1,:) ;...
        layout(3,:)  ...
    ];

% STEP 2:
% Second, compute the equilibrium thrust as the solution of the
% following minimisation problem:
%     
%     minimise       sum_{i=1}^{N} thrust_i^2
%
%     subject to:    nrotor_vehicle_M * [ thrust_1 ; ... ; thrust_N ] ...
%                          == [ mass*g ; 0 ; 0 ; 0 ]
%
%     For which the solution satisfies
%     [ eye(N) , nrotor_vehicle_M' ; nrotor_vehicle_M , zeros(4,4) ] ...
%                   == [ zeros(N,1) ; mass*g ; 0 ; 0 ; 0 ]
%

% Put the number of rotors into a variable with a shorter name:
nu = size(layout,2);

% Compute the solution:
temp_solution = ...
    [ eye(nu) , nrotor_vehicle_M' ; nrotor_vehicle_M , zeros(4,4) ] ...
        \ [ zeros(nu,1) ; mass*g ; 0 ; 0 ; 0 ];

% Extract the equilibrium thrusts from the solution
equilibrium_thrust = temp_solution(1:nu,1);


%% TO COMPLETE THE EXERCISE, FIRST DELETE (OR COMMENT) THE CODE ABOVE HERE
%  ---------------------------------------------------------------------  %

end % END OF: "function [...] = exercise01_compute_equilibrium_thrusts(...)"