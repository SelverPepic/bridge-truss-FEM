%%% Simulating shape of a bridge
%%% simple euler method with artificial damping (leading to static setup in finite time)

% line([x1,x2],[y1,y2], 'Color', 'red');
% text(x1,y1,num2str(node1));

%% Parameters
clear all;
% physical parameters
L = 10; % bridge length
M = 10000; % bridge mass
k = 2000; % stiffness, K = EA/l;
g = 10;
b = 1000; % artifical damping for Eulerian simulation

% simulation parameters
n_seg = 21; % number of bridge segments
n_mass = n_seg + 1; % number of discrete masses
x = 0:L/n_seg:L; % x-pos of mass points
y = zeros(size(x)); % y-pos of mass points

m_seg = M/n_seg; % defining mass of a mass point
m(1) = m_seg/2;
m(2:length(x)-1) = m_seg;
m(length(x)) = m_seg/2;

tmax = 1000;
dt = 0.1;
n_iter = tmax/dt;

%% plot bridge and elements
figure
    title('Bridge (un)deformed')
    xlabel('x(m)');
    ylabel('y(m)');
    axis([0 L -L/2 L/2]);
        
    for i = 1:length(x)-1
        hold on;
        line([x(i),x(i+1)],[y(i),y(i+1)], 'Color', 'blue');
        plot(x(i),y(i),'O', 'Color', 'blue');        
    end
    plot(x(i+1),y(i+1),'O', 'Color', 'blue'); 
    
%% Euler update toward static solution
v = zeros(n_iter,length(x));
a = zeros(n_iter,length(x));
y = zeros(n_iter,length(x));

for iter = 1:1:n_iter
    
    for i = 2:length(x)-1 % only inner points move
        l1 = sqrt( (x(i)-x(i-1))^2 + (y(iter,i)-y(iter,i-1))^2 );
        dl1 = l1 - L/n_seg;
        l2 = sqrt( (x(i+1)-x(i))^2 + (y(iter,i+1)-y(iter,i))^2 );
        dl2 = l2 - L/n_seg;
        
        f_spring = - k*dl1*(y(iter,i)-y(iter,i-1))/l1 + k*dl2*(y(iter,i+1)-y(iter,i))/l2; 
        a(iter,i) = 1/m(i) * (f_spring - b*v(iter,i) - g);
    end
    v(iter+1,:) = v(iter,:) + a(iter,:)*dt;
    y(iter+1,:) = y(iter,:) + 0.5*(v(iter,:)+v(iter+1,:)) * dt;
    
end

%% plot deformed structure
    for i = 1:length(x)-1
        hold on;
        line([x(i),x(i+1)],[y(iter,i),y(iter,i+1)], 'Color', 'red');
        plot(x(i),y(iter,i),'O', 'Color', 'blue');        
    end
    plot(x(i+1),y(iter,i+1),'O', 'Color', 'blue');
    text(5,2,num2str(min(y(iter,:))));