function [ BS,len_x,len_y] = blocks(im1)
%BLOCKS Summary of this function goes here
%   Detailed explanation goes here

%% blocks
%clear all;
%load('im1.mat');
%thresh=0.5;

thresh=1.2*graythresh(im1);%exp3 1.2 
M=im2bw(im1,thresh);
M=1-(bwareaopen(1-M,100));
%M=imopen(imclose(1-bwareaopen(1-M,1500),ones(2,1)),ones(1,2));
M=imopen(imclose(1-bwareaopen(1-M,1000),ones(9,1)),ones(1,8));
M=1-(bwareaopen(1-M,250));imshow(M);pause(0.1)
[q w]=bwlabel(1-M);
block_stat=regionprops(q,'all');

% thresh=0.5;%1.2*graythresh(im1);%exp3 1.2 
% M=im2bw(im1,thresh);
% M=1-(bwareaopen(1-M,100));
% %M=imopen(imclose(1-bwareaopen(1-M,1500),ones(2,1)),ones(1,2));
% M=imopen(imclose(1-bwareaopen(1-M,1500),ones(7,1)),ones(1,7));
% M=1-(bwareaopen(1-M,250));imshow(M);pause(0.1)
% [q w]=bwlabel(1-M);
% block_stat=regionprops(q,'all');

% thresh=1.13*graythresh(im1);%exp3 1.2 
% M=im2bw(im1,thresh);
% M=1-(bwareaopen(1-M,100));
% %M=imopen(imclose(1-bwareaopen(1-M,1500),ones(2,1)),ones(1,2));
% M=imopen(imclose(1-bwareaopen(1-M,700),ones(9,1)),ones(1,8));
% M=1-(bwareaopen(1-M,250));imshow(M);pause(0.1)
% [q w]=bwlabel(1-M);
% block_stat=regionprops(q,'all');

%% 
BS=zeros(w,8);
for ii= 1:w
 BS(ii,[1 2])=block_stat(ii).Centroid ;
 m1=(mean(block_stat(ii).FilledImage));
 m2=(mean(block_stat(ii).FilledImage,2));
 BS(ii,[3 4])=[sum(m1>0.5) sum(m2>0.5)];
 BS(ii,5:end)=block_stat(ii).BoundingBox;  
end
figure(1);
imshow(im1);hold on;
%% label
BS=sortrows(BS,1);
%[~,uni]=unique(floor(BS(:,1)/750));
uni=[find(diff(BS(:,1))>50);w];
len_x=length(uni);
len_y=round(w/length(uni));
t=0;
for k=1:length(uni)
    BS(t+1:uni(k),:)=sortrows(BS(t+1:uni(k),:),2);
    t=uni(k);    
end

for i = 1: w
rectangle('Position',BS(i,5:end),'EdgeColor',[1 0 0],'linewidth',2);hold on;
pause(0.1);
end
hold off;
close(figure(1))
end

