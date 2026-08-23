%% Finds the plot_scale which gives max displacement = 0.1 * max element length
function plot_scale = plotScale(nodes, elements, displacements)

    maxL = 0; % max length, used to scale the force vectors
    
    for it = 1:size(elements,1)
        node1 = elements(it,2);
        node2 = elements(it,3);
        x1 = nodes(node1,2);
        y1 = nodes(node1,3);
        x2 = nodes(node2,2);
        y2 = nodes(node2,3);        
        % saves max length of the element
        L = sqrt((x2-x1).^2+(y2-y1).^2);
        if (maxL<L)
            maxL = L;
        end
    end
    
    % maximum displacement will be 10% of the maximum length of the element
    % u_scaled = 0.1 * length_max;
    % u_scaled = plot_scale * displacement_max;
    % plot_scale = 0.1 * maxL/maxD;
    plot_scale = 0.1*maxL/max(abs(displacements));
end