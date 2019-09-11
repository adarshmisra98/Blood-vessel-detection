clear;
clc;

%=======================================================================
%===============Extracting green channel from input image===============
%=======================================================================
image = imread('02_test.tif');
[r, g, b] = imsplit(image);
bw = adapthisteq(g);
%=======================================================================


%=======================================================================
%===========Opening by reconstruction (Erosion and Dilation)============
%=======================================================================
SE = strel('disk',5);
%SE = strel('square',5);
marker = imerode(bw,SE);
mask = bw;
mid = imreconstruct(marker,mask);
%======================================================================



%=======================================================================
%=========================Top hat transform=============================
%=======================================================================
mid = imbothat(mid, SE);
%mid = 255 - mid;
mid = adapthisteq(mid);
%=======================================================================



%=======================================================================
%=========================Matched Filtering=============================
%=======================================================================
img = im2double(mid);
s = 1.5; %sigma
L = 7;
theta = 0:15:360; %different rotations
out = zeros(size(img));
m = max(ceil(3*s),(L-1)/2);
[x,y] = meshgrid(-m:m,-m:m); % non-rotated coordinate system, contains (0,0)
for t = theta
   t = t / 180 * pi;        % angle in radian
   u = cos(t)*x - sin(t)*y; % rotated coordinate system
   v = sin(t)*x + cos(t)*y; % rotated coordinate system
   N = (abs(u) <= 3*s) & (abs(v) <= L/2); % domain
   k = exp(-u.^2/(2*s.^2)); % kernel
   k = k - mean(k(N));
   k(~N) = 0;               % set kernel outside of domain to 0
   res = conv2(img,k,'same');
   out = max(out,res);
end
out = out/max(out(:));



%=======================================================================
%======================Local Entropy Thresholding=======================
%=======================================================================
out2 = uint8(255*out);
%[threshold, final] = maxentropie(out2);
for i = 1:size(out,1)
    for j = 1:size(out,2)
       if out(i,j) < (78/2*255)
           out(i,j)=1;
       else
           out(i,j)=0;
       end
    end
end
out = uint8(255*out);
output = out;


%=======================================================================
%==============================Filtering================================
%=======================================================================
finalOutput = filterImage(out);
stel = strel('disk',1);
finalOutput = imerode(finalOutput,stel);
figure, montage({img,finalOutput});
%imshow(finalOutput);




