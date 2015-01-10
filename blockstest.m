%% blocks
%clear all;
load('im1.mat');
thresh=0.5;
M=im2bw(im1,thresh);
M=1-(bwareaopen(1-M,100));
M=imopen(imclose(1-bwareaopen(1-M,2000),ones(5,1)),ones(1,5));
M=1-(bwareaopen(1-M,400));
[q w]=bwlabel(1-M);
block_stat=regionprops(q,'all');

%%
BS=zeros(w,8);
for ii= 1:w
 BS(ii,[1 2])=block_stat(ii).Centroid ;
 m1=(mean(block_stat(ii).FilledImage));
 m2=(mean(block_stat(ii).FilledImage,2));
 BS(ii,[3 4])=[sum(m1>0.5) sum(m2>0.5)];
 BS(ii,5:end)=block_stat(ii).BoundingBox;  
end
imshow(im1);hold on;
%% label
BS=sortrows(BS,1);
%[~,uni]=unique(floor(BS(:,1)/750));
uni=[find(diff(BS(:,1))>50);w];
t=0;
for k=1:length(uni)
    BS(t+1:uni(k),:)=sortrows(BS(t+1:uni(k),:),2);
    t=uni(k);    
end

for i = 1: w
rectangle('Position',BS(i,5:end));hold on;
pause();
end