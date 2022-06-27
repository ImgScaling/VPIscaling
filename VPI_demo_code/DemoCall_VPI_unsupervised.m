% VPI demo code

% Read the input image
%-------------
I_in=imread('1640882.bmp');
%I_in=imread('163064.bmp');
%
% Choose theta in [0,1]
%-----------------------
%theta=0; %LCI method
%theta=2; %invalid theta
theta=0.5;
%
% Choose the scale factor or vector size
%-----------------------------------------
% s >1 upsampling and s<1 downsampling
s=1/3;
%s=[600 613]
% Calling VPI_unsupervised
%--------------------------
I_out = VPI_unsupervised(I_in,theta,s);
% Save and show the resized image 
%---------------------------------
imwrite(I_out,'img_resized.png','png');
figure 
imshow('img_resized.png')
