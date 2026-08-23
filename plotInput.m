%% Plot of the initial shape and input values
function plotInput(nodes, elements, load1, load2, BCs)
    
    figure
        title('Inputs')
        xlabel('x(mm)');
        ylabel('y(mm)');
        axis equal;
    
    maxL = 0; % max length, used to scale the force vectors
    
    % Plot of elements (line and number)
    for it = 1:size(elements,1)
        node1 = elements(it,2);
        node2 = elements(it,3);
        % undeformed structure node coordinates
        x1 = nodes(node1,2);
        y1 = nodes(node1,3);
        x2 = nodes(node2,2);
        y2 = nodes(node2,3);
        
        % saves max length of the element
        L = sqrt((x2-x1).^2+(y2-y1).^2);
        if (maxL<L)
            maxL = L;
        end
            
        % plots lines between node coordinates
        line([x1,x2],[y1,y2]);
        % plots the element number at the midpoint
        text(0.5*(x1+x2),0.5*(y1+y2),num2str(it),'Color','red');
        % plots the distributed loads value near the midpoint
        %text(0.55*(x1+x2),0.55*(y1+y2),num2str(load2(it,2)),'Color','blue');
        hold on;
    end

    % Plots the node number at the node position
    % plots node number at positions x,y = nodes(2),nodes(3) for each node
    text(nodes(:,2),nodes(:,3),num2str(nodes(:,1)));
    
    % Plots the force vectors (discrete ones)
    % scale = 0.2 * max_element_length / max_absolute_force;
    % max force vector will be 20% of max element length
    maxF = max(abs(load1(:,2))+abs(load1(:,3)));
    scale = 0.2*maxL/maxF;
    %disp(scale);
    %disp(maxL);
    %disp(maxF);
    % not all nodal forces are definied, so the "loop" is over the
    % 1st index of load1, not the nodes!
    it = 1:size(load1,1);
    quiver( nodes(load1(it,1),2) , nodes(load1(it,1),3) , ...
            scale*load1(it,2),     scale*load1(it,3), ...
            'AutoScale','off','Color','green'); 
end