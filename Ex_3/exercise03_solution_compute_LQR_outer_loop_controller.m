%% --------------------------------------------------------------------- %%
%  Modelling, Control, and Estimator of N-rotor vehicles
%
%% CONTROL ARCHITECTURE AND TUNING OF LQR CONTROLLER
%  
%  Note:
%  LQR stands for Linear Quadratic Regulator
%
%% --------------------------------------------------------------------- %%
%% function [...] = exercise02_solution_compute_LQR_outer_loop_controller(...)
function [ K_lqr_continuous_time , K_lqr_discrete_time ] = exercise03_solution_compute_LQR_outer_loop_controller()

    % Gravitational constant:
    g = 9.81;
    
    % Put the vehicle's mass into a variable with a shorter name:
    m = 0.0320;
        
    % Specify that the input dimension is four, denoted "nu", this
    % corresponds to the total thrust and the angular rates about the
    % (x,y,z) axes of the body frame.
    nu = 4;

    % Specify that the state dimension for the outer loop, denoted "nx"
    nx = 9;
    
    % Specify the quadratic cost matrices
    % J = Sum {x'Qx + u'Ru + 2*x'Nu}
    
    Q_outer_loop = diag([1, 1, 0.5, 0.5, 0.5, 0.5, 1, 1, 1]);
    R_outer_loop = diag([1, 1, 1, 1]);
    S_outer_loop = zeros(nx,nu);


    % Continuous-time matrices for the full state equations of motion  

    % State transition matrix:
    A_continuous_time  =  [...
            0 0 0   1 0 0   0 0 0   ;...
            0 0 0   0 1 0   0 0 0   ;...
            0 0 0   0 0 1   0 0 0   ;...
                                             ...
            0 0 0   0 0 0   0 g 0   ;...
            0 0 0   0 0 0  -g 0 0   ;...
            0 0 0   0 0 0   0 0 0   ;...
                                             ...
            0 0 0   0 0 0   0 0 0   ;...
            0 0 0   0 0 0   0 0 0   ;...
            0 0 0   0 0 0   0 0 0   ;...
        ];



    % Input matrix:
    B_continuous_time  =  [...
            zeros(1,nu)         ;...
            zeros(1,nu)         ;...
            zeros(1,nu)         ;...
                                 ...
            zeros(1,nu)         ;...
            zeros(1,nu)         ;...
            [1/m,0,0,0]         ;...
                                 ...
            [0,1,0,0]           ;...
            [0,0,1,0]           ;...
            [0,0,0,1]           ;...
        ];

    
    
    % CONTINUOUS-TIME LQR SOLUTION

    % Solve the LQR formulation
    [K,~,~] = lqr( A_continuous_time , B_continuous_time , Q_outer_loop , R_outer_loop , S_outer_loop);

    % Put the feedback gain matrix into the return variable
    K_lqr_continuous_time = K;

    % ------------------------------------------------------------------- %
    % DISCRETE TIME LQR SOLUTION
    
    % Compute the sampling time
    Ts = 1/200;

    % Output matrix
    C_continuous_time = eye(nx);

    % The feed-through matrix
    D_continuous_time = zeros(nx,nu);

    % Convert continuous-time state space to discrete-time
    nrotor_sys_continous_time   =  ss(A_continuous_time, B_continuous_time, C_continuous_time, D_continuous_time);
    nrotor_sys_discrete_time    =  c2d(nrotor_sys_continous_time, Ts , 'zoh');
    [A_discrete_time, B_discete_time, ~, ~] = ssdata(nrotor_sys_discrete_time);

    % Solve the LQR formulation
    [K,~,~] = dlqr(A_discrete_time, B_discete_time, Q_outer_loop, R_outer_loop, S_outer_loop);

    % Put the feedback gain matrix into the return variable
    K_lqr_discrete_time = K;
    

end % END OF: "function [...] = exercise02_solution_compute_LQR_controller(...)"
%% --------------------------------------------------------------------- %%