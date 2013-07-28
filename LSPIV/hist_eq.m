function [B1,B] = hw6 (A)

% EE 8541
% HW 1 Problem #6
% Performs histogram modification on the gray image in matrix A.
% We can get an image into matrix A using the imread command.
% First performs histogram equalization, then histogram modification
% to an exponential distribution.
% B1 is the image after histogram equalization.
% B is the image after histogram modification to exponential distribution.


A = imread ('image_test.pgm');

[m,n] = size(A);
A = double(A);
gmin = min(min(A));
gmax = max(max(A));

% Prepare the cumulative probability function Pf.
Pf = zeros(1,256);
for i = 1:m
  for j = 1:n
    f = A(i,j) + 1;
    for x = f:256
      Pf(x) = Pf(x) + 1;
    end;
  end;
end;
Pf = Pf / (m*n);

% Histogram equalization: make the histogram look uniform.
g1 = (gmax - gmin) * Pf + gmin;

% Map the image A under the new histogram to image B.
% This is so we can view the equalized image separately.
B1 = zeros(m,n);
for i = 1:m
  for j = 1:n
    B1(i,j) = g1 ( A(i,j) + 1);
  end;
end;

% % Prepare the cumulative probability function Pf again.
% Pf = zeros(1,256);
% for i = 1:m
%   for j = 1:n
%     f = round(B1(i,j)) + 1;
%     for x = f:256
%       Pf(x) = Pf(x) + 1;
%     end;
%   end;
% end;
% Pf = Pf / (m*n);
% 
% % Histogram modification: Exponential distribution.
% % The exponential transfer function is given on Pratt, p. 256.
% gmin = min(min(B1));
% alpha = 0.01;
% g2 = zeros(1,256);
% g2(:) = gmin - 1 / alpha * log( 1 - Pf(:));
% 
% % Map the image B1 under the new histogram to image B.
% B = zeros(m,n);
% for i = 1:m
%   for j = 1:n
%     B(i,j) = g2 ( round(B1(i,j)) + 1);
%   end;
% end;

%B1 = uint8(B1);
imtool(B1, [0 255])
% B = uint8(B);   % For drawing purposes.

