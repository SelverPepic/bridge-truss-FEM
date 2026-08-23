%% Plot of the deformed structure and internal forces
function plotForces(nodes,elements,displacements,forcesInternal,plot_scale)

    figure
        title('Internal forces (kN)')
        xlabel('x(mm)');
        ylabel('y(mm)');
        axis equal;

    for it = 1:size(elements,1)
        node1 = elements(it,2);
        node2 = elements(it,3);
        % (scaled) deformed structure node coordinates
        x1 = nodes(node1,2) + plot_scale * displacements(2*node1-1);
        y1 = nodes(node1,3) + plot_scale * displacements(2*node1);
        x2 = nodes(node2,2) + plot_scale * displacements(2*node2-1);
        y2 = nodes(node2,3) + plot_scale * displacements(2*node2);
        % deformed structure lines
        line([x1,x2],[y1,y2], 'Color', 'red');
        hold on;
        % plots node numbers at displaced nodal positions
        text(x1,y1,num2str(node1)); % node1
        text(x2,y2,num2str(node2)); % node2
        % plots values of internal forces (in kN) at displaced midpoints
        text(0.5*(x1+x2),0.5*(y1+y2),num2str(0.001*forcesInternal(it)),'Color','black');
    end
end