% VPI demo code
%-------------------------------------------------------------
% Setting the target and input images (I_or and I_in,  resp.)
%-------------------------------------------------------------
s=2; % scale factor
cc=0; %case
%------Case 1 the input image is given
if cc==1 
    I_in=imread('1640882.bmp');
    I_or=imresize(I_in,s);
    % additional test
    t1=0.1; %optimal value of the other case
    I_or1=VPI_unsupervised(I_in,t1,s); 
 else
%------Case the target image is given
    I_or=imread('1640882.bmp');
    I_in=imresize(I_or,1/s);
    % additional test
    t1=0.55;  %optimal value of the other case
    I_or1=VPI_unsupervised(I_in,t1,s);
end
%-------------------------
% Calling VPI_supervised
%--------------------------
[I_out, MSE, theta_opt] = VPI_supervised(I_in,I_or);
p=psnr(I_out,I_or);
Case=cc
[s p theta_opt]
% additional test results
p1=psnr(I_or, I_or1);
[p1 t1]
%----------------------------------
% Save the resized and target images 
%---------------------------------
imwrite(I_out,'img_resized.png','png');
imwrite(I_or,'img_target.png','png');
% figure 
% imshow('img_resized.png')
