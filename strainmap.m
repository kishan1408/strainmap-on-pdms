clear all;
close all;tic;
warning('off','all')
warning
prompt = {'Folder','file type','Elongations in each step (in mm)','Direction of Stretch'};
dlg_title = 'Import image';
num_lines = 1;
def = {'exp1','tif','1','x'};
response = inputdlg(prompt,dlg_title,num_lines,def);

toc;
%% Scale (in um/pixel)
S = 5000/236 ;
%% Read  1st image without strain
file=dir(strcat(response{1},'/*.',response{2}));
%im1= rgb2gray(imread(strcat(response{1},'/',file(1).name)));
im1= (imread(strcat(response{1},'/',file(1).name)));

% RoI selection 
disp('Select RoI in image 1');
imshow(im1);h=imrect;pause();
im1=imcrop(im1,h.getPosition);
pos0=h.getPosition;
close figure 1
imshow(im1);
%clear im1;
h=waitbar(0);
%%
for i = 1 : length(file)
    waitbar(i/length(file),h,strcat('Extracting Blocks from image',num2str(i)));
    pos=pos0;toc;
   % im_= rgb2gray(imread(strcat(response{1},'/',file(i).name)));
    im_= (imread(strcat(response{1},'/',file(i).name)));
    if response{4}=='x';   
        pos(3)=pos(3)+ ceil(str2double(response{3})*i*1000/S);
    end
    if response{4}=='y';   
        pos(4)=pos(4)+ ceil(str2double(response{3})*i*1000/S);
    end
    im__=imcrop(im_,pos);
    [im_,lenx,leny]=blocks(im__);
   
        
    b(i).xcoord=(im_(:,1));
    b(i).ycoord=(im_(:,1));
    b(i).x=(im_(:,3));
    b(i).y=(im_(:,4));
end
by=zeros(length(b(1).y),length(file));
bx=zeros(length(b(1).y),length(file));
for j=1:length(file)
    by(:,j)= b(j).y;
    bx(:,j)=b(j).x;
end
ex=(bx-repmat(bx(:,1),1,length(file)))./repmat(bx(:,1),1,length(file));
ey=(by-repmat(by(:,1),1,length(file)))./repmat(by(:,1),1,length(file));
%%
for i =1:length(file)
strain(i).x=reshape(ex(:,i),leny,lenx);
strain(i).paramx=[min(min(strain(i).x)),max(max(strain(i).x)),mean2(strain(i).x),std(strain(i).x(:))];
strain(i).y=reshape(ey(:,i),leny,lenx);
strain(i).paramy=[min(min(strain(i).y)),max(max(strain(i).y)),mean2(strain(i).y),std(strain(i).y(:))];
end
%%
cd(response{1});
mkdir colormapx
cd colormapx
for i =1:length(file)
figure(i);
imagesc(strain(i).x,[-1 1]);
colorbar;xlabel('x axis(direction of stretch)');ylabel('y axis (direction perpendicular to stretch)');title(sprintf('Color map of localized strain in x direction for %d mm stretch of 16mm x 12mm PDMS',i ))
eval(['print -djpeg99 '  num2str(i)]);
close(figure(i));
end
cd ..
mkdir colormapy
cd colormapy
for i =1:length(file)
figure(i);
imagesc(strain(i).y,[-1 1]);colorbar;xlabel('x axis(direction of stretch)');ylabel('y axis (direction perpendicular to stretch)');title(sprintf('Color map of localized strain in y direction for %d mm stretch of 16mm x 12mm PDMS',i ))
eval(['print -djpeg99 '  num2str(i)]);
close(figure(i));
end
cd .. 
%%

mkdir boxplot;
cd boxplot;
figure(1);
digits(2);
boxplot(abs(ex),'label',num2cell(0:1/16:(length(file)-1)/16),'labelorientation','inline');
eval(['print -djpeg99 ' 'boxplotx' num2str(1)]);
close(figure(1));

figure(1);
boxplot(abs(ey),'label',num2cell(0:1/16:(length(file)-1)/16),'labelorientation','inline');
eval(['print -djpeg99 ' 'boxploty' num2str(1)]);
close(figure(1));
cd ..

%%
stdx=[];stdy=[];meanx=[];meany=[];
for i = 1:length(file)
stdx(end+1)=std(strain(i).x(:));
stdy(end+1)=std(strain(i).y(:));
meanx(end+1)=mean(strain(i).x(:));
meany(end+1)=mean(strain(i).y(:));
end

mkdir errorbar;
cd errorbar
figure(1);
errorbar(0:1/16:(length(file)-1)/16,meanx,stdx,'.-');
xlim([0 0.6]);
ylabel('Localized strain') ;
xlabel('Strain') 
hold on;
errorbar(0:1/16:(length(file)-1)/16,meany,stdy,'o-r');xlim([0 0.6]);
plot(0:1/16:(length(file)-1)/16,0:1/16:(length(file)-1)/16,'*-g')
legend('Average localised strain along x axis ; Error bar = 2*SD','Average localised strain along x axis ; Error bar = 2*SD','Strain');
eval(['print -djpeg99 ' 'errorplot' num2str(1)]);
pause();close(figure(1));
cd ..
%%
mkdir meanstd
cd meanstd
figure(1)
for i =1:length(file)
errorbar(0:2:2*(length(file)),mean(strain(i).x),std(strain(i).x),'o-r','linewidth',1),
xlabel('Position (in mm)');
ylabel('Average Localized Strain ');

xlim([0 2*length(file)]);
ylim([-1 1]);
eval(['print -djpeg99 ' 'errorplot' num2str(i)]);
end
cd ..
close(h);


% % case = yes
% if ans_1==1
% if response{4}=='x';   
% pos(3)=pos(3)+ ceil(str2double(response{3})*1000/S);
% end
% if response{4}=='y';   
% pos(4)=pos(4)+ ceil(str2double(response{3})*1000/S);
% end
% im2=imcrop(im2,pos);
% end


%%
% %% Read Image
% im1= rgb2gray(imread(response{1}));
% im2= rgb2gray(imread(response{2}));

%% Region of Interest (Roi)

% 
% % 
% choice = questdlg('Do you want to select Roi based on strain (select no for Manual ROI selection)', ...
% 	'RoI', ...
% 	'Yes','No','No');
% % Handle response
% switch choice
%     case 'Yes'
%          ans_1 = 1;
%     case 'No'
%          ans_1 = 2;
% end
% % RoI selection 
% disp('Select RoI in image 1');
% imshow(im1);h=imrect;
% im1=imcrop(im1,h.getPosition);
% pos=h.getPosition;
% close figure 1
% imshow(im1);pause();
% % case = yes
% if ans_1==1
% if response{4}=='x';   
% pos(3)=pos(3)+ ceil(str2double(response{3})*1000/S);
% end
% if response{4}=='y';   
% pos(4)=pos(4)+ ceil(str2double(response{3})*1000/S);
% end
% im2=imcrop(im2,pos);
% end
% 
% % case = no
% if ans_1==2
% disp('Select RoI in image 2');
% imshow(im2);h=imrect;
% im2=imcrop(im2,h.getPosition);
% close figure 1
% end  
% figure;
% imshow(im2);

%%


%I =im1;I(:,:,1)=rgb2gray(im1);I(:,:,2)=rgb2gray(im2);I(:,:,3)=rgb2gray(im2);
%imshow(I)
