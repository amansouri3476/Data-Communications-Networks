%% Part a
close all
clc

dt = 500000^(-1);
t = dt : dt : 0.001 ; % 5 signal periods
X = sin(2*pi*5000.*t);
figure
plot(t,X);
title('Sine Wave of Frequency=5KHz for 5 Periods','color','r');
xlabel('Time','color','b');
ylabel('Amplitude','color','b');

%% Part b
close all
clc

% Assuming Ac of Modulation = 1

X_c1 = cos(2*pi*140*1000.*t).*X;
figure
plot(t,X_c1);
title('DSB Modulated Signal','color','r');
xlabel('Time','color','b');
ylabel('Amplitude','color','b');

%% Part c
close all
clc
dt = 0.00000001;
t_new = dt : dt : 0.0006 ;
X = sin(2*pi*5000.*t_new);
% Assuming Ac of Modulation = 1
X_c2 = (1 + 0.2*X).*cos(2*pi*140*1000.*t_new);
X_c3 = (1 + 0.5*X).*cos(2*pi*140*1000.*t_new);
X_c4 = (1 + 0.9*X).*cos(2*pi*140*1000.*t_new);
figure
subplot(3,1,1)
plot(t_new,X_c2);
title('AM Modulated (u = 0.2)','color','r');
subplot(3,1,2)
plot(t_new,X_c3);
title('AM Modulated (u = 0.5)','color','r');
subplot(3,1,3)
plot(t_new,X_c4);
title('AM Modulated (u = 0.9)','color','r');
suptitle('AM Modulated Signal for Different Values of u');

%% Part d
close all
clc
dt = 500000^(-1);
t = dt : dt : 0.001;
h = 2*pi*6000.*exp(-2*pi*6000.*t);
plot(t,h);
title('Impulse Response','color','r');

%% Part e
close all
clc
dt = 500000^(-1);
t = dt : dt : 0.001 ;
X = sin(2*pi*5000.*t);
X_c1_Demod = X_c1.*cos(2*pi*140*1000.*t);
Y = 2*conv(X_c1_Demod,h)/500000;
Y_1 = Y(1 : 1+length(Y)/2); % Adjusting the limits for proper display
figure
subplot(2,1,1)
plot(t,Y_1);
title('Demodulated Signal','color','r');
subplot(2,1,2)
plot(t,X_c1);
title('Modulated Signal','color','r');
suptitle('AM Modulated and Demodulated Signal')
figure
plot(t,Y_1,'b');
title('Demodulated Signal and Original Message Signal','color','r');
hold on
plot(t,X,'r');

%% Part f
close all
clc
dt = 0.00000001;
t = dt : dt : 0.0006 ;
X = sin(2*pi*5000.*t);
% for signal 1
m = 0;
Y_2 = zeros(length(X_c2)+1,1);
Y_2(1)=X_c2(1);
for i = 1 : length(X_c2) - 1;
   
    if X_c2(i)>Y_2(i)
        diode_on = 1;
        m = 0;
        Y_2(i+1) = X_c2(i+1);
    else
        diode_on = 0;
    end 
    if diode_on == 0
        Y_2(i+1) = Y_2(i-m)*exp(-(m+1)*dt*140*40);
        m = m + 1;
    end
end
Y_2 = Y_2 - mean(Y_2); % DC Block
h = 2*pi*6000.*exp(-2*pi*6000.*t_new);% Low Pass filter Impulse Response
Y_22 = (0.2)^-1 *conv(Y_2,h)/1e8;% Compensating for u=0.2 and low passing
figure
subplot(3,1,1)
plot(t_new,Y_22(1:length(t_new)))
xlabel('Time','color','r')
ylabel('Amplitude','color','r')
title('Final Extracted Signal','color','b')
subplot(3,1,2)
plot(t_new,Y_2(1:length(Y_2)-1));
xlabel('Time','color','r')
ylabel('Amplitude','color','r')
title('Envelope Detector Output','color','b')
subplot(3,1,3)
plot(t_new,X_c2);
xlabel('Time','color','r')
ylabel('Amplitude','color','r')
title('Modulated Signal As input of Env Det.','color','b')
suptitle('Signal 1 (u = 0.2)')
% for signal 2
m = 0;
Y_3 = zeros(length(X_c3)+1,1);
Y_3(1)=X_c3(1);
for i = 1 : length(X_c3) - 1;
   
    if X_c3(i)>Y_3(i)
        diode_on = 1;
        m = 0;
        Y_3(i+1) = X_c3(i+1);
    else
        diode_on = 0;
    end 
    if diode_on == 0
        Y_3(i+1) = Y_3(i-m)*exp(-(m+1)*dt*140*40);
        m = m + 1;
    end
end
Y_3 = Y_3 - mean(Y_3); % DC Block
h = 2*pi*6000.*exp(-2*pi*6000.*t_new);% Low Pass filter Impulse Response
Y_33 = (0.5)^-1 *conv(Y_3,h)/1e8;% Compensating for u=0.5 and low passing
figure
subplot(3,1,1)
plot(t_new,Y_33(1:length(t_new)))
xlabel('Time','color','r')
ylabel('Amplitude','color','r')
title('Final Extracted Signal','color','b')
subplot(3,1,2)
plot(t_new,Y_3(1:length(Y_3)-1));
xlabel('Time','color','r')
ylabel('Amplitude','color','r')
title('Envelope Detector Output','color','b')
subplot(3,1,3)
plot(t_new,X_c3);
xlabel('Time','color','r')
ylabel('Amplitude','color','r')
title('Modulated Signal As input of Env Det.','color','b')
suptitle('Signal 2 (u=0.5)')
% for signal 3
m = 0;
diode_on = 0;
Y_4 = zeros(length(X_c4)+1,1);
Y_4(1)=X_c4(1);
for i = 1 : length(X_c4) - 1;
   
    if X_c4(i)>Y_4(i)
        diode_on = 1;
        m = 0;
        Y_4(i+1) = X_c4(i+1);
    else
        diode_on = 0;
    end 
    if diode_on == 0
        Y_4(i+1) = Y_4(i-m)*exp(-(m+1)*dt*140*40);
        m = m + 1;
    end
end
Y_4 = Y_4 - mean(Y_4); % DC Block
h = 2*pi*6000.*exp(-2*pi*6000.*t_new);% Low Pass filter Impulse Response
Y_44 = (0.9)^-1 *conv(Y_4,h)/1e8;% Compensating for u=0.9 and low passing
figure
subplot(3,1,1)
plot(t_new,Y_44(1:length(t_new)))
xlabel('Time','color','r')
ylabel('Amplitude','color','r')
title('Final Extracted Signal','color','b')
subplot(3,1,2)
plot(t_new,Y_4(1:length(Y_4)-1));
xlabel('Time','color','r')
ylabel('Amplitude','color','r')
title('Envelope Detector Output','color','b')
subplot(3,1,3)
plot(t_new,X_c4);
xlabel('Time','color','r')
ylabel('Amplitude','color','r')
title('Modulated Signal As input of Env Det.','color','b')
suptitle('Signal 3 (u=0.9)')
%% Result asked in part f
close all
clc

figure
subplot(3,1,1)
plot(t_new,Y_22(1:length(t_new)),'b')
hold on
plot(t_new,X,'r')
xlabel('Time','color','r')
ylabel('Amplitude','color','r')
title('Signal 1 (u=0.2)','color','b')
subplot(3,1,2)
plot(t_new,Y_33(1:length(t_new)),'b')
hold on
plot(t_new,X,'r')
xlabel('Time','color','r')
ylabel('Amplitude','color','r')
title('Signal 2 (u=0.5)','color','b')
subplot(3,1,3)
plot(t_new,Y_44(1:length(t_new)),'b')
hold on
plot(t_new,X,'r')
xlabel('Time','color','r')
ylabel('Amplitude','color','r')
title('Signal 3 (u=0.9)','color','b')
%% Part g

close all
clc
dt = 500000^(-1);
t = dt : dt : 0.001 ;
X = sin(2*pi*5000.*t);
X_c1 = cos(2*pi*140*1000.*t).*X;
h = 2*pi*6000.*exp(-2*pi*6000.*t);
X_c1_Demod = X_c1.*cos(2*pi*140*1000.*t + pi/10);
Y = 0.5*conv(X_c1_Demod,h)/500000;
Y_1 = Y(1 : 1+length(Y)/2);% adjusting for proper display
figure
subplot(2,1,1)
plot(t,Y_1);
title('Demodulated Signal (DSB)','color','r');
subplot(2,1,2)
plot(t,X);
title('Original Signal','color','r');
suptitle('Original and Demodulated(DSB) Signal')
figure
plot(t,Y_1,'b');
title('Demodulated Signal (DSB) and Original Signal','color','r');
hold on
plot(t,X,'r');
figure
text(0.05,0.58,'Phase Mismatchs of small quantities will not spoil the signal badly','color','b');
text(0.05,0.54,'and the effect of 2w_c is removed by low pass filter as well. Amplitude','color','b')
text(0.05,0.5,'of the output signal is weakend due to the effect of 0.5cos(phi)','color','b')
text(0.05,0.46,'It also causes a delay at the output signal from the input signal','color','b')
%% Part h
clc
close all

X_c1_Demod = X_c1.*cos(2*pi*140.5*1000.*t);% synchronous demodulation
Y = 0.5*conv(X_c1_Demod,h)/500000;% low passing
Y_1 = Y(1 : 1+length(Y)/2);% adjusting for proper display
figure
subplot(2,1,1)
plot(t,Y_1);
title('Demodulated Signal (DSB)','color','r');
subplot(2,1,2)
plot(t,X);
title('Original Signal','color','r');
suptitle('Original and Demodulated(DSB) Signal')
figure
plot(t,Y_1,'b');
title('Demodulated Signal (DSB) and Original Signal','color','r');
hold on
plot(t,X,'r');
figure
text(0.01,0.58,'Frequency Mismatch will cause phase reversal which is a crucial problem','color','b');
text(0.01,0.54,'and must be avoided. It also causes time variant variations of amplitude','color','b')
text(0.01,0.50,'casuing the intense difference of the output and input, thus this method','color','b')
text(0.01,0.46,'of demodulation''s performance is highly dependent on how well transmitter','color','b')
text(0.01,0.42,' carrier frequency and receiver carrier frequency are matched. So this method','color','b')
text(0.01,0.38,'is not a robust method and must be raplaced by a practically more robust','color','b')
text(0.01,0.34,' method. It also causes the output to have a delay from the input signal.','color','b')