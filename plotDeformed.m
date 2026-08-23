%% Plot of the deformed structure
function plotDeformed(nodes,elements,displacements,plot_scale)
    
    figure
        title('Deformed structure')
        xlabel('x(mm)');
        ylabel('y(mm)');
        axis equal;
        
    % Plot of deformed structure (nodes, elements)
    for it = 1:size(elements,1)
        node1 = elements(it,2);
        node2 = elements(it,3);
        % undeformed structure node coordinates
        x1 = nodes(node1,2);
        y1 = nodes(node1,3);
        x2 = nodes(node2,2);
        y2 = nodes(node2,3);
        % plots lines between node coordinates
        line([x1,x2],[y1,y2]);
        hold on;
        
        % (scaled) deformed structure node coordinates
        x1 = x1 + plot_scale * displacements(2*node1-1);
        y1 = y1 + plot_scale * displacements(2*node1);
        x2 = x2 + plot_scale * displacements(2*node2-1);
        y2 = y2 + plot_scale * displacements(2*node2);
        % deformed structure lines
        line([x1,x2],[y1,y2], 'Color', 'red');
        % plots node numbers at displaced nodal positions
        text(x1,y1,num2str(node1)); % node1
        text(x2,y2,num2str(node2)); % node2
        % plots elements numbers at displaced midpoints
        text(0.5*(x1+x2),0.5*(y1+y2),num2str(it),'Color','black');
    end
   
end