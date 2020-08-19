%% Problem 8
close all
%% Part 1 N = 1

clc
% Frequency Response
[zero_1,poles_1,gain] = besselap(1);
[num,den] = zp2tf(zero_1,8000*pi*poles_1,8000*pi*20*gain);
figure;
freqs(num,den)
% Group Delay
figure;
grpdelay(zp2sos(tfzero,tfpole,tfgain));

% 60dB and 6dB Ratio
sys = zpk(zero_1,poles_1,gain);
band60 = bandwidth(sys,-60);
band6 = bandwidth(sys,-6);

h = freqs(num,den,500000);
[tfzero,tfpole,tfgain] = tf2zp(num,den);

% 2 Percent Deviation



%% Part 1 N = 12

clc
% Frequency Response
[zero_12,poles_12,gain] = besselap(12);
[num,den] = zp2tf(zero_12,8000*pi*poles_12,8000*pi*20*gain);
figure;
freqs(num,den)
% Group Delay
figure;
grpdelay(zp2sos(tfzero,tfpole,tfgain));

% 60dB and 6dB Ratio
sys = zpk(zero_12,poles_12,gain);
band60 = bandwidth(sys,-60);
band6 = bandwidth(sys,-6);

h = freqs(num,den,500000);
[tfzero,tfpole,tfgain] = tf2zp(num,den);

% 2 Percent Deviation

%% Part 1 N = 18

clc
% Frequency Response
[zero_18,poles_18,gain] = besselap(18);
[num,den] = zp2tf(zero_18,8000*pi*poles_18,8000*pi*20*gain);
figure;
freqs(num,den)
% Group Delay
figure;
grpdelay(zp2sos(tfzero,tfpole,tfgain));

% 60dB and 6dB Ratio
sys = zpk(zero_18,poles_18,gain);
band60 = bandwidth(sys,-60);
band6 = bandwidth(sys,-6);

h = freqs(num,den,500000);
[tfzero,tfpole,tfgain] = tf2zp(num,den);

% 2 Percent Deviation


%%
close all
clc
H1 = abs(h);
H2 = find(H1<(H1(1,1)/2^0.5));
disp(w(H2(1)))

H1 = abs(h);
H3 = find(H1<(H1(1,1)*0.251));
disp(w(H3(1)))

H1 = abs(h);
H4 = find(H1<(H1(1,1)*1e-6));
disp(w(H4(1)))

%% Problem 9

w = 1:1e-2:100;

% part 1

H1 = -1 + exp(-1i*w) - exp(-2i*w) + exp(-3i*w);
figure
subplot(2,1,1);
plot(log(w),log(abs(H1)));
title('Sequence 1','color','r');
xlabel('Frequency','color','b');
ylabel('Amplitude','color','b');
subplot(2,1,2);
plot(log(w),angle(H1));
xlabel('Frequency','color','b');
ylabel('Phase','color','b');

% part 2

H2 = -2 + exp(-1i*w) + exp(-2i*w) - 2*exp(-3i*w);
figure
subplot(2,1,1);
plot(log(w),log(abs(H2)));
title('Sequence 2','color','r');
xlabel('Frequency','color','b');
ylabel('Amplitude','color','b');
subplot(2,1,2);
plot(log(w),angle(H2));
xlabel('Frequency','color','b');
ylabel('Phase','color','b');

% part 3

H3 = 1 - 3*exp(-1i*w) - 0*exp(-2i*w) + 3*exp(-3i*w);
figure
subplot(2,1,1);
plot(log(w),log(abs(H3)));
title('Sequence 3','color','r');
xlabel('Frequency','color','b');
ylabel('Amplitude','color','b');
subplot(2,1,2);
plot(log(w),angle(H3));
xlabel('Frequency','color','b');
ylabel('Phase','color','b');

% part 4

H4 = 1 - 3*exp(-1i*w) + 2*exp(-2i*w) - 2*exp(-3i*w);
figure
subplot(2,1,1);
plot(log(w),log(abs(H4)));
title('Sequence 4','color','r');
xlabel('Frequency','color','b');
ylabel('Amplitude','color','b');
subplot(2,1,2);
plot(log(w),angle(H4));
xlabel('Frequency','color','b');
ylabel('Phase','color','b');

