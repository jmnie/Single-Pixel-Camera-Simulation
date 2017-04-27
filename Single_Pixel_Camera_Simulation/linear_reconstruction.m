function [ newimg ] = linear_reconstruction( o_ima, NM )
[a,b] = size( o_ima ); %get the size of the original image 
if a>b
   c=b;
else c=a; % make the length and width equal
end

H = im2double(o_ima); %change the data type of the image
ima = imresize(H,[c c]); %change the size of the image

NP=c; %use the adjusted value
MaskData=zeros(NM,NP*NP); %generate the MaskData


for i=1:NM                                               
    temp=rand(NP);
    temp=temp>0.5; %ensure the value exceeds 0.5
    MaskData(i,:)= temp(:);   
end   


    temp7=ima(:,:,1);     % decorate the dimensions 
    THzData=double(MaskData)*double(temp7(:)); %obtain the R dimension THzData
    newimg(:,:,1)=linear_rec(THzData, MaskData);  %reconstruct the R dimension
    temp7=ima(:,:,2);
    THzData=double(MaskData)*double(temp7(:));  %obtain the G dimension THzData
    newimg(:,:,2)=linear_rec(THzData, MaskData); %reconstruct the G dimension
    temp7=ima(:,:,3);
    THzData=double(MaskData)*double(temp7(:));   %obtain the B dimension THzData
    newimg(:,:,3)=linear_rec(THzData, MaskData); %reconstruct the B dimension

end

