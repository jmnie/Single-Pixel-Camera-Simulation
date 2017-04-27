function [Im]=ya(Img, f, g ,x)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
a = f-mod(f,x);
b = g-mod(g,x);
H=im2double(Img);

Im=imresize(H,[a b]);
end

