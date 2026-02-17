%  ---------------------------------------------------------------------  %
%   M   M  EEEE    A     SSSS  U  U  RRRR   EEEE  M   M  EEEE  N   N  TTTTT
%   MM MM  E      A A   S      U  U  R   R  E     MM MM  E     NN  N    T
%   M M M  EEE   A   A   SSS   U  U  RRRR   EEE   M M M  EEE   N N N    T
%   M   M  E     AAAAA      S  U  U  R  R   E     M   M  E     N  NN    T
%   M   M  EEEE  A   A  SSSS    UU   R   R  EEEE  M   M  EEEE  N   N    T
%
%   N   N   OOO   III   SSSS  EEEEE
%   NN  N  O   O   I   S      E
%   N N N  O   O   I    SSS   EEE
%   N  NN  O   O   I       S  E
%   N   N   OOO   III  SSSS   EEEEE
%  ---------------------------------------------------------------------  %
%% SPECIFY THE MEASUREMENT NOISE PARAMETERS

% Degrees to radians conversion
deg2rad = pi/180;

% Specify which noise signals noise to include
% > Each of these should be set to {'on','yes'} or {'off,'no'}

measurement_noise.full_state_include = 'off';

measurement_noise.body_rates_include = 'off';

measurement_noise.body_accelerations_include = 'off';



% Create a random number gerneator that will be used to generate seeds
measurement_noise.randStream_seed = 42;
measurement_noise.randStream_for_seeds = RandStream.create(...
        'mrg32k3a' ,...
        'NumStreams' , 1 ,...
        'Seed' , measurement_noise.randStream_seed ...        
    );



% MEAN AND VARIANCE SPECIFICATIONS:

% > For the poisition meaurement
%   (units of meters for the mean)
measurement_noise.p_mean    =  zeros(3,1);
measurement_noise.p_stddev  =  [ 0.005 ; 0.005 ; 0.01  ];
measurement_noise.p_var     =  measurement_noise.p_stddev.^2;
measurement_noise.p_seed    =  randi(measurement_noise.randStream_for_seeds,2^32-1,3,1);

% > For the translation velocity meaurement
measurement_noise.p_dot_mean    =  zeros(3,1);
measurement_noise.p_dot_stddev  =  2 * measurement_noise.p_stddev;
measurement_noise.p_dot_var     =  measurement_noise.p_dot_stddev.^2;
measurement_noise.p_dot_seed    =  randi(measurement_noise.randStream_for_seeds,2^32-1,3,1);

% > For the euler anlge meaurement
measurement_noise.psi_mean    =  zeros(3,1);
measurement_noise.psi_stddev  =  [ 0.1 ; 0.1 ; 0.2  ] * deg2rad;
measurement_noise.psi_var     =  measurement_noise.psi_stddev.^2;
measurement_noise.psi_seed    =  randi(measurement_noise.randStream_for_seeds,2^32-1,3,1);

% > For the euler anlgar velocity meaurement
measurement_noise.psi_dot_mean    =  zeros(3,1);
measurement_noise.psi_dot_stddev  =  2 * measurement_noise.psi_stddev;
measurement_noise.psi_dot_var     =  measurement_noise.psi_dot_stddev.^2;
measurement_noise.psi_dot_seed    =  randi(measurement_noise.randStream_for_seeds,2^32-1,3,1);

% > For the full state measurement stacked together
measurement_noise.full_state_mean = [...
        measurement_noise.p_mean        ;...
        measurement_noise.p_dot_mean    ;...
        measurement_noise.psi_mean      ;...
        measurement_noise.psi_dot_mean   ...
    ];
measurement_noise.full_state_var = [...
        measurement_noise.p_var        ;...
        measurement_noise.p_dot_var    ;...
        measurement_noise.psi_var      ;...
        measurement_noise.psi_dot_var   ...
    ];
measurement_noise.full_state_seed = [...
        measurement_noise.p_seed        ;...
        measurement_noise.p_dot_seed    ;...
        measurement_noise.psi_seed      ;...
        measurement_noise.psi_dot_seed   ...
    ];


% > For the gyroscope meaurement of the body rates
measurement_noise.gyroscope_mean    =  zeros(3,1);
measurement_noise.gyroscope_stddev  =  [ 1.0 ; 1.0 ; 1.0  ] * deg2rad;
measurement_noise.gyroscope_var     =  measurement_noise.gyroscope_stddev.^2;
measurement_noise.gyroscope_seed    =  randi(measurement_noise.randStream_for_seeds,2^32-1,3,1);

% > For the accelerometer meaurement of the body frame accelerations
measurement_noise.accelerometer_mean    =  zeros(3,1);
measurement_noise.accelerometer_stddev  =  [ 1.0 ; 1.0 ; 1.0  ];
measurement_noise.accelerometer_var     =  measurement_noise.accelerometer_stddev.^2;
measurement_noise.accelerometer_seed    =  randi(measurement_noise.randStream_for_seeds,2^32-1,3,1);



% % MEAN AND CO-VARIANCE SPECIFICATIONS:

% > For the full state mean vector
%   - this is the "measurement_noise.full_state_mean" defined above

% > For the full state covariance matrix
%   - Specify a diagonal matrix of the variances as the baseline
measurement_noise.full_state_covariance_matrix = diag( measurement_noise.full_state_var );
%   - Add some small covariance between the x and y position measurements
measurement_noise.full_state_covariance_matrix([1,2],[2,1]) = 0.01;
%   - Compute the decomposition needed for computing a multi-variate
%     Gaussian sample given a sample from a standard normal distribution
[U , D] = eig( full( measurement_noise.full_state_covariance_matrix ) );
measurement_noise.full_state_covariance_decomposition = U * sqrt(D);


% > For the gyroscope mean vector
%   - this is the "measurement_noise.gyroscope_mean" defined above

% > For the gyroscope covariance matrix
%   - Specify a diagonal matrix of the variances as the baseline
measurement_noise.gyroscope_covariance_matrix = diag( measurement_noise.gyroscope_var );
%   - Compute the decomposition needed for computing a multi-variate
%     Gaussian sample given a sample from a standard normal distribution
[U , D] = eig( full( measurement_noise.gyroscope_covariance_matrix ) );
measurement_noise.gyroscope_covariance_decomposition = U * sqrt(D);


% > For the accelerometer mean vector
%   - this is the "measurement_noise.accelerometer_mean" defined above

% > For the gyroscope covariance matrix
%   - Specify a diagonal matrix of the variances as the baseline
measurement_noise.accelerometer_covariance_matrix = diag( measurement_noise.accelerometer_var );
%   - Compute the decomposition needed for computing a multi-variate
%     Gaussian sample given a sample from a standard normal distribution
[U , D] = eig( full( measurement_noise.accelerometer_covariance_matrix ) );
measurement_noise.accelerometer_covariance_decomposition = U * sqrt(D);



% CONSTRUCT THE "MEASUREMENT NOISE INCLUSION MULTIPLIERS"

switch measurement_noise.full_state_include
    case {'on','yes'}
        measurement_noise.full_state_inclusion_multiplier = 1;
    otherwise
        measurement_noise.full_state_inclusion_multiplier = 0;
end

switch measurement_noise.body_rates_include
    case {'on','yes'}
        measurement_noise.body_rates_inclusion_multiplier = 1;
    otherwise
        measurement_noise.body_rates_inclusion_multiplier = 0;
end

switch measurement_noise.body_accelerations_include
    case {'on','yes'}
        measurement_noise.body_accelerations_inclusion_multiplier = 1;
    otherwise
        measurement_noise.body_accelerations_inclusion_multiplier = 0;         
end





% Clear the variables that are not needed
clear measurement_noise.full_state_include;
clear measurement_noise.body_rates_include;
clear measurement_noise.body_accelerations_include;
clear measurement_noise.randStream_seed;
clear measurement_noise.randStream_for_seeds
clear deg2rad;