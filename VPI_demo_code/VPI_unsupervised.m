% VPI method for image resizing based on Chebyshev 1st kind zeros,
% Matlab function
%%%%%%%%%%%%%%%%%%%% UNSUPERVISED VERSION %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT
% I_in -> input image (gray level or RGB)
% theta-> additional parameter (in [0,1])
% s -> scale factor (positive real number) or new size [#rows, #columns] (vector)
% OUTPUT
% I_fin-> resized image
% REQUIRED Routines: idct by Matlab
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
% Vallée-Poussin filtered interpolation", 
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
function [I_fin] = VPI_unsupervised(I_in,theta,s)
[n1,n2,c]=size(I_in);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Computing the new size N1xN2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a=length(s); special=0;
switch a
   case 1 %s= real scale factor
      %N1=fix(s*n1); N2=fix(s*n2);
      N1=round(s*n1); N2=round(s*n2);
      if s<1 && rem(1/s,2)==1
          special=1; ss=1/s;
      end
   case 2 %s=[Nrow, Ncol];
      N1=s(1);N2=s(2);
      if N1<n1 && rem(n1/N1,2)==1 && N2<n2 && rem(n2/N2,2)==1
          special=2; ss=[n1/N1, n2/N2];
      end
    otherwise
      special=3; %error indicator about the last input parameter
end
if theta<0 || theta>1
    special=4; %error indicator about the second input parameter
end
if c~=1 && c~=3
    special=5; %error indicator about the first input parameter
end
switch special
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Special cases: Downscaling with odd scale factors or input errors
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  case 1 
      I_fin=I_in((ss*(2*(1:N1)-1)+1)/2,(ss*(2*(1:N2)-1)+1)/2,:);
  case 2
      I_fin=I_in((ss(1)*(2*(1:N1)-1)+1)/2,(ss(2)*(2*(1:N2)-1)+1)/2,:);
  case 3
      fprintf('Last input parameter not adequate\n'); 
  case 4
      fprintf('Second input parameter not adequate\n'); 
  case 5
      fprintf('First input parameter not adequate\n'); 
  case 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Downscaling/Upscaling in non special cases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  eta=(2*(1: N1)-1)*pi/(2*N1); csi=(2*(1: N2)-1)*pi/(2*N2); 
%--------------------------------
% Computing the basis polynomials
%---------------------------------
  if theta==0 % LCI method
    n1MAX=n1-1; n2MAX=n2-1;
    T1=cos((0:n1MAX)'.*eta)*sqrt(2/n1);T1(1,:)=sqrt(1/n1);
    T2=cos((0:n2MAX)'.*csi)*sqrt(2/n2);T2(1,:)=sqrt(1/n2);
    lx=idct(T1); ly=idct(T2); 
  else
    m1=fix(theta*n1); m2=fix(theta*n2);
    n1MAX=n1+m1-1; n2MAX=n2+m2-1;
    q1=zeros(n1,N1); q2=zeros(n2,N2);
    T1=cos((0:n1MAX)'.*eta)*sqrt(2/n1);T1(1,:)=sqrt(1/n1);
    T2=cos((0:n2MAX)'.*csi)*sqrt(2/n2);T2(1,:)=sqrt(1/n2);
    n1meno=n1-m1+1;n2meno=n2-m2+1;
    q1(1:n1meno,:)=T1(1:n1meno,:);q2(1:n2meno,:)=T2(1:n2meno,:);
    z=[m1-1:-1:1];
    q1(n1meno+1:n1,:)=((m1+z')/(2*m1)).*T1(n1-z+1,:)+...
        ((z'-m1)/(2*m1)).*T1(n1+z+1,:);
    z=[m2-1:-1:1];
    q2(n2meno+1:n2,:)=((m2+z')/(2*m2)).*T2(n2-z+1,:)+...
        ((z'-m2)/(2*m2)).*T2(n2+z+1,:);
    lx=idct(q1); ly=idct(q2); 
  end
%-----------------------------
% Computing the resized image
%-----------------------------
  I_in=double(I_in);
  if c==1 %%%%%%%%%%%%%%%%% grey level image
    I_fin=(lx'*I_in)*ly; I_fin=uint8(I_fin); 
  else %%%%%%%%%%%%%%%%%%%%%%%%%%% RGB Image
    I_fin(:,:,1)=(lx'*I_in(:,:,1))*ly;  %red
    I_fin(:,:,2)=(lx'*I_in(:,:,2))*ly;  %green
    I_fin(:,:,3)=(lx'*I_in(:,:,3))*ly;  %blu 
    I_fin=uint8(I_fin);
  end  
end 
end