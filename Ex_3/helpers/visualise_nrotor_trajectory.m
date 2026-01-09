function h_notor_trajectory = visualise_nrotor_trajectory( full_state , reference , nrotor_vehicle_layout , thrusts )


% visualise_nrotor_trajectory  provides a 3D visualisation for the template
%                              Simulink model provide for the N-rotor class
% 
% HANDLES = visualise_nrotor_trajectory( FULL_STATE , REFERENCE , N_ROTOR_VEHICLE_LAYOUT , THRUSTS )
%
% > HANDLES is a struct of handles to all elements plotted
% > FULL_STATE is the varaible "simout_full_state" from the Simulink
%   template provided as part of the course
% > N_ROTOR_VEHICLE_LAYOUT is the "nrotor_vehicle_layout" variable from the
%   matlab paramter script provided as part of the course
% > The other 2 input arguments are not supported yet
%
% USAGE:
% After compiling and running the Simulink template model, put either of
% the following commands into the Matlab "Command Window"
% >> traj_handles = visualise_nrotor_trajectory( simout_full_state )
%
% >> traj_handles = visualise_nrotor_trajectory( simout_full_state , [] , nrotor_vehicle_layout )
%
%


% LONG DESCRIPTION THE INPUT ARGUMENTS TO THE FUNCTION
%
% The FIRST input argument is the FULL_STATE over time
% NOTE: this comes directly from Simulink and hence will be a struct with
% properties:
% .Time   > a column vector with the time at which "Data" is available
% .Data   > matrix of size "length(.Time) -by- 12"
% The columns of the ".Data" property are ordered as:
% [ position , velocity , euler angles , euler rates ]
%
%
% The SECOND input argument is the REFERENCE over time
% NOTE: this comes directly from Simulink and hence will be a struct with
% properties:
% .Time   > a column vector with the time at which "Data" is available
% .Data   > matrix of size "length(.Time) -by- 4"
% The columns of the ".Data" property are ordered as:
% [ [x,y,z] inertial position , yaw angle ]
%
%
% The THIRD input argument is the layout of the N-rotor vehicle.
% NOTE: this is required to be able to plot the fourth input argument of
% per motor thrusts
% NOTE: the layout is specified as a matrix with the following format:
% nrotor_vehicle_layout = [...
%       x_1  ,  x_2  ,  ...  ,  x_{N-1}  ,  x_{N}  ;...
%       y_1  ,  y_2  ,  ...  ,  y_{N-1}  ,  y_{N}  ;...
%       c_1  ,  c_2  ,  ...  ,  c_{N-1}  ,  c_{N}   ...
%   ];
% where:
%   > x_i   is the x coordinate of propeller "i" relative to the CoG
%   > y_i   is the y coordinate of propeller "i" relative to the CoG
%   > c_i   is the thurst to torque coefficient of the propeller, with the
%           sign used to indicate the propeller's direction of rotation,
%           +ve indicates clock-wise propeller rotation.
%
%
% The FOURTH input argument is the per motor THRUSTS over time
% NOTE: this comes directly from Simulink and hence will be a struct with
% properties:
% .Time   > a column vector with the time at which "Data" is available
% .Data   > matrix of size "length(.Time) -by- number of rotors"
% The columns of the ".Data" property are ordered as:
% [ thrust for rotor 1  ,  ...  ,  thrust for rotor N ]
%
%

%% --------------------------------------------------------------------- %%
%% SPECIFY THE VARIOUS OPTIONS
xyz_trajectory_color = [4,90,141]/255;


% Specify the spacing of time points in [SECONDS]
time_progression_spacing = 1;
% Specify the marker size of the time points
time_progression_marker_size = 200;


x_inertial_color = [1,0,0];
y_inertial_color = [0,1,0];
z_inertial_color = [0,0,1];


x_body_frame_color = [1,0,0];
y_body_frame_color = [0,1,0];
z_body_frame_color = [0,0,1];

inertial_axes_length_proportion = 0.12;


% Specify how to decide where to draw the body frame axes
% > OPTIONS: { 'time' , 'distance' }
body_frame_spacing_method = 'time';
% Specify the body frame time spacing [SECONDS]
body_frame_time_spacing = 0.2;
% Specify the body frame distance spacing [METERS]
body_frame_distance_spacing = 0.1;

body_frame_axes_length_proportion = 0.07;


vehicle_scaling = 1.0;

frame_colour = 0.1 * [1,1,1];
%frame_alpha  = 0.75;

rotor_disc_colour = 0.20 * [1,1,1];
rotor_disc_alpha = 0.50;

%motor_colour = 0.4 * [1,1,1];
%rotor_boundary_colour = [165,15,21]/255;
%rotor_rotation_colour = [222,45,38]/255;




%% PARSE THE INPUT ARGUMENTS

%% >> for the "full_state"

% Check that the variable exists
if not(exist('full_state','var'))
    % Let the user know
    disp( '[ERROR] >> the first input argument "full_state" was not supplied,' );
    disp( '           hence exiting function without plotting anything.' );
    return;
    
else
    % Check that the variable supplied is a struct
    if not(isa(full_state,'timeseries'))
        % Let the user know
        disp( '[ERROR] >> the first input argument "full_state" is not a timeseries,' );
        disp( '           hence exiting function without plotting anything.' );
        return;
    else
        % Check that the variable supplied has the necessry properties
        if not(all( ismember( {'Time','Data'} , fields(full_state) )))
            % Let the user know
            disp( '[ERROR] >> the first input argument "full_state" does not have' );
            disp( '           the properties ".Time" and ".Data",' );
            disp( '           hence exiting function without plotting anything.' );
            return;
        else
            % This function will continue and the "full_state" variable can
            % be safely used with the expected convention
        end
        
    end
    
end


%% >> for the "reference"

% Default the flag that the reference is not available
flag_reference_available = false;

% Check that the variable exists
if not(exist('reference','var'))
    % Flag is already set to "false"
else
    % Check if the variable supplied is empty
    if isempty(reference)
        % Do nothing, this indicates that the user did not supply the
        % "reference" input argument on purpose
    else
        % Check that the variable supplied is a struct
        if not(isa(reference,'timeseries'))
            % Let the user know
            disp( '[ERROR] >> the second input argument "reference" is not a timeseries,' );
            disp( '           hence not plotting the reference.' );
            return;
        else
            % Check that the variable supplied has the necessry properties
            if not(all( ismember( {'Time','Data'} , fields(reference) )))
                % Let the user know
                disp( '[ERROR] >> the second input argument "reference" does not have' );
                disp( '           the properties ".Time" and ".Data",' );
                disp( '           hence not plotting the reference.' );
                return;
            else
                % Set the flag that the function can safely use the variable
                % "reference" with the expected convention
                flag_reference_available = true;
            end

        end
        
    end
    
end



%% >> for the "nrotor_vehicle_layout"

% Default the flag that the reference is not available
flag_nrotor_vehicle_layout_available = false;
% Default the number of rotors to zero
N = 0;

% Check that the variable exists
if not(exist('nrotor_vehicle_layout','var'))
    % Flag is already set to "false"
else
    % Check if the variable supplied is empty
    if isempty(nrotor_vehicle_layout)
        % Do nothing, this indicates that the user did not supply the
        % "nrotor_vehicle_layout" input argument on purpose
    else
        % Check that the variable supplied is a struct
        if not(ismatrix(nrotor_vehicle_layout))
            % Let the user know
            disp( '[ERROR] >> the third input argument "nrotor_vehicle_layout" is not a matrix,' );
            disp( '           hence not plotting the vehicle (or thrusts).' );
            return;
        else
            % Set the flag that the function can safely use the variable
            % "nrotor_vehicle_layout" with the expected convention
            flag_nrotor_vehicle_layout_available = true;
        end
        
    end
    
end


%% >> for the "thrusts"

% Default the flag that the reference is not available
flag_thrusts_available = false;

% Check that the variable exists
if not(exist('thrusts','var'))
    % Flag is already set to "false"
else
    % Check if the variable supplied is empty
    if isempty(thrusts)
        % Do nothing, this indicates that the user did not supply the
        % "thrusts" input argument on purpose
    else
        % Check that the variable supplied is a struct
        if not(isa(thrusts,'timeseries'))
            % Let the user know
            disp( '[ERROR] >> the fourth input argument "thrusts" is not a timeseries,' );
            disp( '           hence not plotting the thrusts.' );
            return;
        else
            % Check that the variable supplied has the necessry properties
            if not(all( ismember( {'Time','Data'} , fields(thrusts) )))
                % Let the user know
                disp( '[ERROR] >> the fourth input argument "thrusts" does not have' );
                disp( '           the properties ".Time" and ".Data",' );
                disp( '           hence not plotting the thrusts.' );
                return;
            else
                % Set the flag that the function can safely use the variable
                % "reference" with the expected convention
                flag_thrusts_available = true;
            end

        end
        
    end
    
end





%% --------------------------------------------------------------------- %%
%% COMPUTE SOME DETAILS ABOUT THE N-ROTOR VEHICLE LAYOUT (if avilable)

if flag_nrotor_vehicle_layout_available

    %% Get the number of rotors into the local variable
    N = size( nrotor_vehicle_layout , 2 );


    %% Compute the distances between any two rotor

    % Initialise the minimum distance
    inter_rotor_distance_min = inf;

    % Pre-allcoate a vector for the distance to the nearest neightbour
    inter_rotor_distance_nearest_neighbour = zeros(N,1);

    % Pre-allocate a matrix for the distance between the rotor
    inter_rotor_distance_matrix = zeros(N,N);

    % Iterate over all possible combination in a double for loop
    for i_rotor = 1:N
        % Get the "x_i" and "y_i" for this rotor
        this_x_i = nrotor_vehicle_layout(1,i_rotor);
        this_y_i = nrotor_vehicle_layout(2,i_rotor);
        for j_rotor = i_rotor+1:N
            % Get the "x_i" and "y_i" for this rotor
            this_x_j = nrotor_vehicle_layout(1,j_rotor);
            this_y_j = nrotor_vehicle_layout(2,j_rotor);

            % Compute the distance for this iteration
            this_dist = sqrt( (this_x_j-this_x_i)^2 + (this_y_j-this_y_i)^2 );

            % Update the variable for tracking the overall minimum distance
            inter_rotor_distance_min = min( this_dist , inter_rotor_distance_min );

            % Put the distance into the matrix (both triangles)
            inter_rotor_distance_matrix(i_rotor,j_rotor) = this_dist;
            inter_rotor_distance_matrix(j_rotor,i_rotor) = this_dist; 
        end
        % Place inf on the diagonal
        inter_rotor_distance_matrix(i_rotor,i_rotor) = inf;

        % Compute the nearest neighbour distance
        this_nearest_neighbour_distance = min( inter_rotor_distance_matrix(i_rotor,:) );

        % Put the nearst neightbour distance into the vector
        inter_rotor_distance_nearest_neighbour(i_rotor,1) = this_nearest_neighbour_distance;
    end

end


%% PLOT THE TRAJECTORY


%% >> OPEN a new figure and create the axes
% Get the screen size of the machine in use
this_screensize = get( groot, 'Screensize' );

this_screen_width  = this_screensize(3);
this_screen_height = this_screensize(4);

% Open a figure
h_fig = figure;

% Give the figure a name
if N>0
    h_fig.Name = ['Trajectory view of your vehicle.' ];
else
    h_fig.Name = ['Trajectory view of your ',num2str(N),'-rotor vehicle.' ];
end

% Set the position of the figure
h_fig.Position = [...
        0.1*this_screen_width  ,...
        0.1*this_screen_height ,...
        0.8*this_screen_width  ,...
        0.8*this_screen_height  ...
    ];

% Add an axes to the figure
h_axes = axes( h_fig );

% Set the position of the axes
h_axes.Position = [0.1 , 0.1 , 0.85 , 0.85 ];

% Set the axes to be "hold on"
hold( h_axes , 'on' );




%% >> Plot the INTERTIAL AXES

% Get the limits in each direction
curr_x_lim = xlim( h_axes );
curr_y_lim = ylim( h_axes );
curr_z_lim = zlim( h_axes );

% Compute the range in each interial direction
curr_x_range = curr_x_lim(2) - curr_x_lim(1);
curr_y_range = curr_y_lim(2) - curr_y_lim(1);
curr_z_range = curr_z_lim(2) - curr_z_lim(1);

% Get the minimum range and compute the axes length
curr_range_min = min( [curr_x_range,curr_y_range,curr_z_range] );
intertial_axes_length = inertial_axes_length_proportion * curr_range_min;

% Pre-allocate an array for the axes line handles
h_inertial_axes_lines = gobjects(3,1);

% Plot the x-interial-frame axes
h_inertial_axes_lines(1,1) = line( h_axes , [0,intertial_axes_length] , [0,0] , [0,0] );
h_inertial_axes_lines(1,1).Color = x_inertial_color;

% Plot the y-interial-frame axes
h_inertial_axes_lines(2,1) = line( h_axes , [0,0] , [0,intertial_axes_length] , [0,0] );
h_inertial_axes_lines(2,1).Color = y_inertial_color;

% Plot the z-interial-frame axes
h_inertial_axes_lines(3,1) = line( h_axes , [0,0] , [0,0] , [0,intertial_axes_length] );
h_inertial_axes_lines(3,1).Color = z_inertial_color;

% Set the other properties of the axes lines
set( h_inertial_axes_lines , 'LineWidth' , 2.0 );

% Pre-allocate an array for the axes label handles
h_inertial_axes_labels = gobjects(3,1);

% Plot the interial-frame labels
h_inertial_axes_labels(1,1) = text( h_axes , 1.2*intertial_axes_length , 0 , 0 , '$x^{(I)}$' );
h_inertial_axes_labels(2,1) = text( h_axes , 0 , 1.2*intertial_axes_length , 0 , '$y^{(I)}$' );
h_inertial_axes_labels(3,1) = text( h_axes , 0 , 0 , 1.2*intertial_axes_length , '$z^{(I)}$' );

% Set the text colour of the inertial frame labels
h_inertial_axes_labels(1,1).Color = x_inertial_color;
h_inertial_axes_labels(2,1).Color = y_inertial_color;
h_inertial_axes_labels(3,1).Color = z_inertial_color;

% Set the properties of the axes labels
set( h_inertial_axes_labels , 'Interpreter' , 'latex' );
set( h_inertial_axes_labels , 'FontSize' , 20 );
set( h_inertial_axes_labels , 'HorizontalAlignment' , 'center' );
set( h_inertial_axes_labels , 'VerticalAlignment' , 'middle' );




%% >> Plot the (x,y,z) TRAJECTORY


% Directly plot the (x,y,z) full state data in 3D
h_xyz_trajectory = plot3( h_axes ,...
        full_state.Data(:,1) ,...
        full_state.Data(:,2) ,...
        full_state.Data(:,3)  ...
    );

% Make the trajectory line look nice
h_xyz_trajectory.LineWidth = 1.0;
h_xyz_trajectory.Color = xyz_trajectory_color;




%% >> Plot TIME along the (x,y,z) trajectory

% Get the minimum and maximum time
full_state_time_min = min( full_state.Time );
full_state_time_max = max( full_state.Time );

% Create the vector of time point to plot
time_point_vector_to_plot = ceil(full_state_time_min) : time_progression_spacing : floor(full_state_time_max);

% Get the length of the time point vector
num_time_points_to_plot = length( time_point_vector_to_plot );

% Get the (x,y,z) trajectory coordinates at these points
xyz_for_time_point_to_plot = interp1(full_state.Time,full_state.Data(:,1:3),time_point_vector_to_plot,'linear');

% Plot a scatter of the point
h_time_progression_scatter = scatter3( h_axes ,...
        xyz_for_time_point_to_plot(:,1) ,...
        xyz_for_time_point_to_plot(:,2) ,...
        xyz_for_time_point_to_plot(:,3) ,...
        time_progression_marker_size ,...
        'Marker' , 'o' ,...
        'MarkerFaceColor' , 'flat' ,...
        'MarkerEdgeColor' , xyz_trajectory_color ...
    );

% Prepare a color vector for plot a scatter of the points
% > This is scaled from white to the trajectory color
temp_color_scaling_factor = ( (time_point_vector_to_plot-time_point_vector_to_plot(1)) ./ (time_point_vector_to_plot(num_time_points_to_plot)-time_point_vector_to_plot(1)) ).';
temp_cdata = bsxfun( @minus , [1,1,1] , bsxfun( @times , temp_color_scaling_factor , [1,1,1]-xyz_trajectory_color ) );
h_time_progression_scatter.CData = temp_cdata;



%% >> Plot BODY FRAME along the (x,y,z) trajectory

% Compute the length of the axes
% Get the limits in each direction
curr_x_lim = xlim( h_axes );
curr_y_lim = ylim( h_axes );
curr_z_lim = zlim( h_axes );

% Compute the range in each interial direction
curr_x_range = curr_x_lim(2) - curr_x_lim(1);
curr_y_range = curr_y_lim(2) - curr_y_lim(1);
curr_z_range = curr_z_lim(2) - curr_z_lim(1);

% Get the minimum range and compute the axes length
curr_range_min = min( [curr_x_range,curr_y_range,curr_z_range] );
body_frame_axes_length = body_frame_axes_length_proportion * curr_range_min;

% Switch depending on the spacing method
switch body_frame_spacing_method
    
    % For the TIME spaced method
    case 'time'
        
        % Get the minimum and maximum time
        full_state_time_min = min( full_state.Time );
        full_state_time_max = max( full_state.Time );
        
        % Create the vector of time point to plot
        body_frame_time_point_vector = full_state_time_min : body_frame_time_spacing : full_state_time_max;

        % Get the length of the time point vector
        num_body_frame_time_points = length( body_frame_time_point_vector );

        % Get the (x,y,z) trajectory coordinates at these points
        xyz_rpy_for_body_frame_time_point = interp1(full_state.Time,full_state.Data(:,[1:3,7:9]),body_frame_time_point_vector,'linear');
        
    % For the DISTANCE spaced method
    case 'distance'
        
        % Pre-allocate a vector of "time indicies" to plot
        body_frame_time_index = zeros( length(full_state.Time) , 1 );
        
        % Initialise a counter for the number of time indices added
        curr_time_index = 0;
        
        % Add the first point of the trajectory
        curr_time_index = curr_time_index + 1;
        body_frame_time_index(curr_time_index,1) = 1;
        % Set this as the previous point
        prev_xyz = full_state.Data(1,1:3);
        
        % Iterate over all the points
        for i_point = 2:length(full_state.Time)
            % Compute the distance from the previous position to this
            % position
            this_dist = norm( prev_xyz - full_state.Data(i_point,1:3) , 2 );
            
            % Check if far enough away to add this point
            if this_dist >= body_frame_distance_spacing
                % Add the this time index
                curr_time_index = curr_time_index + 1;
                body_frame_time_index(curr_time_index,1) = i_point;
                % Set this as the previous point
                prev_xyz = full_state.Data(i_point,1:3); 
            end
        end
        
        % Cut down the time indices to only those to be plotted
        body_frame_time_index = body_frame_time_index(1:curr_time_index,1);
        
        % Get the length of the time indices vector
        num_body_frame_time_points = length( body_frame_time_index );
        
        % Get the (x,y,z) trajectory coordinates at these points
        xyz_rpy_for_body_frame_time_point = full_state.Data(body_frame_time_index,[1:3,7:9]);
        
    otherwise
        % @TODO: error handling
        
end


% Pre-allocate handles for all the axes
h_body_frame_axes_lines = gobjects(3,num_body_frame_time_points);

% Iterate through the points
for i_point = 1:num_body_frame_time_points
    % Get the (x,y,z) for this point
    this_xyz_I = xyz_rpy_for_body_frame_time_point(i_point,1:3).';
    % Get the (roll,pitch,yaw) for this point
    r = xyz_rpy_for_body_frame_time_point(i_point,4);
    p = xyz_rpy_for_body_frame_time_point(i_point,5);
    y = xyz_rpy_for_body_frame_time_point(i_point,6);
    % Compute the rotation matrix
    this_rotmat_IB = [...
             cos(y)*cos(p) , -sin(y)*cos(r)+cos(y)*sin(p)*sin(r) ,  sin(y)*sin(r)+cos(y)*sin(p)*cos(r) ;...
             sin(y)*cos(p) ,  cos(y)*cos(r)+sin(y)*sin(p)*sin(r) , -cos(y)*sin(r)+sin(y)*sin(p)*cos(r) ;...
            -sin(p)        ,  cos(p)*sin(r)                      ,  cos(p)*cos(r)                       ...
        ];
    % Compute the points to plot
    axes_xyz_I = this_rotmat_IB * eye(3) * body_frame_axes_length + repmat(this_xyz_I,1,3);
    % Plot the axes
    h_body_frame_axes_lines(1,i_point) = line( h_axes , [this_xyz_I(1),axes_xyz_I(1,1)] , [this_xyz_I(2),axes_xyz_I(2,1)] , [this_xyz_I(3),axes_xyz_I(3,1)] );
    h_body_frame_axes_lines(2,i_point) = line( h_axes , [this_xyz_I(1),axes_xyz_I(1,2)] , [this_xyz_I(2),axes_xyz_I(2,2)] , [this_xyz_I(3),axes_xyz_I(3,2)] );
    h_body_frame_axes_lines(3,i_point) = line( h_axes , [this_xyz_I(1),axes_xyz_I(1,3)] , [this_xyz_I(2),axes_xyz_I(2,3)] , [this_xyz_I(3),axes_xyz_I(3,3)] );

    % Plot the N-rotor vehicle body (if available)
    if flag_nrotor_vehicle_layout_available
        % >> Plot the FRAME as connections to the center or gravity
        % Rotate all center locations from Body to Inertial frame
        rotor_location = this_xyz_I + this_rotmat_IB * [vehicle_scaling*nrotor_vehicle_layout(1:2,:);zeros(1,N)];
        % Construct a matrix to plot all "frame lines" at once
        frame_lines_x = [ this_xyz_I(1)*ones(1,N) ; rotor_location(1,:) ];
        frame_lines_y = [ this_xyz_I(2)*ones(1,N) ; rotor_location(2,:) ];
        frame_lines_z = [ this_xyz_I(3)*ones(1,N) ; rotor_location(3,:) ];
        % Plot all the lines
        h_frame_lines = line( h_axes , frame_lines_x , frame_lines_y , frame_lines_z );
        % Set the properties of the frame lines
        set( h_frame_lines , 'LineWidth' , 2.0 );
        set( h_frame_lines , 'Color' , frame_colour );

        % >> Plot the ROTORS AS DISCS
        % Get a grid of anlges around the circle
        temp_angles = (0:pi/12:2*pi);
        % Pre-allocate the matrices for plotting patches
        rotor_disc_x = zeros( length(temp_angles) , N );
        rotor_disc_y = zeros( length(temp_angles) , N );
        rotor_disc_z = zeros( length(temp_angles) , N );
        % Iterate over the rotor
        for i_rotor = 1:N
            % Rotate all the point for this rotor from B-to-I
            temp_I = this_xyz_I + this_rotmat_IB *...
                (vehicle_scaling .*...
                [ nrotor_vehicle_layout(1,i_rotor) + cos(temp_angles)*0.5*inter_rotor_distance_nearest_neighbour(i_rotor) ;...
                  nrotor_vehicle_layout(2,i_rotor) + sin(temp_angles)*0.5*inter_rotor_distance_nearest_neighbour(i_rotor) ;...
                  zeros( 1 , length(temp_angles) ) ...
                ]);
            % Put this into the appropriate column of the matrices
            % for plotting
            rotor_disc_x(:,i_rotor) = temp_I(1,:);
            rotor_disc_y(:,i_rotor) = temp_I(2,:);
            rotor_disc_z(:,i_rotor) = temp_I(3,:);
        end
        % Plot all the rotors as a patch
        h_rotor_disc_patch = patch( h_axes , rotor_disc_x , rotor_disc_y , rotor_disc_z , rotor_disc_colour );
        % Set the properties of the patch
        set( h_rotor_disc_patch , 'FaceAlpha' , rotor_disc_alpha );



    end

end

% Set the colour of the axes
set( h_body_frame_axes_lines(1,:) , 'Color' , x_body_frame_color );
set( h_body_frame_axes_lines(2,:) , 'Color' , y_body_frame_color );
set( h_body_frame_axes_lines(3,:) , 'Color' , z_body_frame_color );
% Set the other properties of the axes lines
set( h_body_frame_axes_lines , 'LineWidth' , 1.5 );


%% >> SET THE PROPERTIES OF THE AXES TO MAKE THINGS LOOK NICE

% Make the axes equal
%axis( h_axes , 'equal' );

% Set the default 3D viewing perspective
view( h_axes , 3 );

% Add grid lines, and set their properties
grid( h_axes , 'on' );
h_axes.GridLineStyle = ':';
h_axes.GridColor = 0.30 * [1,1,1];
h_axes.GridAlpha = 0.80;

% Set the tick label properties
h_axes.TickDir = 'out';
h_axes.FontSize = 14;


% Add a title to the figure
if N>0
    h_title = title( h_axes , ['Visualisation of your ',num2str(N),'-rotor vehicle'] );
else
    h_title = title( h_axes , ['Visualisation of your N-rotor vehicle'] );
end
    h_title.FontSize = 20;

%% PUT ALL THE HANDLES INTO THE RETURN VECTOR
h_notor_trajectory.fig = h_fig;
h_notor_trajectory.axes = h_axes;


h_notor_trajectory.title = h_title;








end % END OF: "function h_notor_vehicle = visualise_nrotor_trajectory( full_state , reference , nrotor_vehicle_layout , thrusts )"