%% FEM 2D truss solver (linear elements)
function [u,f] = truss2D(nodes, elements, load1, load2, BCs)

%% Transfering of input data into global displacement and force vectors
    % nodal displacements = [ u1: v1; u; v2; ...]
    u = zeros(2*size(nodes,1),1);
    for it = 1:size(nodes,1)
        u(2*it-1)=BCs(it,2);
        u(2*it)=BCs(it,3);
    end

    % discrete forces at nodes = [ Fx1: Fy1; Fx2; Fy2; ...]
    % forces not given in load1 are unknown, hence NaN as a placeholder
    r = zeros(2*size(nodes,1),1);
    for it = 1:size(load1,1)
        node = load1(it,1);
        r(2*node-1,1) = load1(it,2);
        r(2*node,1) = load1(it,3);
    end

    % distributed forces at elements = [ q1: q2; ...]
    q = zeros(size(elements,1),1);
    for it = 1:size(elements,1)
        q(it)=load2(it,2);    
    end

%% Assembly of global stiffness and global force matrices
    
    K = zeros(2*size(nodes,1));
    % assembly of contributions from each element stiffness matrix into matrix K
    
    for it=1:size(elements,1);
        % nodes of the element
        node1 = elements(it,2);
        node2 = elements(it,3);
        % original structure node coordinates
        x1 = nodes(node1,2);
        y1 = nodes(node1,3);
        x2 = nodes(node2,2);
        y2 = nodes(node2,3);
        L = sqrt((x2-x1).^2+(y2-y1).^2);    % length of element
        ls = (x2-x1)/L;    % cosine
        ms = (y2-y1)/L;    % sine
        % the above can be also appended to the elements matrix for later
                
        % local stiffnes matrix
        % T = [ls ms 0 0; 0 0 ls ms];
        % kl = k * [1 -1; -1 1];
        % Kl = T' * kl * T;        
        k = elements(it,4)*elements(it,5)/L;    % element spring constant
        Kl = [ls ms 0 0; 0 0 ls ms]'*k*[1 -1; -1 1]*[ls ms 0 0; 0 0 ls ms];

        % indices of matrix entries to be updated (give a 4x4 submatrix of K)
        itup = [2*node1-1 2*node1 2*node2-1 2*node2];
        % matrix K is updated only along values of indices itup,itup (cross combined!)
        K(itup,itup) = K(itup,itup) + Kl;

        % adding distributed loads rq into global force vector
        % r = rp + rl;
        % rq_global = T'*(qL)/2*(1;1) = T'*rq_local;
        r(itup,1) = r(itup,1) + [ls ms 0 0; 0 0 ls ms]'*0.5*q(it)*L*[1;1];
    end
    % matrix K fully assembled
    % matrix r fully assembled

    % Taking BCs into account
    % if nodal degree of freedom is NOT unknown (NOT a NaN), then:
    % - in matrix K put 1 on the diagonal corresponding to that NDoF
    % - set all other entries in the row equall to zero
    % - set global force vector equal to the known displacement
    for it = 1:2*size(nodes,1)
        if( ~isnan(u(it)) )
            K(it,:)=0;
            K(it,it)=1;
            r(it)=u(it);       
        end
    end
    % matrix d fully assembled (in modified form)

    % Solving the global equation
    % K * d = r (Hooke´s law basically)
    u = K\r;
    % somewhat an anticlimax :)

%% Post-processing - internal forces

    f = zeros(size(elements,1),1);  % not really necessary to preallocate
    for it = 1:size(elements,1)
        % nodes of the element
        node1 = elements(it,2);
        node2 = elements(it,3);
        % original structure node coordinates
        x1 = nodes(node1,2);
        y1 = nodes(node1,3);
        x2 = nodes(node2,2);
        y2 = nodes(node2,3);
        L = sqrt((x2-x1).^2+(y2-y1).^2);    % length of element
        ls = (x2-x1)/L;    % cosine
        ms = (y2-y1)/L;    % sine
        k = elements(it,4)*elements(it,5)/L;    % element spring constant
        
        % f = EA/L*[-ls -ms ls ms]*[u1 v1 u2 v2]';        
        % Note: + means tension, - means compression
        f(it) = k.*[-ls -ms ls ms]*u([2*node1-1,2*node1,2*node2-1,2*node2]);
    end    
end