%%% ETH Zurich, FEM in BME course Spring 2017, Assignment 1
%%% FEM solution of 2D truss structural problem
%%% linear finite elements
%%% Selver Pepic
%%% 29.03.2017. version 3

%%% To plot input data, deformed structure and the forces,
%%% just hit "run" and that´s it.

%%% Few notices about the code in general:
%%% 1. Extra variables are used (e.g. x1,x2,y1,y2) in order to
%%% make the code more readable at the expense of extra memory used.
%%% 2. Alternative or more readable ways of writing certain parts of the code
%%% are also provided in comments.
%%% 3. The code does not fully use MATLAB functionalities to make the code
%%% shorter, and this is partly done on purpose to keep code simple to read

%%% Any comments on programming style and code organizaton are of course
%%% welcome, happy reading and thanks for giving an interesting assignment!

%% Input data (nodes, elements, load1, load2, BCs)
% reads data from file in the current folder (
truss_example_assignment1_task2;
%truss_example_assignment1_task2;

% input data explained
% nodes = matrix containing in each row the node number, x- and y- coord (in mm)
% elements = matrix containing in each row the element number
%       1st and 2nd node of the element, Young modulus (in MPa), and
%       cross-section in mm2 (displacements are in mm so forces will be in N in the end)
% load1 (concentrated forces) = matrix containing in each row
%       the node at which the force is acting, and x- and y- projection of the force
%       NOTE: this matrix will not necessarily contain forces in each node!
% load2 (distributed forces) = matrix containing in each row
%       the element in which the force is acting and its value
%       + means tension, - means compression
% BCs = matrix of (un)known displacements containing in each row
%       the node number, and x and y displacement of the node
%       NaN used as placeholder if displacement is uknown (i.e. to be determined)

%% Plot of the undeformed structure and loads acting on it
plotInput(nodes, elements, load1, load2, BCs);

%% FEM solver for the nodal displacements and internal forces in elements
% function (nodes, elements, load1, load2, BCs)
[d,f] = truss2D(nodes, elements, load1, load2, BCs);
% plot_scale was put into separate function below since it is not needed
% for FEM calculations (I preferred not to multiply displacements vector immediately

%% Plot of original and deformed structure
% plotScale function finds the plot_scale which gives
% the max displacement = 0.1 * max length of element
plot_scale = plotScale(nodes,elements,d);
% plot_scale = 3000; % for manual input if needed
plotDeformed(nodes, elements, d, plot_scale);

%% Plot of deformed structure and internal forces
% + means tension, - means compression
plotForces(nodes, elements, d, f, plot_scale);

% THE END