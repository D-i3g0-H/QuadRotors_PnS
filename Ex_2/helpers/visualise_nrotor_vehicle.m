function h_notor_vehicle = visualise_nrotor_vehicle( nrotor_vehicle_layout )

% The first input argument is the layout of the N-rotor vehicle:
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


%% Get the number of rotors into a local variable
N = size( nrotor_vehicle_layout , 2 );


%% Inform the user that the plotting script is about to run
disp(' ');
disp([' Now plotting your ',num2str(N),'-rotor vehicle design.' ]);



%% Specify the various plotting options
rotor_disc_colour = 0.7 * [1,1,1];
frame_colour = 0.6 * [1,1,1];
motor_colour = 0.4 * [1,1,1];
rotor_boundary_colour = [165,15,21]/255;
rotor_rotation_colour = [222,45,38]/255;

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



%% PLOT THE N-ROTOR VEHICLE


%% Open a new figure and create the axes
% Get the screen size of the machine in use
this_screensize = get( groot, 'Screensize' );

%this_screen_width = this_screensize(2);
this_screen_height = this_screensize(4);

% Open a figure
h_fig = figure;

% Give the figure a name
h_fig.Name = ['Top view of your ',num2str(N),'-rotor vehicle design.' ];

% Set the position of the figure
h_fig.Position = [...
        0 ,...
        this_screen_height/2 ,...
        this_screen_height/2 ,...
        this_screen_height/2  ...
    ];

% Add an axes to the figure
h_axes = axes( h_fig );

% Set the position of the axes
h_axes.Position = [0.1 , 0.1 , 0.85 , 0.85 ];

% Set the axes to be "hold on"
hold( h_axes , 'on' );


%% Plot the frame as connections to the geometrical center

% Compute the geomterical center
x_geometrical_center = mean( nrotor_vehicle_layout(1,:) );
y_geometrical_center = mean( nrotor_vehicle_layout(2,:) );
% Construct a matrix to plot all "frame lines" at once
frame_lines_x = [...
        x_geometrical_center * ones(1,N) ;...
        nrotor_vehicle_layout(1,:) ...
    ];
frame_lines_y = [...
        y_geometrical_center * ones(1,N) ;...
        nrotor_vehicle_layout(2,:) ...
    ];
% Plot all the lines
h_frame_lines = line( frame_lines_x , frame_lines_y );
% Set the properties of the frame lines
set( h_frame_lines , 'LineWidth' , 2.0 );
set( h_frame_lines , 'Color' , frame_colour );
% Plot a "frame circle" at the geometrical center
% Get the redius for this circle
this_radius = 0.1 * min( inter_rotor_distance_nearest_neighbour(:,1) );
% Convert this to a "position" for the rectangle
this_pos = [x_geometrical_center-0.5*this_radius,y_geometrical_center-0.5*this_radius,this_radius,this_radius];
% Plot a circle for the Geometrical Center
h_frame_geometrical_center = rectangle(...
            h_axes ,...
            'Position',this_pos,...
            'Curvature',[1,1],...
            'FaceColor',frame_colour ...
        );


%% Plot a filled circle for the area of each rotor

% and plot also a motor at the center
h_rotor_disc_filled = gobjects(N,1);
h_motor_filled = gobjects(N,1);
for i_rotor = 1:N
    % Get the "x_i" and "y_i" for this rotor
    this_x_i = nrotor_vehicle_layout(1,i_rotor);
    this_y_i = nrotor_vehicle_layout(2,i_rotor);
    % Get the redius of this rotor
    this_radius = 0.5 * inter_rotor_distance_nearest_neighbour(i_rotor,1);
    % Convert this to a "position" for the rectangle
    this_pos = [this_x_i-this_radius,this_y_i-this_radius,2*this_radius,2*this_radius];
    % Plot the rotor disc
    h_rotor_disc_filled(i_rotor,1) = rectangle(...
            h_axes ,...
            'Position',this_pos,...
            'Curvature',[1,1],...
            'FaceColor',rotor_disc_colour ...
        );
    % Get the radius of this rotor
    this_radius = 0.1 * inter_rotor_distance_nearest_neighbour(i_rotor,1);
    % Convert this to a "position" for the rectangle
    this_pos = [this_x_i-this_radius,this_y_i-this_radius,2*this_radius,2*this_radius];
    % Plot the rotor disc
    h_motor_filled(i_rotor,1) = rectangle(...
            h_axes ,...
            'Position',this_pos,...
            'Curvature',[1,1],...
            'FaceColor',motor_colour ...
        );
end



%% Plot a circle for the boundary of each rotor
h_rotor_boundary = viscircles( h_axes , nrotor_vehicle_layout(1:2,:)' , 0.5.*inter_rotor_distance_nearest_neighbour );
% Set the properties of the circles
set( h_rotor_boundary.Children , 'Color' , rotor_boundary_colour );
set( h_rotor_boundary.Children , 'LineWidth' , 2.0 );



%% Plot the center of gravity
h_CoG = gobjects(5,1);
% Specify the radius of the CoG symbol
CoG_radius = 0.1 * min( inter_rotor_distance_nearest_neighbour(:,1) );
% Speficy the face colour of each quadrant
CoG_face_colour = [ 1,1,1 ; 0,0,0 ; 1,1,1 ; 0,0,0 ];
% Iterate over the 4 quadrants
for i_quadrant = 1:4
    % Compute points that define the boundary of the quadrant
    this_quadrant_x = [ 0 , CoG_radius * cos( (i_quadrant-1)*pi/2 : pi/90 : i_quadrant*pi/2 ) , 0 ];
    this_quadrant_y = [ 0 , CoG_radius * sin( (i_quadrant-1)*pi/2 : pi/90 : i_quadrant*pi/2 ) , 0 ];
    % Plot the area
    h_CoG(i_quadrant,1) = patch( h_axes , this_quadrant_x , this_quadrant_y , CoG_face_colour(i_quadrant,:) );
end
% Set all the areas to have no line
set( h_CoG(1:4,1) , 'LineStyle' , 'none' );
% Draw a circlearound the outside of the Center of Gravity
h_CoG(5,1) = viscircles( h_axes , [0,0] , CoG_radius );
set( h_CoG(5,1).Children , 'Color' , [0,0,0] );
set( h_CoG(5,1).Children , 'LineWidth' , 1.0 );


%% Plot the direction of rotation for each rotor
% and plot also a motor at the center
h_rotor_direction_line = gobjects(N,1);
h_rotor_direction_arrow_head = gobjects(N,1);
for i_rotor = 1:N
    % Get the "x_i" and "y_i" for this rotor
    this_x_i = nrotor_vehicle_layout(1,i_rotor);
    this_y_i = nrotor_vehicle_layout(2,i_rotor);
    % Get the redius of this rotor
    this_radius = 0.5 * inter_rotor_distance_nearest_neighbour(i_rotor,1);
    % Get the "c_i"
    this_c_i = nrotor_vehicle_layout(3,i_rotor);
    % Plot different depending on the direction
    if this_c_i < 0
        % This rotor is spinning anti-clockwise looking from above
        % Compute points that for the rotation
        this_direction_x = this_x_i + ( this_radius * cos( pi/2 - pi/3 : pi/90 : pi/2-pi/16 ) );
        this_direction_y = this_y_i + ( this_radius * sin( pi/2 - pi/3 : pi/90 : pi/2-pi/16 ) );
        % Plot the direction arrow
        h_rotor_direction_line(i_rotor,1) = plot( this_direction_x , this_direction_y );
        % Set the properties of the line
        h_rotor_direction_line(i_rotor,1).Color = rotor_rotation_colour;
        h_rotor_direction_line(i_rotor,1).LineWidth = 5.0;
        % Prepare the coordinates for the arrow head
        this_arrow_head_x = this_x_i + [ 0           , [0.85,1.15].*(this_radius*cos(pi/2-pi/8)) ];
        this_arrow_head_y = this_y_i + [ this_radius , [0.85,1.15].*(this_radius*sin(pi/2-pi/8)) ];
        % Plot the arrow head as a patch
        h_rotor_direction_arrow_head(i_rotor,1) = patch( h_axes , this_arrow_head_x , this_arrow_head_y , rotor_rotation_colour );
                
        
    elseif this_c_i > 0
        % This rotor is spinning clockwise looking from above
        % Compute points that for the rotation
        this_direction_x = this_x_i + ( this_radius * cos( pi/2 + pi/3 : -pi/90 : pi/2+pi/16 ) );
        this_direction_y = this_y_i + ( this_radius * sin( pi/2 + pi/3 : -pi/90 : pi/2+pi/16 ) );
        % Plot the direction arrow
        h_rotor_direction_line(i_rotor,1) = plot( this_direction_x , this_direction_y );
        % Set the properties of the line
        h_rotor_direction_line(i_rotor,1).Color = rotor_rotation_colour;
        h_rotor_direction_line(i_rotor,1).LineWidth = 5.0;
        % Prepare the coordinates for the arrow head
        this_arrow_head_x = this_x_i + [ 0           , [0.85,1.15].*(this_radius*cos(pi/2+pi/8)) ];
        this_arrow_head_y = this_y_i + [ this_radius , [0.85,1.15].*(this_radius*sin(pi/2+pi/8)) ];
        % Plot the arrow head as a patch
        h_rotor_direction_arrow_head(i_rotor,1) = patch( h_axes , this_arrow_head_x , this_arrow_head_y , rotor_rotation_colour );
        
    else
        % Let the user know that this rotor has a zero lift-to-drag ratio
        disp(['[INFO] >> Rotor number ',num2str(i_rotor),' has a ZERO lift-to-drag ratio.' ]);
    end
    
end

% Set all the border line colour of the arrow heads
set( h_rotor_direction_arrow_head , 'EdgeColor' , rotor_boundary_colour );


%% SET THE PROPERTIES OF THE AXES TO MAKE THINGS LOOK NICE

% Make the axes equal
axis( h_axes , 'equal' );

% Add grid lines, and set their properties
grid( h_axes , 'on' );
h_axes.GridLineStyle = ':';
h_axes.GridColor = 0.50 * [1,1,1];
h_axes.GridAlpha = 0.30;

% Set the tick label properties
h_axes.TickDir = 'out';
h_axes.FontSize = 14;


% Add a title to the figure
h_title = title( h_axes , ['Visualisation of your ',num2str(N),'-rotor vehicle'] );
h_title.FontSize = 20;

%% PUT ALL THE HANDLES INTO THE RETURN VECTOR
h_notor_vehicle.fig = h_fig;
h_notor_vehicle.axes = h_axes;
h_notor_vehicle.frame_lines = h_frame_lines;
h_notor_vehicle.frame_geometrical_center = h_frame_geometrical_center;
h_notor_vehicle.rotor_disc_filled = h_rotor_disc_filled;
h_notor_vehicle.motor_filled = h_motor_filled;
h_notor_vehicle.rotor_boundary = h_rotor_boundary;
h_notor_vehicle.CoG = h_CoG;
h_notor_vehicle.rotor_direction_line = h_rotor_direction_line;
h_notor_vehicle.rotor_direction_arrow_head = h_rotor_direction_arrow_head;

end % END OF: "function visualise_nrotor_vehicle( nrotor_vehicle_layout )"