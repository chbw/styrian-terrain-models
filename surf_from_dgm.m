% Create heightmap data for openscad from a "Digitales Geländemodell"
%
% Download the raw data from the URL below, extract it and put it alongside
% this script.
% https://www.data.gv.at/katalog/dataset/land-stmk_digitalesgelndemodell10m/resource/2ca645a0-237b-4955-b2ed-c6b1ccc89418
%
% You need octave and openscad as software tools and a 3D printer.

% Make sure we have filter2.
pkg load signal;
% Start from a clean slate.
clear all;

% Load raw data, row offset is 6 (skips header information).
data = dlmread('ALS_DGM_10M_BMNM34.asc',' ',6,0);

% Clip the non-valid data points to elevation 0 to have a reasonable
% dynamic range for imshow below.
data2 = data.*(data>0);

% Optional: show the data to determine area of interest.
% Zoom to the area of interest, take a note of the axis range and use it
% below to select the area of interest.
figure(1);clf;
imshow(data2./max(data2(:)));
axis("on");

% Select area of interest
data3 = data2(6200:6700,5500:6200);
figure(2);clf;
imshow(data3./max(data3));

% The full resolution may be too high for openscad or (more likely) the slicer.
% Smooth and downsample the elevation data for further processing by a factor
% of "boxwidth".
boxwidth = 5;
kernel = ones(boxwidth,boxwidth);
kernel = kernel./sum(kernel(:));
data4 = filter2(kernel,data3,"valid");
% Scale with the downsampling factor to keep the ratio constant.
% Flip the y-Axis (from graphics mode to coordinate mode)
data4 = data4(end:-boxwidth:1,1:boxwidth:end)./boxwidth;
% Display the surface for inspection.
figure(3);clf;
surf(data4);
% Export for use with openscad.
dlmwrite('snippet.surf',data4,' ');
