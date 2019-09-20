function [vp, im, lane_position_x, lane_position_y] = calculate_vp(im_rgb, im_disparity)

VP_SOURCE = 1;
s = strcat('vpts_data_', int2str(VP_SOURCE), '.mat');

if VP_SOURCE == 1
    
    load(s);   
    figure, imshow(im); title('Original image'); hold on;

    for j=1:3
        visualisation_position=[];
        u=lane_positions(j);

        for i=1:length(index)
            vpy_tmp=vpy(i);
            vpx_tmp=vpx(i);
            v=index(i);
            visualisation_position=[visualisation_position,[u,v]'];
            u=u+(vpx_tmp-u)/(v-vpy_tmp);
        end
        plot(visualisation_position(1,:),visualisation_position(2,:),'Color','r','LineWidth',3.5);
        plot(vpx(:),vpy(:),'Color','b','LineWidth',3.5);
    end
    
    vp = [vpx; vpy];
    lane_position_x = lane_positions;
    lane_position_y = index;
    
else
    load(s);
    figure; imshow(im); hold on;

    mouse = impoint(gca);
    p1 = getPosition(mouse); p1 = [p1, 1];
    mouse = impoint(gca); 
    q1 = getPosition(mouse); q1 = [q1, 1];
    mouse = impoint(gca);
    p2 = getPosition(mouse); p2 = [p2, 1];
    mouse = impoint(gca);
    q2 = getPosition(mouse); q2 = [q2, 1];
    x = [p1(1), q1(1)];
    y = [p1(2), q1(2)];
    plot(x, y, 'r-', 'LineWidth', 3); hold on;
    x = [p2(1), q2(1)];
    y = [p2(2), q2(2)];
    plot(x, y, 'r-', 'LineWidth', 3); hold on;

    v = cross(cross(p1, q1), cross(p2, q2));
    v = v./v(3);

    x = [p1(1), q1(1) v(1)];
    y = [p1(2), q1(2) v(2)];
    plot(x, y, 'r-', 'LineWidth', 3); hold on;
    x = [p2(1), q2(1) v(1)];
    y = [p2(2), q2(2) v(2)];
    plot(x, y, 'r-', 'LineWidth', 3); hold on;

    save('vp.mat', 'p1', 'q1', 'p2', 'q2', 'v')  
    v = [v(1); v(2)];
end





