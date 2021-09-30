%% original data
clc
clear;
close all;
load H15_open1_position_data;

figure;

subplot(2,1,1);
plot(t, x);
xlabel('Time (ms)');
ylabel('Pixel value');
axis tight

subplot(2,1,2);
plot(t,y);
xlabel('Time (ms)');
ylabel('Pixel value');
axis tight

%% smooth x and y 

dt = median(abs(diff(t)))/1000; %%% average time difference betwen frames
filtsize = ceil(.5/dt); % half second smoothing
filter = ones([1 filtsize]); % smoothing window of about half second

filter = filter ./ sum(filter);
smooth_x = conv(x, filter, 'same');
smooth_y = conv(y, filter, 'same');
smooth_x(1:ceil(filtsize/2)) = x(1:ceil(filtsize/2)); % conv smoothing can introduce artifacts at the beginning, this removes that
smooth_y(1:ceil(filtsize/2)) = y(1:ceil(filtsize/2)); % check with and without these two lines to see the difference

%% center position data

range_x = max(smooth_x) - min(smooth_x);
range_y = max(smooth_y) - min(smooth_y);

slope_y = 80 / range_y; % diameter is 80cm
intercept_y = -40 - (slope_y * min(smooth_y)); % assume -40cm corresponds to min of y

slope_x = 80 / range_x;
intercept_x = -40 - (slope_x * min(smooth_x)); % assume -40cm corresponds to min of x

centered_x = (slope_x * smooth_x) + intercept_x;
centered_y = (slope_y * smooth_y) + intercept_y; 

%% Compute instantaneous speed & head-direction

vel_x = diff([centered_x; centered_x(end)]);
vel_y = diff([centered_y; centered_y(end)]);
speed_per_frame = sqrt(vel_x.^2 + vel_y.^2); % cm/frame

vel_t = diff([t; t(end)])./1000; % difference in seconds between subsequent frames
speed = speed_per_frame./vel_t; % cm per sec

theta = atan2d(centered_y(2:end)-centered_y(1:end-1), centered_x(2:end)-centered_x(1:end-1));
theta = cat(1, theta, NaN); 


%% plot data

fullTraj = figure;
% Movie Plot
%{
hold on
xlabel('X-position (cm)');
ylabel('Y-position (cm)');
xlim([-40 40]);
ylim([-40 40]);

for i=1:length(centered_x)
    scatter(centered_x(i), centered_y(i), 7, 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue');
    pause(0.02)
end
%}

% Regular Plot
plot(centered_x, centered_y);
xlabel('X-position (cm)');
ylabel('Y-position (cm)');
axis tight

figure;
subplot(4,1,1)
plot(t, centered_x);
ylabel('X-position (cm)');
axis tight;

subplot(4,1,2)
plot(t, centered_y);
ylabel('Y-position (cm)');
axis tight;

subplot(4,1,3)
plot(t, speed);
ylabel('Speed (cm/ms)');
axis tight;

subplot(4,1,4)
plot(t, theta);
xlabel('Time (ms)');
ylabel('Head-direction (degrees)');
axis tight;
%% Constant theta and speed > 7.5, for >=10 consecutive samples/time-points

partitions = 18;
bin_size = 360 / partitions;
bin_num = discretize(theta+180, [0:bin_size:360]);
bin_theta = (bin_num)*bin_size;

figure; 
subplot(1, 4, 1)
rose(theta, max(bin_num))
title('Distribution of head orientations')
subplot(1, 4, [2:4])
hold on; 
plot(bin_theta)
plot(theta+180); 
axis tight

% Next try to use this bin_theta and speed variables to find times were the rat is both moving more than 7.5 cm/sec and in 
% the same head direction for at least 10 samples consecutively. This should pull out instances when the rat is running in the same
% direction for a couple seconds, ideally

OpenFieldAnalysis1;
OpenFieldAnalysis2;




    