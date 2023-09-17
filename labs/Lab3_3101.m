clc;
clear;
close all;

zr=cell(1,19);
pl=cell(1,19);
num=cell(1,19);
den=cell(1,19);
%% Filters 1-4 (Prelab 8)

% Filter 1
num{1}=[1 1]; 
den{1}=[1 -.95];
%Filter 2
num{2}=[1 -1]; 
den{2}=[1 .95];
%Filter 3
num{3}=[1 0 -1]; 
den{3}=[1 0 .9025];
%Filter 4
num{4}=[1 0 1]; 
den{4}=[1 0 -.9025];

for n=1:4
    zr{n}=roots(num{n});
    pl{n}=roots(den{n});
end

%% Filters 5-8 (Prelab 9)

% Filter 5
zr{5} = [-1,1i,-1i,(1/sqrt(2))+1i*(1/sqrt(2)),-(1/sqrt(2))+1i*(1/sqrt(2)),(1/sqrt(2))-1i*(1/sqrt(2)),-(1/sqrt(2))-1i*(1/sqrt(2))];
pl{5} = zeros(1, 7);
% Filter 6
zr{6} = [1,1i,-1i,(1/sqrt(2))+1i*(1/sqrt(2)),(-1/sqrt(2))+1i*(1/sqrt(2)),(1/sqrt(2))-1i*(1/sqrt(2)),(-1/sqrt(2))-1i*(1/sqrt(2))];
pl{6} = zeros(1, 7);
% Filter 7
zr{7} = [1,-1,(1/sqrt(2))+1i*(1/sqrt(2)),(-1/sqrt(2))+1i*(1/sqrt(2)),(1/sqrt(2))-1i*(1/sqrt(2)),(-1/sqrt(2))-1i*(1/sqrt(2))];
pl{7} = zeros(1, 6);
% Filter 8
zr{8} = [1i,-1i,(1/sqrt(2))+1i*(1/sqrt(2)),(-1/sqrt(2))+1i*(1/sqrt(2)),(1/sqrt(2))-1i*(1/sqrt(2)),(-1/sqrt(2))-1i*(1/sqrt(2))];
pl{8} = zeros(1, 6); 

for n=5:8
    num{n}=poly(zr{n});
    den{n}=poly(pl{n});
end

%% Filters 9-13 (Prelab 10 Part 1)
zero_angle=[pi/5,pi/4,pi/3,pi/1.5,pi/1];
for n=9:13
    num{n}=[1,-2*cos(zero_angle(n-8)),1];
    den{n}=[1 0 0];
    zr{n}=roots(num{n});
    pl{n}=roots(den{n});
end
%% Filters 14-19 (Prelab 10 Part 2)

pole_angle=[pi/5,pi/3,pi/1.5];
pole_radius=[.98,.75];

for n=1:length(pole_radius)
    for m=1:length(pole_angle)
        num{13+(n-1)*3+m}=[1,0,0];
        den{13+(n-1)*3+m}=[1,-2*pole_radius(n)*cos(pole_angle(m)),pole_radius(n)^2];
        zr{13+(n-1)*3+m}=roots(num{13+(n-1)*3+m});
        pl{13+(n-1)*3+m}=roots(den{13+(n-1)*3+m});
    end
end

%% Gain 

for n=1:length(den)
    [Hd,w3]=freqz(num{n},den{n},500);
    b0=1/max(abs(Hd));
    num{n}=num{n}*b0;
end

%% Solo Pole Diagrams
for n=1:length(den)
    figure(n)
    zplane(num{n},den{n})
    title(['Pole-Zero Diagram: Filter ', num2str(n)]);
end
close all;



%% Pole Diagrams and Magnitude and Phase Repsonse (Same Figure)

for n=1:length(den)
    figure(n)
    subplot(1,3,1)
    zplane(num{n},den{n})
    title('Pole Zero Diagram');
end


for n=1:length(den)
    figure(n)
    [Hd,w3]=freqz(num{n},den{n},500);
    zplane(num{n},den{n})

    
    %  Digital Magnitude Response H(z)
    subplot(2,3,2)
    plot(w3/pi,abs(Hd),'LineWidth',2);grid on;
    xlabel('\theta/\pi');ylabel('|H(\theta)|');
    title('Magnitude Response (Linear)');
    
    %  Digital Magnitude Response (dB) H(z)
    subplot(2,3,3)
    semilogx(w3/pi,20*log10(abs(Hd)),'LineWidth',2);grid on;
    xlabel('\theta/\pi');ylabel('20*log_1_0|H(\theta)|');
    title('Magnitude Response (dB)');
    
    %  Digital Phase Response H(z)
    subplot(2,3,5)
    plot(w3/pi,angle(Hd)*180/pi,'LineWidth',2);grid on;
    xlabel('\theta/\pi');ylabel('\angleH(\theta) (deg)');
    title('Phase Response');
    
    %  Digital Phase Response H(z)
    subplot(2,3,6)
    semilogx(w3/pi,angle(Hd)*180/pi,'LineWidth',2);grid on;
    xlabel('\theta/\pi');ylabel('\angleH(\theta) (deg)');
    title('Phase Response (SemiLogX)');

    sgtitle(['Filter ',num2str(n),' Response'])
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas(gcf,['Filter ',num2str(n),' Response.png'])

end
close all

%% Individual Pole Diagrams and Magnitude and Phase Repsonse (Lab 10 Filters)
for n=9:13
    fig1=figure(1)
    sgtitle('Zero-Pole Maps (Moving Zero Filters)')

    subplot(2,3,n-8)
    zplane(num{n},den{n})
    title({['Filter ', num2str(n)],['Zero at \theta = ',num2str(zero_angle(n-8))]});

    fig2=figure(2)
    sgtitle('Linear Magnitude Response (Moving Zero Filters)')

    [Hd,w3]=freqz(num{n},den{n},500);
    %  Digital Magnitude Response H(z)
    subplot(2,3,n-8);
    plot(w3/pi,abs(Hd),'LineWidth',2);grid on;
    xlabel('\theta/\pi');ylabel('|H(\theta)|');
    title({['Filter ', num2str(n)],['Zero at \theta = ',num2str(zero_angle(n-8))]});

        %  Digital Phase Response H(z)
    fig3=figure(3)
    sgtitle('Phase Response (Moving Zero Filters)')

    subplot(2,3,n-8)
    plot(w3/pi,angle(Hd)*180/pi,'LineWidth',2);grid on;
    xlabel('\theta/\pi');ylabel('\angleH(\theta) (deg)');
    title({['Filter ', num2str(n)],['Zero at \theta = ',num2str(zero_angle(n-8))]});
end

for n=14:19
    fig4=figure(4)
    sgtitle('Zero-Pole Maps (Moving Pole Filters)')
    subplot(2,3,n-13)
    zplane(num{n},den{n})
    title({['Filter ', num2str(n)],['Pole at \theta = ',num2str(pole_angle(mod(n-13,3)+1))]});
   
    fig5=figure(5)
    sgtitle('Linear Magnitude Response (Moving Pole Filters)')
    [Hd,w3]=freqz(num{n},den{n},500);
    %  Digital Magnitude Response H(z)

    subplot(2,3,n-13);
    plot(w3/pi,abs(Hd),'LineWidth',2);grid on;
    xlabel('\theta/\pi');ylabel('|H(\theta)|');
    title({['Filter ', num2str(n)],['Pole at \theta = ',num2str(pole_angle(mod(n-13,3)+1))]});

        %  Digital Phase Response H(z)
    fig6=figure(6)
    sgtitle('Phase Response (Moving Pole Filters)')
    subplot(2,3,n-13)
    plot(w3/pi,angle(Hd)*180/pi,'LineWidth',2);grid on;
    xlabel('\theta/\pi');ylabel('\angleH(\theta) (deg)');
    title({['Filter ', num2str(n)],['Pole at \theta = ',num2str(pole_angle(mod(n-13,3)+1))]});
end

set(fig1, 'Position', get(0, 'Screensize'));
saveas(fig1,['Zero-Pole Map (Moving Zero Filters) .png'])
set(fig2, 'Position', get(0, 'Screensize'));
saveas(fig2,['Linear Magnitude Response (Moving Zero Filters) .png'])
set(fig3, 'Position', get(0, 'Screensize'));
saveas(fig3,['Phase Response (Moving Zero Filters) .png'])    

set(fig4, 'Position', get(0, 'Screensize'));
saveas(fig4,['Zero-Pole Map (Moving Pole Filters) .png'])
set(fig5, 'Position', get(0, 'Screensize'));
saveas(fig5,['Linear Magnitude Response (Moving Pole Filters) .png'])
set(fig6, 'Position', get(0, 'Screensize'));
saveas(fig6,['Phase Response (Moving Pole Filters) .png']) 
close all

%% Individual Pole Diagrams and Magnitude and Phase Repsonse (LAB 8 AND 9)
 
for n=1:4
    fig1=figure(1)
    sgtitle('Prelab 8 Zero-Pole Maps')
    
    subplot(1,4,n)
    zplane(num{n},den{n})
    title({['Filter ', num2str(n)]});
    
    fig2=figure(2)
    sgtitle('Prelab 8 Linear Magnitude Responses')
    
    [Hd,w3]=freqz(num{n},den{n},500);
    %  Digital Magnitude Response H(z)
    subplot(2,4,n)
    plot(w3/pi,abs(Hd),'LineWidth',2);grid on;
    xlabel('\theta/\pi');ylabel('|H(\theta)|');
    title({['Filter ', num2str(n)]});
    
        %  Digital Phase Response H(z)
    fig3=figure(3)
    sgtitle('Prelab 8 Phase Responses')
    
    subplot(1,4,n)
    plot(w3/pi,angle(Hd)*180/pi,'LineWidth',2);grid on;
    xlabel('\theta/\pi');ylabel('\angleH(\theta) (deg)');
    title({['Filter ', num2str(n)]});
end

for n=5:8
    fig4=figure(4)
    sgtitle('Prelab 9 Zero-Pole Maps')
    
    subplot(1,4,n-4)
    zplane(num{n},den{n})
    title({['Filter ', num2str(n)]});
    
    fig5=figure(5)
    sgtitle('Prelab 9 Linear Magnitude Responses')
    
    [Hd,w3]=freqz(num{n},den{n},500);
    %  Digital Magnitude Response H(z)
    subplot(2,4,n-4)
    plot(w3/pi,abs(Hd),'LineWidth',2);grid on;
    xlabel('\theta/\pi');ylabel('|H(\theta)|');
    title({['Filter ', num2str(n)]});
    
        %  Digital Phase Response H(z)
    fig6=figure(6)
    sgtitle('Prelab 9 Phase Responses')
    
    subplot(1,4,n-4)
    plot(w3/pi,angle(Hd)*180/pi,'LineWidth',2);grid on;
    xlabel('\theta/\pi');ylabel('\angleH(\theta) (deg)');
    title({['Filter ', num2str(n)]});
end



set(fig1, 'Position', get(0, 'Screensize'));
saveas(fig1,['Prelab 8 Zero-Pole Map.png'])
set(fig2, 'Position', get(0, 'Screensize'));
saveas(fig2,['Prelab 8 Linear Magnitude Response.png'])
set(fig3, 'Position', get(0, 'Screensize'));
saveas(fig3,['Prelab 8 Phase Response.png'])    

set(fig4, 'Position', get(0, 'Screensize'));
saveas(fig4,['Prelab 9 Zero-Pole Map.png'])
set(fig5, 'Position', get(0, 'Screensize'));
saveas(fig5,['Prelab 9 Linear Magnitude Response.png'])
set(fig6, 'Position', get(0, 'Screensize'));
saveas(fig6,['Prelab 9 Phase Response.png']) 
close all;

%% Calcualted Magntiude Response
figure(20)
freqs_array=0:.01:pi;
zero_distance_sum=ones([1,length(freqs_array)]);
pole_distance_sum=ones([1,length(freqs_array)]);

for freq=1:length(freqs_array)
    for n=zr{5}
        zero_distance_sum(freq)=zero_distance_sum(freq)*abs(n-exp(j*freqs_array(freq)));
    end
end

for freq=1:length(freqs_array)
    for n=pl{5}
        pole_distance_sum(freq)=pole_distance_sum(freq)*abs(n-exp(j*freqs_array(freq)));
    end
end
mag_response=zero_distance_sum./pole_distance_sum;
plot(freqs_array,mag_response/max(mag_response));

%% Filtering cosine wave
close all

sample_array=cell(1,19);
for n=1:15
    sample_array{n}=[32,8,2];
end
sample_array{3}=[32,4,2];
sample_array{11}=[32,6,2];
sample_array{15}=[32,6,2];

fundamental=30;
num_cycles=1000;

for flt=1:19
    [Hd,w3]=freqz(num{flt},den{flt},5000000);
    figure(flt)
    samples_per_cycle=sample_array{flt};

    for samples_ind=1:length(samples_per_cycle)
        cur_cycle_samples=samples_per_cycle(samples_ind);
        sampling_freq=cur_cycle_samples*fundamental;
        nyquist=sampling_freq/2;
        freq_ratio=fundamental/nyquist;
        time_points=linspace(0,num_cycles/fundamental-(1/sampling_freq),num_cycles*cur_cycle_samples);
        xn=cos(2*pi*fundamental*time_points);

        poly_order_zero=length(num{flt});
        poly_order_pole=length(den{flt})-1;
        yn=zeros([1,length(xn)]);
        inputs=zeros([1,poly_order_zero]);
        outputs=zeros([1,poly_order_pole]);

        for n=1:length(xn)
            old_inputs=inputs;
            inputs(2:poly_order_zero)=old_inputs(1:poly_order_zero-1);
            inputs(1)=xn(n);
            yn(n)=sum(inputs.*num{flt})+sum(outputs.*-den{flt}(2:end));
            old_outputs=outputs;
            outputs(2:poly_order_pole)=old_outputs(1:poly_order_pole-1);
            outputs(1)=yn(n);
        end 

        yn_fft=fft(yn)
        fft_ind=(length(fft(yn))/2)*(freq_ratio)+1
        actual_phase=rad2deg(angle(yn_fft(fft_ind)))
        if freq_ratio==1
            actual_mag=max(abs(yn_fft))/(length(yn_fft))
        else
            actual_mag=max(abs(yn_fft))/(length(yn_fft)/2)
        end
        subplot(1,3,samples_ind)
        indices=cur_cycle_samples*500:cur_cycle_samples*500+cur_cycle_samples*5;
        plot(indices,xn(indices),':bs')
        hold on
        plot(indices,yn(indices),'-.r*')
        xlim([min(indices) max(indices)]);
        yn_indices=yn(indices);
        [~,ind]=min(abs(w3/pi-freq_ratio));

        response_phase=mean(rad2deg(angle(Hd(ind))));

        if (max(yn(indices))<.001)
            actual_phase=nan;
        end
        title({['Fundamental/Nyquist = \theta/\pi = ',num2str(fundamental),'/',num2str(nyquist),' = ',num2str(freq_ratio)],['Magnitude Response at \theta/\pi: ', num2str(mean(abs(Hd(ind))))],['Actual Amplitude after 500 cycles: ', num2str(actual_mag)],['Phase Response at \theta/\pi: ', num2str(response_phase)],['Actual Phase after 500 cycles: ', num2str(actual_phase)]})
        sgtitle(['Filter ',num2str(flt), ': Cosine Input'])
        set(gcf, 'Position', get(0, 'Screensize'));
        saveas(gcf,['Filter ',num2str(flt),' Sinusoid.png'])
    end
end
close all
%% Audio Loading
audiofiles = {'goreAudio.au','speechAudio.au','20Hzto20KHz.mp3','boygeorgeAudio.au','bellsTibetan.wav'};
input_audio=cell(1,5);
Fs=cell(1,5);

for audfls = 1:length(audiofiles)
    [input_audio{audfls}, Fs{audfls}] = audioread(audiofiles{audfls}); 
end

%White noise generator
L=10000;
mu=0;
sigma=2;
input_white_noise=sigma+randn(L,1)+mu;
Fs_wn=8000;

%% LAB 8 FILTERING 
close all;

for flt=1:4
    for audfls = 1:length(audiofiles)
        filtered_audio=filter(num{flt},den{flt},input_audio{audfls}); 
        fig_num=flt;
        fsf(fig_num)=figure(fig_num);
        set(fsf(fig_num), 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);

        subplot(2,length(audiofiles),audfls);
        plot(input_audio{audfls},'b')
        axis tight;
        hold on 
        plot(filtered_audio,'r') 
        title({['Input and Filtered Audio Signals:'],[' Filter ', num2str(flt) ],[' for ' audiofiles{audfls}]});
        xlabel('Time'); ylabel('Audio Signal');
        axis tight;
        legend('Input Audio','Filtered Audio');
        
        fft_input_audio=fft(input_audio{audfls},length(input_audio{audfls}));
        fft_input_audio(1)=0;
        nf=Fs{audfls}*(0:length(input_audio{audfls})-1)/length(input_audio{audfls}); 
        subplot(2,length(audiofiles),audfls+ length(audiofiles));
        plot(nf(1:length(input_audio{audfls})/2),abs(fft_input_audio(1:length(input_audio{audfls})/2))); 
        fft_filtered_audio=fft(filtered_audio, length(filtered_audio));
        fft_filtered_audio(1)=0;
        axis tight;
        hold on 
        nf=Fs{audfls}*(0:length(input_audio{audfls})-1)/length(input_audio{audfls}); 
        plot(nf(1:length(input_audio{audfls})/2),abs(fft_filtered_audio(1:length(input_audio{audfls})/2)),'r') 
        title({['FFT of Input and Filtered'],['Audio Signals: Filter ', num2str(flt)],[' for ' audiofiles{audfls}]});
        xlabel('Frequency [Hz] ') 
        ylabel('Magnitude of Frequency Response') 
        axis tight;
        legend('FFT Input Audio','FFT Filtered Audio');
 
    end
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas(gcf,['Filter ',num2str(flt),'_byFilter.png'])
end

close all
for flt=1:4
        filtered_audio=filter(num{flt},den{flt},input_white_noise); 
        fsf(5)=figure(5);
        set(fsf(5), 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        subplot(2,4,flt);
        plot(input_white_noise,'b')
        axis tight;
        hold on 
        plot(filtered_audio,'r') 
        title({['Input and Filtered Audio Signals:'],[' Filter ', num2str(flt) ],[' for White Noise']});
        xlabel('Time'); ylabel('Audio Signal');
        axis tight;
        legend('Input Audio','Filtered Audio');
        fft_input_audio=fft(input_white_noise,length(input_white_noise));
        fft_input_audio(1)=0;
        nf=Fs_wn*(0:length(input_white_noise)-1)/length(input_white_noise); 
        subplot(2,4,flt+4);
        plot(nf(1:length(input_white_noise)/2),abs(fft_input_audio(1:length(input_white_noise)/2))); 
        fft_filtered_audio=fft(filtered_audio, length(filtered_audio));
        fft_filtered_audio(1)=0;
        axis tight;
        hold on 
        nf=Fs_wn*(0:length(input_white_noise)-1)/length(input_white_noise); 
        plot(nf(1:length(input_white_noise)/2),abs(fft_filtered_audio(1:length(input_white_noise)/2)),'r') 
        title({['FFT of Input and Filtered'],['Audio Signals: Filter ', num2str(flt)],[' for White Noise']});
        xlabel('Frequency [Hz] ') 
        ylabel('Magnitude of Frequency Response') 
        axis tight;
        legend('FFT Input Audio','FFT Filtered Audio');

end
set(gcf, 'Position', get(0, 'Screensize'));
saveas(gcf,['Lab 8 White Noise.png'])
%% LAB 9 FILTERING 
close all;
for flt=5:8
    for audfls = 1:length(audiofiles)
        filtered_audio=filter(num{flt},den{flt},input_audio{audfls}); 
        fig_num=flt-4
        fsf(fig_num)=figure(fig_num);
        set(fsf(fig_num), 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        subplot(2,length(audiofiles),audfls);
        plot(input_audio{audfls},'b')
        axis tight;
        hold on 
        plot(filtered_audio,'r') 
        title({['Input and Filtered Audio Signals:'],[' Filter ', num2str(flt) ],[' for ' audiofiles{audfls}]});
        xlabel('Time'); ylabel('Audio Signal');
        axis tight;
        legend('Input Audio','Filtered Audio');
        fft_input_audio=fft(input_audio{audfls},length(input_audio{audfls}));
        fft_input_audio(1)=0;
        nf=Fs{audfls}*(0:length(input_audio{audfls})-1)/length(input_audio{audfls}); 
        subplot(2,length(audiofiles),audfls+ length(audiofiles));
        plot(nf(1:length(input_audio{audfls})/2),abs(fft_input_audio(1:length(input_audio{audfls})/2))); 
        fft_filtered_audio=fft(filtered_audio, length(filtered_audio));
        fft_filtered_audio(1)=0;
        axis tight;
        hold on 
        nf=Fs{audfls}*(0:length(input_audio{audfls})-1)/length(input_audio{audfls}); 
        plot(nf(1:length(input_audio{audfls})/2),abs(fft_filtered_audio(1:length(input_audio{audfls})/2)),'r') 
        title({['FFT of Input and Filtered'],['Audio Signals: Filter ', num2str(flt)],[' for ' audiofiles{audfls}]});
        xlabel('Frequency [Hz] ') 
        ylabel('Magnitude of Frequency Response') 
        axis tight;
        legend('FFT Input Audio','FFT Filtered Audio');
    end
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas(gcf,['Filter ',num2str(flt),'_byFilter.png'])
end


for flt=5:8
    filtered_audio=filter(num{flt},den{flt},input_white_noise); 
    fsf(6)=figure(6);
    set(fsf(6), 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    subplot(2,4,flt-4);
    plot(input_white_noise,'b')
    axis tight;
    hold on 
    plot(filtered_audio,'r') 
    title({['Input and Filtered Audio Signals:'],[' Filter ', num2str(flt) ],[' for White Noise ']});
    xlabel('Time'); ylabel('Audio Signal');
    axis tight;
    legend('Input Audio','Filtered Audio');
    fft_input_audio=fft(input_white_noise,length(input_white_noise));
    fft_input_audio(1)=0;
    nf=Fs_wn*(0:length(input_white_noise)-1)/length(input_white_noise); 
    subplot(2,4,flt);
    plot(nf(1:length(input_white_noise)/2),abs(fft_input_audio(1:length(input_white_noise)/2))); 
    fft_filtered_audio=fft(filtered_audio, length(filtered_audio));
    fft_filtered_audio(1)=0;
    axis tight;
    hold on 
    nf=Fs_wn*(0:length(input_white_noise)-1)/length(input_white_noise); 
    plot(nf(1:length(input_white_noise)/2),abs(fft_filtered_audio(1:length(input_white_noise)/2)),'r') 
    title({['FFT of Input and Filtered'],['Audio Signals: Filter ', num2str(flt)],[' for White Noise']});
    xlabel('Frequency [Hz] ') 
    ylabel('Magnitude of Frequency Response') 
    axis tight;
    legend('FFT Input Audio','FFT Filtered Audio');
end

set(gcf, 'Position', get(0, 'Screensize'));
saveas(gcf,['Lab 9 White Noise.png'])

%% LAB 10 PART 1 FILTERING 
close all;
for audfls = 1:length(audiofiles)
    for flt=9:13
        filtered_audio=filter(num{flt},den{flt},input_audio{audfls}); 
        fig_num=audfls
        fsf(fig_num)=figure(fig_num);
        set(fsf(fig_num), 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        subplot(2,length(9:13),flt-8);
        plot(input_audio{audfls},'b')
        axis tight;
        hold on 
        plot(filtered_audio,'r') 
        title({['Input and Filtered Audio Signals:'],[' Filter ', num2str(flt), ' (Zero at Angle: ', num2str(zero_angle(flt-8)),')' ],[' for ' audiofiles{audfls}]});
        xlabel('Time'); ylabel('Audio Signal');
        axis tight;
        legend('Input Audio','Filtered Audio');
        fft_input_audio=fft(input_audio{audfls},length(input_audio{audfls}));
        fft_input_audio(1)=0;
        nf=Fs{audfls}*(0:length(input_audio{audfls})-1)/length(input_audio{audfls}); 
        subplot(2,length(9:13),flt-8+ length(9:13));
        plot(nf(1:length(input_audio{audfls})/2),abs(fft_input_audio(1:length(input_audio{audfls})/2))); 
        fft_filtered_audio=fft(filtered_audio, length(filtered_audio));
        fft_filtered_audio(1)=0;
        axis tight;
        hold on 
        nf=Fs{audfls}*(0:length(input_audio{audfls})-1)/length(input_audio{audfls}); 
        plot(nf(1:length(input_audio{audfls})/2),abs(fft_filtered_audio(1:length(input_audio{audfls})/2)),'r') 
        title({['FFT of Input and Filtered'],['Audio Signals: Filter ', num2str(flt)],[' (Zero at Angle: ', num2str(zero_angle(flt-8)),')' ],[' for ' audiofiles{audfls}]});
        xlabel('Frequency [Hz] ') 
        ylabel('Magnitude of Frequency Response') 
        axis tight;
        legend('FFT Input Audio','FFT Filtered Audio');
    end
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas(gcf,['Lab 10 Part 1 Audio  ',audiofiles{audfls},'_byAudio.png'])
end


for flt=9:13
    filtered_audio=filter(num{flt},den{flt},input_white_noise); 
    fsf(6)=figure(6);
    set(fsf(6), 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    subplot(2,length(9:13),flt-8);
    plot(input_white_noise,'b')
    axis tight;
    hold on 
    plot(filtered_audio,'r') 
    title({['Input and Filtered Audio Signals:'],[' Filter ', num2str(flt), ' (Zero at Angle: ', num2str(zero_angle(flt-8)),')'  ],[' for White Noise']});
    xlabel('Time'); ylabel('Audio Signal');
    axis tight;
    legend('Input Audio','Filtered Audio');
    fft_input_audio=fft(input_white_noise,length(input_white_noise));
    fft_input_audio(1)=0;
    nf=Fs_wn*(0:length(input_white_noise)-1)/length(input_white_noise); 
    subplot(2,length(9:13),flt-8+ length(9:13));
    plot(nf(1:length(input_white_noise)/2),abs(fft_input_audio(1:length(input_white_noise)/2))); 
    fft_filtered_audio=fft(filtered_audio, length(filtered_audio));
    fft_filtered_audio(1)=0;
    axis tight;
    hold on 
    nf=Fs_wn*(0:length(input_white_noise)-1)/length(input_white_noise); 
    plot(nf(1:length(input_white_noise)/2),abs(fft_filtered_audio(1:length(input_white_noise)/2)),'r') 
    title({['FFT of Input and Filtered'],['Audio Signals: Filter ', num2str(flt)], [' (Zero at Angle: ', num2str(zero_angle(flt-8)),')' ],[' for White Noise']});
    xlabel('Frequency [Hz] ') 
    ylabel('Magnitude of Frequency Response') 
    axis tight;
    legend('FFT Input Audio','FFT Filtered Audio');
end
set(gcf, 'Position', get(0, 'Screensize'));
saveas(gcf,['Lab 10 Part 1 White Noise.png'])

%% LAB 10 PART 2 FILTERING 
close all;
for audfls = 1:length(audiofiles)
    for flt=14:19
        filtered_audio=filter(num{flt},den{flt},input_audio{audfls}); 
        fig_num=audfls
        fsf(fig_num)=figure(fig_num);
        set(fsf(fig_num), 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        subplot(2,length(14:19),flt-13);
        plot(input_audio{audfls},'b')
        axis tight;
        hold on 
        plot(filtered_audio,'r') 
        title({['Input and Filtered'],['Audio Signals: Filter ', num2str(flt)],[ ' (Pole at Angle: ', num2str(pole_angle(mod(flt-14,3)+1))],['with Magnitude: ',num2str(pole_radius(round(((flt-14)/6))+1)),')' ],[' for ' audiofiles{audfls}]});
        xlabel('Time'); ylabel('Audio Signal');
        axis tight;
        legend('Input Audio','Filtered Audio');
        fft_input_audio=fft(input_audio{audfls},length(input_audio{audfls}));
        fft_input_audio(1)=0;
        nf=Fs{audfls}*(0:length(input_audio{audfls})-1)/length(input_audio{audfls}); 
        subplot(2,length(14:19),flt-13+ length(14:19));
        plot(nf(1:length(input_audio{audfls})/2),abs(fft_input_audio(1:length(input_audio{audfls})/2))); 
        fft_filtered_audio=fft(filtered_audio, length(filtered_audio));
        fft_filtered_audio(1)=0;
        axis tight;
        hold on 
        nf=Fs{audfls}*(0:length(input_audio{audfls})-1)/length(input_audio{audfls}); 
        plot(nf(1:length(input_audio{audfls})/2),abs(fft_filtered_audio(1:length(input_audio{audfls})/2)),'r') 
        title({['FFT of Input and Filtered'],['Audio Signals: Filter ', num2str(flt)],[ ' (Pole at Angle: ', num2str(pole_angle(mod(flt-14,3)+1))],['with Magnitude: ',num2str(pole_radius(round(((flt-14)/6))+1)),')' ],[' for ' audiofiles{audfls}]});
        xlabel('Frequency [Hz] ') 
        ylabel('Magnitude of Frequency Response') 
        axis tight;
        legend('FFT Input Audio','FFT Filtered Audio');
    end
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas(gcf,['Lab 10 Part 2 Audio  ',audiofiles{audfls},'_byAudio.png'])
end


for flt=14:19
    filtered_audio=filter(num{flt},den{flt},input_white_noise); 
    fsf(6)=figure(6);
    set(fsf(6), 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    subplot(2,length(14:19),flt-13);
    plot(input_white_noise,'b')
    axis tight;
    hold on 
    plot(filtered_audio,'r') 
    round(((flt-14)/6))+1
    title({['Input and Filtered'],['Audio Signals: Filter ', num2str(flt)],[ ' (Pole at Angle: ', num2str(pole_angle(mod(flt-14,3)+1))],['with Magnitude: ',num2str(pole_radius(round(((flt-14)/6))+1)),')' ],[' for White Noise']});
    xlabel('Time'); ylabel('Audio Signal');
    axis tight;
    legend('Input Audio','Filtered Audio');
    fft_input_audio=fft(input_white_noise,length(input_white_noise));
    fft_input_audio(1)=0;
    nf=Fs_wn*(0:length(input_white_noise)-1)/length(input_white_noise); 
    subplot(2,length(14:19),flt-13+ length(14:19));
    plot(nf(1:length(input_white_noise)/2),abs(fft_input_audio(1:length(input_white_noise)/2))); 
    fft_filtered_audio=fft(filtered_audio, length(filtered_audio));
    fft_filtered_audio(1)=0;
    axis tight;
    hold on 
    nf=Fs_wn*(0:length(input_white_noise)-1)/length(input_white_noise); 
    plot(nf(1:length(input_white_noise)/2),abs(fft_filtered_audio(1:length(input_white_noise)/2)),'r') 
    title({['FFT of Input and Filtered'],['Audio Signals: Filter ', num2str(flt)],[ ' (Pole at Angle: ', num2str(pole_angle(mod(flt-14,3)+1))],['with Magnitude: ',num2str(pole_radius(round(((flt-14)/6))+1)),')' ],[' for White Noise']});
    xlabel('Frequency [Hz] ') 
    ylabel('Magnitude of Frequency Response') 
    axis tight;
    legend('FFT Input Audio','FFT Filtered Audio');
end
set(gcf, 'Position', get(0, 'Screensize'));
saveas(gcf,['Lab 10 Part 2 White Noise.png'])

%% LAB 8 BY AUDIO SIGNAL
close all;
for audfls = 1:length(audiofiles)
    for flt=1:4
        filtered_audio=filter(num{flt},den{flt},input_audio{audfls}); 
        fig_num=audfls
        fsf(fig_num)=figure(fig_num);
        set(fsf(fig_num), 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        subplot(2,length(1:4),flt);
        plot(input_audio{audfls},'b')
        axis tight;
        hold on 
        plot(filtered_audio,'r') 
        title({['Input and Filtered Audio Signals:'],[' Filter ', num2str(flt) ],[' for ' audiofiles{audfls}]});
        xlabel('Time'); ylabel('Audio Signal');
        axis tight;
        legend('Input Audio','Filtered Audio');
        fft_input_audio=fft(input_audio{audfls},length(input_audio{audfls}));
        fft_input_audio(1)=0;
        nf=Fs{audfls}*(0:length(input_audio{audfls})-1)/length(input_audio{audfls}); 
        subplot(2,length(1:4),flt+ length(1:4));
        plot(nf(1:length(input_audio{audfls})/2),abs(fft_input_audio(1:length(input_audio{audfls})/2))); 
        fft_filtered_audio=fft(filtered_audio, length(filtered_audio));
        fft_filtered_audio(1)=0;
        axis tight;
        hold on 
        nf=Fs{audfls}*(0:length(input_audio{audfls})-1)/length(input_audio{audfls}); 
        plot(nf(1:length(input_audio{audfls})/2),abs(fft_filtered_audio(1:length(input_audio{audfls})/2)),'r') 
        title({['FFT of Input and Filtered'],['Audio Signals: Filter ', num2str(flt)],[' for ' audiofiles{audfls}]});
        xlabel('Frequency [Hz] ') 
        ylabel('Magnitude of Frequency Response') 
        axis tight;
        legend('FFT Input Audio','FFT Filtered Audio');
    end
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas(gcf,['Lab 8 Audio  ',audiofiles{audfls},'_byAudio.png'])
end

%% LAB 9 BY AUDIO SIGNAL
close all;
for audfls = 1:length(audiofiles)
    for flt=5:8
        filtered_audio=filter(num{flt},den{flt},input_audio{audfls}); 
        fig_num=audfls
        fsf(fig_num)=figure(fig_num);
        set(fsf(fig_num), 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
        subplot(2,length(5:8),flt-4);
        plot(input_audio{audfls},'b')
        axis tight;
        hold on 
        plot(filtered_audio,'r') 
        title({['Input and Filtered Audio Signals:'],[' Filter ', num2str(flt) ],[' for ' audiofiles{audfls}]});
        xlabel('Time'); ylabel('Audio Signal');
        axis tight;
        legend('Input Audio','Filtered Audio');
        fft_input_audio=fft(input_audio{audfls},length(input_audio{audfls}));
        fft_input_audio(1)=0;
        nf=Fs{audfls}*(0:length(input_audio{audfls})-1)/length(input_audio{audfls}); 
        subplot(2,length(5:8),flt-4+ length(5:8));
        plot(nf(1:length(input_audio{audfls})/2),abs(fft_input_audio(1:length(input_audio{audfls})/2))); 
        fft_filtered_audio=fft(filtered_audio, length(filtered_audio));
        fft_filtered_audio(1)=0;
        axis tight;
        hold on 
        nf=Fs{audfls}*(0:length(input_audio{audfls})-1)/length(input_audio{audfls}); 
        plot(nf(1:length(input_audio{audfls})/2),abs(fft_filtered_audio(1:length(input_audio{audfls})/2)),'r') 
        title({['FFT of Input and Filtered'],['Audio Signals: Filter ', num2str(flt)],[' for ' audiofiles{audfls}]});
        xlabel('Frequency [Hz] ') 
        ylabel('Magnitude of Frequency Response') 
        axis tight;
        legend('FFT Input Audio','FFT Filtered Audio');
    end
    set(gcf, 'Position', get(0, 'Screensize'));
    saveas(gcf,['Lab 9 Audio  ',audiofiles{audfls},'_byAudio.png'])
end

