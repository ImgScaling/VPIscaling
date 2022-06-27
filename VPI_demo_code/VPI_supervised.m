% VPI method for image resizing based on Chebyshev 1st kind zeros,
% Matlab function 
%%%%%%%%%% SUPERVISED VERSION %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
% I_in -> input image (gray level or RGB)
% I_or-> resized image (real final image to reach)

% OUTPUT
% I_fin-> output resized image by optimazed THETA VPI method 
% MSE(I_fin, I_or)
% theta_fin= optimal theta tested for theta_vec=[0:0.05:kmax/10]
% By default kmax=9.5 -> theta=[0,0.05,0.1,0.15,0.2,...,0.95]
% but it works also for kMAX=10 including the limit (Fejer) case theta=1 

% Routines: immse e idct by Matlab
%--------------------------------------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2022, 
% Donatella Occorsio, Giuliana Ramella, Woula Themistoclakis
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this Software and associated documentation files, to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% In case results obtained with the present software, or parts of it, are
% published in a scientific paper, the following reference should be cited:
%-------------------------------------------------------------------------
% D. Occorsio, G. Ramella, W. Themistoclakis, "Image scaling by de la 
% Vall�e-Poussin filtered interpolation", 
%-------------------------------------------------------------------------
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [I_fin, MSE, theta_fin]= VPI_supervised(I_in,I_or)
[n1,n2,c]=size(I_in);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Computing the new size N1xN2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[N1,N2,c1]=size(I_or);
if c1==c
   special=0;
   if N1<n1 && rem(n1/N1,2)==1 && N2<n2 && rem(n2/N2,2)==1
        special=2; ss=[n1/N1, n2/N2];
    end
else
   special=1; %error indicator about the image color
end
switch special
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Special cases: Downscaling with odd scale factors or input errors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 1 
       fprintf('Input parameter not adequate\n'); 
  case 2
      I_fin=I_in((ss(1)*(2*(1:N1)-1)+1)/2,(ss(2)*(2*(1:N2)-1)+1)/2,:); 
      MSE = immse(I_or, I_fin);
      theta_fin=0;
  case 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Downscaling/Upscaling in non special cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I_in=double(I_in);
eta=(2*(1: N1)-1)*pi/(2*N1); csi=(2*(1: N2)-1)*pi/(2*N2); 
%kMAX=10; thetaMAX=1+kMAX/10;
kMAX=9.5; thetaMAX=1+kMAX/10;
n1MAX=fix(thetaMAX*n1)-1; n2MAX=fix(thetaMAX*n2)-1;
T1=cos(([0:n1MAX])'.*eta)*sqrt(2/n1);T1(1,:)=sqrt(1/n1);
T2=cos(([0:n2MAX])'.*csi)*sqrt(2/n2);T2(1,:)=sqrt(1/n2);
%-----------------------------
% Computing the resized image in the case theta=0 (LCI)
%-----------------------------
  lx=idct(T1(1:n1,:)); ly=idct(T2(1:n2,:)); %l(i,j)=l_{n,i}(cos(s_j))
  if c==1 %%%%%%%%%%%%%%%%% grey level image
    I_fin=(lx'*I_in)*ly; I_fin=uint8(I_fin); 
  else %%%%%%%%%%%%%%%%%%%%%%%%%%% RGB Image
    I_fin(:,:,1)=(lx'*I_in(:,:,1))*ly;  %red
    I_fin(:,:,2)=(lx'*I_in(:,:,2))*ly;  %green
    I_fin(:,:,3)=(lx'*I_in(:,:,3))*ly;  %blu 
    I_fin=uint8(I_fin);
  end  
MSE = immse(I_or, I_fin);
theta_fin=0;
for k=0.5:0.5:kMAX
    theta=k/10; 
    %--------------------------------
    % Computing the basis polynomials
    %--------------------------------
    m1=fix(theta*n1); m2=fix(theta*n2);
    n1meno=n1-m1+1;n2meno=n2-m2+1;
    q1=zeros(n1,N1); q2=zeros(n2,N2);
    q1(1:n1meno,:)=T1(1:n1meno,:);
    q2(1:n2meno,:)=T2(1:n2meno,:);
    s=[m1-1:-1:1];
    q1(n1meno+1:n1,:)=((m1+s')/(2*m1)).*T1(n1-s+1,:)+...
        ((s'-m1)/(2*m1)).*T1(n1+s+1,:);
    s=[m2-1:-1:1];
    q2(n2meno+1:n2,:)=((m2+s')/(2*m2)).*T2(n2-s+1,:)+...
        ((s'-m2)/(2*m2)).*T2(n2+s+1,:);
    lx=idct(q1); ly=idct(q2); %fi(i,j)=\phi_{n,i}^m(cos(s_j))
    %-----------------------------
    % Computing the resized image
    %-----------------------------
    if c==1 %%%%%%%%%%%%%%%%% grey level image
        I_out=(lx'*I_in)*ly; I_out=uint8(I_out); 
    else %%%%%%%%%%%%%%%%%%%%%%%%%%% RGB Image
        I_out(:,:,1)=(lx'*I_in(:,:,1))*ly;  %red
        I_out(:,:,2)=(lx'*I_in(:,:,2))*ly;  %green
        I_out(:,:,3)=(lx'*I_in(:,:,3))*ly;  %blu 
        I_out=uint8(I_out);
    end 
    %----------------- 
    % Comparing MSE
    %-----------------
    MSEout = immse(I_or, I_out);
    if MSEout<MSE
     I_fin=I_out; MSE=MSEout;theta_fin=theta;
    end  
end 
end
end