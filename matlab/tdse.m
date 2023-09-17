clear
clc
close all

x_min=-4;
x_max=4;
y_min=-4;
y_max=4;
pos_step=.1;

time_start=0;
time_end=60;
h=.10;

x_array=x_min:pos_step:x_max;
y_array=y_min:pos_step:y_max;
t_array=time_start:h:time_end;
[x_mat,y_mat]=meshgrid(x_array,y_array);

psi_re=zeros([size(x_mat) length(t_array)]);
psi_im=zeros([size(x_mat) length(t_array)]);

std=.15;
height=1;
k_x=10;
k_y=-12;

gaussian_envelope=exp(-1*(x_mat.^2+y_mat.^2)/(2*std^2));
psi_re(:,:,1)=gaussian_envelope.*cos(k_x*(x_mat)+k_y*(y_mat));
psi_im(:,:,1)=gaussian_envelope.*sin(k_x*(x_mat)+k_y*(y_mat));
v=.5*(x_mat.^2+y_mat.^2);


volume=function_integrate3d((psi_re(:,:,1).^2+psi_im(:,:,1).^2),x_array,y_array,pos_step);
psi_re(:,:,1)=psi_re(:,:,1)./sqrt(volume);
psi_im(:,:,1)=psi_im(:,:,1)./sqrt(volume);
            
surf(x_mat,y_mat,psi_re(:,:,1),'EdgeColor','k','LineStyle',':')
hold on
surf(x_mat,y_mat,v,'EdgeColor','none','FaceAlpha',0.4)
zlim([-2,2]);
caxis([-1,.5]);

%% Runge Kutta
psi_re_temp=psi_re(:,:,1);
psi_im_temp=psi_im(:,:,1);
f = waitbar(0,'');
for t=2:length(t_array)
    waitbar(t/length(t_array),f,num2str(t/length(t_array)));
    [k1_real,k1_imag]=derivate(psi_re_temp, psi_im_temp, v);
    [k2_real,k2_imag]=derivate(psi_re_temp+h*(k1_real)/2, psi_im_temp+h*(k1_imag)/2, v);
    [k3_real,k3_imag]=derivate(psi_re_temp+h*(k2_real)/2, psi_im_temp+h*(k2_imag)/2, v);
    [k4_real,k4_imag]=derivate(psi_re_temp+h*(k3_real), psi_im_temp+h*(k3_imag), v);
    
    
    psi_re(:,:,t)=psi_re(:,:,t-1)+h*(k1_real+2*k2_real+2*k3_real+k4_real)/6;
    psi_re_temp=psi_re(:,:,t);
    psi_im(:,:,t)=psi_im(:,:,t-1)+h*(k1_imag+2*k2_imag+2*k3_imag+k4_imag)/6;
    psi_im_temp=psi_im(:,:,t);      
end
save(append(num2str(time_start),num2str(time_end),num2str(h),num2str(pos_step),num2str(std),num2str(k_x),num2str(k_y),'re.mat'),'psi_re');
save(append(num2str(time_start),num2str(time_end),num2str(h),num2str(pos_step),num2str(std),num2str(k_x),num2str(k_y),'im.mat'),'psi_im');
close(f);

%% Uncertainty Principle
%The TDSE demonstrates the quantum uncertainty principle which states that the uncertainty in position is inversely proportionaly to the uncertainity of momentum. The exact relationship is expressed by the following equation .
%By decreasing the initial width (positional uncertainty decreases) of the guassian envelope, the momentum of the wave function becomes more uncertain. The movement of the wavefunction becomes less defined.
k_x=10;
k_y=-12;

myVideo = VideoWriter('psi_up_one'); %open video file
myVideo.FrameRate = 20;  %can adjust this, 5 - 10 works well for me
myVideo.Quality=100;
open(myVideo)


psi1_re=load(append(num2str(0),num2str(60),num2str(.10),num2str(.05),num2str(.075),num2str(10),num2str(-12),'re.mat')).psi_re;
psi1_im=load(append(num2str(0),num2str(60),num2str(.10),num2str(.05),num2str(.075),num2str(10),num2str(-12),'im.mat')).psi_im;

psi2_re=load(append(num2str(0),num2str(60),num2str(.10),num2str(.05),num2str(.15),num2str(10),num2str(-12),'re.mat')).psi_re;
psi2_im=load(append(num2str(0),num2str(60),num2str(.10),num2str(.05),num2str(.15),num2str(10),num2str(-12),'im.mat')).psi_im;

psi3_re=load(append(num2str(0),num2str(60),num2str(.10),num2str(.05),num2str(.4),num2str(10),num2str(-12),'re.mat')).psi_re;
psi3_im=load(append(num2str(0),num2str(60),num2str(.10),num2str(.05),num2str(.4),num2str(10),num2str(-12),'im.mat')).psi_im;

=
set(gcf,'Visible','on');
set(gcf, 'Position', get(0, 'Screensize'));

for t=1:length(t_array)
    s=subplot(1,1,1);

    %subplot(1,3,1);
    surf(x_mat,y_mat,psi1_re(:,:,t),'EdgeColor','k','LineStyle',':')
    hold on
    surf(x_mat,y_mat,v,'EdgeColor','none','FaceAlpha',0.4)
    hold off
    zlim([-.75,1.25])
    caxis([-2,2])
    view(-45*(10/12),15)
    title('.075 STD')
    % surf(x_mat,y_mat,psi1_re(:,:,t).^2+psi1_im(:,:,t).^2,'EdgeColor','k','LineStyle',':')
    % zlim([0,2])
    % clim([-1,2])
    % view(-45*(10/12),15)


    % %s=subplot(1,3,2);
    % surf(x_mat,y_mat,psi2_re(:,:,t),'EdgeColor','k','LineStyle',':')
    % colormap(s,hot);
    % hold on
    % surf(x_mat,y_mat,v,'EdgeColor','none','FaceAlpha',0.4)
    % colormap(s,hot);
    % hold off
    % zlim([-.75,1.25])
    % caxis([-2,2])
    % view(-45*(10/12),15)
    % title('.15 STD')
    % % 
    % % surf(x_mat,y_mat,psi2_re(:,:,t).^2+psi2_im(:,:,t).^2,'EdgeColor','k','LineStyle',':')
    % % colormap(s,hot);
    % % zlim([0,2])
    % % clim([-1,2])
    % % view(-45*(10/12),15)
    % 

    % %s=subplot(1,3,3);
    % surf(x_mat,y_mat,psi3_re(:,:,t),'EdgeColor','k','LineStyle',':')
    % colormap(s,summer);
    % hold on
    % surf(x_mat,y_mat,v,'EdgeColor','none','FaceAlpha',0.4)
    % colormap(s,summer);
    % hold off
    % zlim([-.75,1.25])
    % caxis([-2,2])
    % view(-45*(10/12),15)
    % title('.4 STD')
    % 
    % % surf(x_mat,y_mat,psi3_re(:,:,t).^2+psi3_im(:,:,t).^2,'EdgeColor','k','LineStyle',':')
    % % colormap(s,summer);
    % % zlim([0,2])
    % % clim([-1,2])
    % % view(-45*(10/12),15)
    % % pause(.001)
    % 

     frame = getframe(gcf);
    writeVideo(myVideo, frame);
    if t==1
        pause(3);
    end
end
close(myVideo)

%% Energy of System
% In quantum mechanics the momentum, is directly related to the wavenumbers of the wave. The higher the wave number, the more momentum and more energy the system contains. The higher the wave number, the more distance the wave could travel away from the origin before being reflected by the potential.
time_start=0
time_end=30
h=.15

psi1_re=load(append(num2str(.4),num2str(10),num2str(-12),num2str(time_start),num2str(time_end),num2str(h),'re.mat')).psi_re;
psi1_im=load(append(num2str(.4),num2str(10),num2str(-12),num2str(time_start),num2str(time_end),num2str(h),'im.mat')).psi_im;
psi2_re=load(append(num2str(.4),num2str(5),num2str(-6),num2str(time_start),num2str(time_end),num2str(h),'re.mat')).psi_re;
psi2_im=load(append(num2str(.4),num2str(5),num2str(-6),num2str(time_start),num2str(time_end),num2str(h),'im.mat')).psi_im;
psi3_re=load(append(num2str(.4),num2str(1),num2str(-6/5),num2str(time_start),num2str(time_end),num2str(h),'re.mat')).psi_re;
psi3_im=load(append(num2str(.4),num2str(1),num2str(-6/5),num2str(time_start),num2str(time_end),num2str(h),'im.mat')).psi_im;

psi1_re=load(append(num2str(0),num2str(60),num2str(.10),num2str(.1),num2str(.4),num2str(10),num2str(-12),'re.mat')).psi_re;
psi1_im=load(append(num2str(0),num2str(60),num2str(.10),num2str(.1),num2str(.4),num2str(10),num2str(-12),'im.mat')).psi_im;

psi2_re=load(append(num2str(0),num2str(60),num2str(.10),num2str(.1),num2str(.4),num2str(5),num2str(-6),'re.mat')).psi_re;
psi2_im=load(append(num2str(0),num2str(60),num2str(.10),num2str(.1),num2str(.4),num2str(5),num2str(-6),'im.mat')).psi_im;

psi3_re=load(append(num2str(0),num2str(60),num2str(.10),num2str(.1),num2str(.4),num2str(1),num2str(-6/5),'re.mat')).psi_re;
psi3_im=load(append(num2str(0),num2str(60),num2str(.10),num2str(.1),num2str(.4),num2str(1),num2str(-6/5),'im.mat')).psi_im;

myVideo = VideoWriter('psi_energy'); %open video file
myVideo.FrameRate = 30;  %can adjust this, 5 - 10 works well for me
myVideo.Quality=100;
open(myVideo)



set(gcf,'Visible','on');
set(gcf, 'Position', get(0, 'Screensize'));

for t=1:length(t_array)
    subplot(1,3,1);
    surf(x_mat,y_mat,psi1_re(:,:,t),'EdgeColor','k','LineStyle',':')
    hold on
    surf(x_mat,y_mat,v,'EdgeColor','none','FaceAlpha',0.4)
    hold off
    zlim([-2,2])
    clim([-2,2])
    view(-45*(10/12),0)

    s=subplot(1,3,2);
    surf(x_mat,y_mat,psi2_re(:,:,t),'EdgeColor','k','LineStyle',':');
    hold on
    surf(x_mat,y_mat,v,'EdgeColor','none','FaceAlpha',0.4)
    colormap(s,hot);
    hold off
    zlim([-2,2])
    clim([-2,2])
    view(-45*(10/12),0)

    s=subplot(1,3,3);
    surf(x_mat,y_mat,psi3_re(:,:,t),'EdgeColor','k','LineStyle',':')
    hold on
    surf(x_mat,y_mat,v,'EdgeColor','none','FaceAlpha',0.4)
    colormap(s,summer);
    hold off
    zlim([-2,2])
    clim([-2,2])
    view(-45*(10/12),0)
    pause(.001)
         frame = getframe(gcf);
    writeVideo(myVideo, frame);
end
close(myVideo)

%% Functions
%% Derivative Function
function [d_re,d_im]=derivate(re,im,v)
    d_re=zeros(size(re));
    d_im=zeros(size(im));
    for n=2:size(re,1)-1
        for m=2:size(re,2)-1
            d_re(n,m,1)=(-im(n+1,m,1)-im(n-1,m,1)+2*im(n,m,1)+(-im(n,m+1,1)-im(n,m-1,1)+2*im(n,m,1)))+v(n,m)*(im(n,m,1));
            d_im(n,m,1)=(re(n+1,m,1)+re(n-1,m,1)-2*re(n,m,1)+(re(n,m+1,1)+re(n,m-1,1)-2*re(n,m,1)))-v(n,m)*(re(n,m,1));
        end
    end
end
