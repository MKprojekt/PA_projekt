% MATLAB controller for Webots
% File:          Mr_controller_v2.m
% Date:
% Description:
% Author:
% Modifications:

% uncomment the next two lines if you want to use
% MATLAB's desktop to interact with the controller:
%desktop;
%keyboard;

TIME_STEP = 64;

speed = 3;

% get and enable devices, e.g.:
%  camera = wb_robot_get_device('camera');
%  wb_camera_enable(camera, TIME_STEP);
%  motor = wb_robot_get_device('motor');

%initialize motors
motor_left = wb_robot_get_device('motor_left');
motor_right = wb_robot_get_device('motor_right');
wb_motor_set_position(motor_left, inf);
wb_motor_set_position(motor_right, inf);
wb_motor_set_velocity(motor_left, 0);
wb_motor_set_velocity(motor_right, 0);

%initialize distance sensors
DS_left = wb_robot_get_device('DS_left');
DS_right = wb_robot_get_device('DS_right');
wb_distance_sensor_enable(DS_left,TIME_STEP);
wb_distance_sensor_enable(DS_right,TIME_STEP);

% main loop:
% perform simulation steps of TIME_STEP milliseconds
% and leave the loop when Webots signals the termination
%
while wb_robot_step(TIME_STEP) ~= -1

  % read the sensors
  DS_left_value = wb_distance_sensor_get_value(DS_left);
  DS_right_value = wb_distance_sensor_get_value(DS_right);
  
  %detect obstacle
  obstacle_left = DS_left_value < 30;
  obstacle_right = DS_right_value < 30;
  
  %set motor speed
  left_motor_speed = speed*0.5;
  right_motor_speed = speed*0.5;
  
  %change motor speed near obstacle
  if obstacle_left
    left_motor_speed = speed*0.5;
    right_motor_speed = -speed*0.5;
  elseif obstacle_right
    left_motor_speed = -speed*0.5;
    right_motor_speed = speed*0.5;
  end
  
  %set motor speed
  wb_motor_set_velocity(motor_left, left_motor_speed);
  wb_motor_set_velocity(motor_right, right_motor_speed);
  
  %  rgb = wb_camera_get_image(camera);

  % Process here sensor data, images, etc.

  % send actuator commands, e.g.:
  %  wb_motor_set_postion(motor, 10.0);

  % if your code plots some graphics, it needs to flushed like this:
  drawnow;

end

% cleanup code goes here: write data to files, etc.
