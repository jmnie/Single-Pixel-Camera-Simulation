function simliarity( Im, new_IM )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
I1=Im;
I2=new_IM;
ssimval = ssim(I1,I2);


  
    fprintf('The ssim value is %0.4f.\n',ssimval);
  
    title(sprintf('Reconstruction - simliarity is %0.4f',ssimval));

end

