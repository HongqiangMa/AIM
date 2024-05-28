% Example code to reproduce Supplementary Figure S1

clc
clear
close all
warning('off')
addpath(genpath('./AIM'))
addpath(genpath('./DME_RCC'))
addpath(genpath('./Data'))

%% simulation with image size from 128x128 to 2048x2048
for r=1:16
    
driftRMS = 0.002; % pixel/frame, root mean square drift, 20 nm/s (100fps)
frameNUM = 20000; % 20000 frames, 200s (100fps)
imSize = 128*r % image size from 128x128 to 2048x2048 pixels
density = 0.03; % 0.03 localizations/um2
precision = 0.1; % 0.1 pixels, 10 nm
pixelsize = 100; % 100 nm

[F,X,Y,Z,driftXT,driftYT,driftZT] = simulationSMLM(driftRMS,frameNUM,imSize,density,precision);


%% data orgnization
dimensions = 3;

%% transfer the unit of localization position to pixels if the original unit is nanometer.
Localizations(:,1) = F;  % unit: frame
Localizations(:,2) = X;  % unit: pixel, 100nm/pixel
Localizations(:,3) = Y;  % unit: pixel, 100nm/pixel
Localizations(:,4) = Z;  % unit: pixel, 100nm/pixel


%% AIM drift correction
trackInterval = 20; % time interval for drift tracking, Unit: frames 
t_start = tic;
[LocAIM, AIM_Drift] = AIM(Localizations, trackInterval);
AIM_time(r) = toc(t_start);

% precision 
AIM_X_precision(r) = std(driftXT-AIM_Drift(:,1)');
AIM_Y_precision(r) = std(driftYT-AIM_Drift(:,2)');
AIM_Z_precision(r) = std(driftZT-AIM_Drift(:,3)');

clear Localizations
end
% plot
loglog(128*[1:16],pixelsize*(AIM_X_precision+AIM_Y_precision+AIM_Z_precision)/3) 
xlabel('Image Size (pixels)')
ylabel('Precision (nm)')
