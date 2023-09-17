clear 
close all;
clc

% Requires included a_mat.m, rot.m, and trans.m functions to run properly.
% Coded in MATLAB R2023a
%{ 
Edward Enriquez Robotics MATLAB Project

This program defines 5 paths which join to make 1 looping path. The joint
variables needed for the given manipulator to traverse the path are
calculated using the inverse kinematic equations. The joint variables 
are then verified using the foward kinematic transformation and A matrices.
The actual path and orientation calculated is plotted and animated over the 
desired path.

The positioning of the paths was calculated using trigonometric analysis 
and the orientations were calculated using rotation matrices. To help debug
the code and check these positions/orientations, the T matrix of the 
manipulator was referenced.

Animation is slower in MATLAB script than in saved video as plotting all 
the vectors/points and duplicating them in real time is time consuming.
%}


%% Fixed Lengths                                                        
l4=.1;                                                                      
l5=.1;
l7=.1;

%% Spiral (Path1)
t=linspace(0,1,75);

h=.1;                                                                       % sprial height

nx_1=1+t*0; ox_1=0+t*0; ax_1=0+t*0;                                         % parametric equations for spiral orientation
ny_1=0+t*0; oy_1=1+t*0; ay_1=0+t*0;
nz_1=0+t*0; oz_1=0+t*0; az_1=1+t*0;

x_1=l5*cos(4*pi*t);                                                         % parametric equations for spiral position
y_1=l5*sin(4*pi*t);
z_1=h*t+l4+l7;    

%% Transition 1 (Path2)
t=linspace(0,1,20);

nx_2=cos((pi/4)*t);     ox_2=0+t*0;     ax_2=sin((pi/4)*t);                 % parametric equations for transition 1 orientation
ny_2=0+t*0;             oy_2=1+t*0;     ay_2=0+t*0;
nz_2=-sin((pi/4)*t);    oz_2=0+t*0;     az_2=cos((pi/4)*t);

x_2=l5*cos((pi/4)*t)+(h.*(1-t)+l7).*sin((pi/4)*t);                          % parametric equations for transition 1 position
y_2=t*0;
z_2=(h.*(1-t)+l7).*cos((pi/4)*t)+l4-l5*sin((pi/4)*t);


%% Flower (Path3)
t=linspace(0,1,100);

s2=sin(pi/4);                                                               % variable shorthands
c2=cos(pi/4);

p_l=.1;                                                                     % pedal length

nx_3=c2*cos(2*pi*t);     ox_3=-sin(2*pi*t);     ax_3=s2*cos(2*pi*t);        % parametric equations for flower orientation
ny_3=c2*sin(2*pi*t);     oy_3=cos(2*pi*t);      ay_3=s2*sin(2*pi*t);     
nz_3=-s2+t*0;            oz_3=0+t*0;            az_3=c2+t*0;          

x_3=l5*cos(2*pi*t).*c2 + cos(2*pi*t).*s2.*(abs(p_l*sin(6*pi*t)) + l7);      % parametric equations for flower position
y_3=l5*c2.*sin(2*pi*t) + sin(2*pi*t).*s2.*(abs(p_l*sin(6*pi*t)) + l7);
z_3=l4 + c2.*(abs(p_l*sin(6*pi*t)) + l7) - l5.*s2;

%% Transition 2 (Path4)
t=linspace(0,1,20);

nx_4=cos((pi/4)*(1-t));     ox_4=0+t*0;     ax_4=sin((pi/4)*(1-t));         % parametric equations for transition 2 orientation
ny_4=0+t*0;                 oy_4=1+t*0;     ay_4=0+t*0;
nz_4=-sin((pi/4)*(1-t));    oz_4=0+t*0;     az_4=cos((pi/4)*(1-t));

x_4=l5*cos((pi/4)*(1-t))+l7.*sin((pi/4)*(1-t));                             % parametric equations for transition 2 position
y_4=t*0;
z_4=l7.*cos((pi/4)*(1-t))+l4-l5*sin((pi/4)*(1-t));

%% Spin (Path5)
t=linspace(0,1,20);

nx_5=cos(2*pi*t);           ox_5=-sin(2*pi*t);      ax_5=0*t;               % parametric equations for spin orientation (rotz)
ny_5=sin(2*pi*t);           oy_5=cos(2*pi*t);       ay_5=0*t;
nz_5=0*t;                   oz_5=0*t;               az_5=1+0*t;

x_5=l5+0*t;                                                                 % parametric equations for spin position (constants)
y_5=0*t;
z_5=(l4+l7)+0*t;

%% Concatanations
                                                                            %concatanations of all 5 path orientations and positions

nx=cat(2,nx_1,nx_2,nx_3,nx_4,nx_5);    ox=cat(2,ox_1,ox_2,ox_3,ox_4,ox_5);     ax=cat(2,ax_1,ax_2,ax_3,ax_4,ax_5);
ny=cat(2,ny_1,ny_2,ny_3,ny_4,ny_5);    oy=cat(2,oy_1,oy_2,oy_3,oy_4,oy_5);     ay=cat(2,ay_1,ay_2,ay_3,ay_4,ay_5);
nz=cat(2,nz_1,nz_2,nz_3,nz_4,nz_5);    oz=cat(2,oz_1,oz_2,oz_3,oz_4,oz_5);     az=cat(2,az_1,az_2,az_3,az_4,az_5);

x=cat(2,x_1,x_2,x_3,x_4,x_5);
y=cat(2,y_1,y_2,y_3,y_4,y_5);
z=cat(2,z_1,z_2,z_3,z_4,z_5);


%% Optional Simple Spiral
% t=linspace(0,1,50);
%                                                                           % Uncommenting this code overwrites the complex path and plots
% nx=1+0*t;   ox=0*t;     ax=0*t;                                           % a simple spiral. This was used to test my algorithm and to test 
% ny=0*t;     oy=1+0*t;   ay=0*t;                                           % on a path which could be defined without too much trigonmetric analysis
% nz=0*t;     oz=0*t;     az=1+0*t;                                         % which mean it looked less like the actual T matrix formulas
% 
% r=l5;
% h=.1;
% x=r*cos(4*pi*t);
% y=r*sin(4*pi*t);
% z=l4+l7+t*l5;

%% Inverse Kinematics
path_size=size(x,2);                                                        % Get number of points in path

                                                                            % Calculation of joint variables theta1, theta2, theta3 and l6
                                                                            % using equations for lecture
theta1=atan2(y,x);
theta2=atan2(-(cos(theta1).*ax+sin(theta1).*ay),az);                        % No initalization needed as calculated in arrays
theta3=atan2(sin(theta1).*nx-cos(theta1).*ny,sin(theta1).*ox-cos(theta1).*oy);
l6=((z-l4-l5.*sin(theta2))./cos(theta2))-l7;


%% Foward Kiknematics

syms t1 l_3 l_4 t2 l_5 t3 l_6 l_7                                           % Intialize Symbols

dh_table=[t1 l_4 0 pi/2;  t2 0 l_5 -pi/2; pi+t3 l_6+l_7 0 0];               % DH Table from lecture
a_mats=a_mat(dh_table);                                                     % Get A matrices 1-3

T=a_mats(:,:,1)*a_mats(:,:,2)*a_mats(:,:,3);                                % Find transformation matrix of end effector (third joint)
T2=a_mats(:,:,1)*a_mats(:,:,2);                                             % Find transformation matrix for end of second joint
                                                                            % End of first joint is stationary

                                                                            
T=subs(T,[l_4,l_5,l_7],[l4 l5 l7]);                                         % Substitute fixed lengths into T matrix
T2=subs(T2,[l_4,l_5,l_7],[l4 l5 l7]);                                       % Substitute fixed lengths into T2 matrix


                                                                            % Array to store values to make for better animation
x_act=zeros([1,path_size]);                                                 % Initialze arrays to store all positions and orientations of hand throughout path
y_act=zeros([1,path_size]);
z_act=zeros([1,path_size]);

nx_act=zeros([1,path_size]);
ny_act=zeros([1,path_size]);
nz_act=zeros([1,path_size]);
ox_act=zeros([1,path_size]);
oy_act=zeros([1,path_size]);
oz_act=zeros([1,path_size]);
ax_act=zeros([1,path_size]);
ay_act=zeros([1,path_size]);
az_act=zeros([1,path_size]);

x_j2=zeros([1,path_size]);                                                  % Initialze arrays to store all positions of second joint throughout path
y_j2=zeros([1,path_size]);
z_j2=zeros([1,path_size]);

C=zeros([path_size,3]);                                                     % Intialize array to store position of non-extended third joint

f=waitbar(0,'Loading Animation...');                                        % Initialize waitbar

for n=1:path_size                                                           % Loop through path points
    waitbar(n/path_size,f,'Loading Animation...');                          % Update waitbar


                                                                            % Substitute joint variables into T for specific path point

    cur_T=subs(T(1:3,:),[t1 t2 t3 l_6],[theta1(n) theta2(n) theta3(n) l6(n)]);

    nx_act(n)=cur_T(1,1);    ox_act(n)=cur_T(1,2);    ax_act(n)=cur_T(1,3); % Store hand orientation at specific path point
    ny_act(n)=cur_T(2,1);    oy_act(n)=cur_T(2,2);    ay_act(n)=cur_T(2,3);
    nz_act(n)=cur_T(3,1);    oz_act(n)=cur_T(3,2);    az_act(n)=cur_T(3,3);

    x_act(n)=cur_T(1,4);                                                    % Store hand position at specific path point
    y_act(n)=cur_T(2,4);
    z_act(n)=cur_T(3,4);

                                                                            % Substitute joint variables into T2 for specific path point

    cur_j2=subs(T2(1:3,4),[t1 t2 t3 l_6],[theta1(n) theta2(n) theta3(n) l6(n)]);
    
    x_j2(n)=cur_j2(1,1);                                                    % Store second joint position at specific path point
    y_j2(n)=cur_j2(2,1);
    z_j2(n)=cur_j2(3,1);

    B=[x_act(n),y_act(n),z_act(n)];                                         % Calculation of non-extended third joint postion
    A=[x_j2(n),y_j2(n),z_j2(n)];
    D=B-A;
    U=D/norm(D);
    C(n,:) = B - l7 * U;                                                    % Store non-extended third joint position for specific path point
   
end
close(f)
%% Animation

animation = VideoWriter('animationvid_good');                                    % Code to initialize animation video writing
animation.FrameRate = 10;
open(animation)

f1=figure(1);                                                               % Open figure fullscreen
set(gcf, 'Position', get(0, 'Screensize'));
%subplot(1,2,1);
for n=1:path_size
    ax1=subplot(1,2,1);
    title('Isometric View')
    hold on
    grid on 
    p_d=plot3(x,y,z,'Color','#0072BD');                                     % Plot desired path
    p_a=plot3(x_act(1:n),y_act(1:n),z_act(1:n),'Color','#A2142F');          % Plot actual path up to current point

                                                                            % Plot hand orientation vectors
    orix=quiver3(x_act(n),y_act(n),z_act(n),nx_act(n),ny_act(n),nz_act(n),.1,'Color','#EDB120');
    oriy=quiver3(x_act(n),y_act(n),z_act(n),ox_act(n),oy_act(n),oz_act(n),.1,'Color','#7E2F8E');
    oriz=quiver3(x_act(n),y_act(n),z_act(n),ax_act(n),ay_act(n),az_act(n),.1,'Color','#77AC30');

                                                                            % Plot robot
    robot=plot3([[0,0,C(n,1)]; [0,x_j2(n) x_act(n)]], [[0,0,C(n,2)]; [0,y_j2(n), y_act(n)]],[[0 l4 C(n,3)];[l4 z_j2(n)  z_act(n)]],'Color','k');

                                                                            % Plot extended part of third joint
    extended=plot3([x_j2(n); C(n,1)], [y_j2(n);C(n,2)],[z_j2(n); C(n,3)],'Color','m');

                                                                            % Legend
    legend([p_d,p_a,orix,oriy,oriz,robot(1),extended],{'Desired Path','Actual Path','n Vector','o Vector','a Vector','Robot','Third Joint Extension'});
                                                                        
    axis equal                                                              % Adjust axis and views
    xlim([-.35,.35]);
    ylim([-.35,.35]);
    zlim([0,.45]);
    view(-37.5,30);

    ax2 = subplot(1,2,2);                                                   % Copy all plots to second subplot
    title('X-Z Plane View')
    copyobj([p_a,p_d,orix,oriy,oriz,robot(1),robot(2),robot(3),extended], ax2);
    objs2=findall(ax2);
    legend([objs2(3),objs2(2),objs2(4),objs2(5),objs2(6),objs2(7),objs2(10)],{'Desired Path','Actual Path','n Vector','o Vector','a Vector','Robot','Third Joint Extension'});

    grid on
    axis equal
    xlim([-.35,.35]);
    ylim([-.35,.35]);
    zlim([0,.45]);
    view(0,0);                                                              % Adjust view on second subplot

    pause(.0001)                                                            % Pause to plot on screen
    writeVideo(animation, getframe(gcf));                                   % Save frame to video
    if n~=path_size
        clf;                                                                % Clear figures for next animation frame
    end
end
for n=1:50
    writeVideo(animation, getframe(gcf));                                   % Additional frammes at end of video
end
close(animation)

