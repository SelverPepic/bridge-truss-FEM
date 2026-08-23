%truss_example_assignment1_task1.m
nodes = [1 0 0;
    2 6000*cos(pi/3) 6000*sin(pi/3);
    3 6000 0];
elements = [1 1 2 200*10^3 2120;
    2 2 3 200*10^3 2120;
    3 3 1 200*10^3 2120];
load1 = [1 0 10000;
    3 -10000 0];
load2 = [1 0; 2 0; 3 0];
BCs = [1 0 NaN;2 0 0; 3 NaN 0];
%BCs = [1 0.2 NaN;2 0 0; 3 NaN 0];
