%% init.m
% Project-wide Parameters

% Robot Geometry
robot.mass_robot = 10;       % kg
robot.mass_payload = 10;     % kg
robot.height = 5;            % m
robot.diameter = 0.5;        % m
robot.wheel_radius = 0.05;   % m
robot.gear_ratio = 10;

v = 22; % ms-1 (Assumed planar velocity of robot)
t = linspace(0, 33/v, 1000); % s (timescale of 0 to 33/v s with 1000 even-spaced divisions
x = interp1([0 15 25 33]/v, [0 -15 -15 -7], t); % m (linearly interpolated x coordinates of the robot's full path)
y = interp1([0 15 25 33]/v, [0 0 10 10], t); % m (linearly interpolated y coordinates of the robot's full path)

%Signals for x- and y-coordinates over time, to be fed into floorHeightFcn
%to obtain z-coordinates for every point on the robot's path
x_sig = timeseries(x, t);
y_sig = timeseries(y, t);

% Motor Parameters (initial guesses or from datasheet)
motor.R = 1.2;       % Ohm
motor.L = 0.5e-3;    % H
motor.Kt = 0.1;      % Nm/A
motor.Ke = 0.1;      % V/(rad/s)

% Suspension parameters (tunable in Task 5)
% NOTE THAT THIS K AND C FOR EACH WHEEL. IF WE ASSUME THE WHEELS
% ARE IN THE SAME LOCATION ON THE ROBOT THEN WE TREAT THE 1 WHEEL
% MODEL AS A 2 WHEEL MODEL BY ASSINGING K AND C THE PARALLEL
% EQUIVILANT K AND C FROM 2 WHEELS.
susp.k = 1500;   % N/m
susp.c = 100;    % Ns/m

world.gravity = 9.8; %m/s^2

% Load into workspace
assignin('base', 'robot', robot);
assignin('base', 'motor', motor);
assignin('base', 'susp', susp);

% https://ethz.ch/content/dam/ethz/special-interest/mavt/dynamic-systems-n-control/idsc-dam/Lectures/amod/AMOD_2020/20201019-02%20-%20ETHZ%20-%20Modeling.pdf