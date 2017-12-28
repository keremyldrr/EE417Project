function [features,locations]=SIFT(I)


%I=imresize(I,0.2);
I=double(rgb2gray(I));
k=sqrt(2);
sigma=1.6;
I1=imgaussfilt(I,sigma);
I2=imgaussfilt(I,k*sigma);
I3=imgaussfilt(I,k^2*sigma);
I4=imgaussfilt(I,k^3*sigma);
Ihalf=imresize(I,0.5);
Ihalf1=imgaussfilt(Ihalf,k^2*sigma);
Ihalf2=imgaussfilt(Ihalf,k^3*sigma);
Ihalf3=imgaussfilt(Ihalf,k^4*sigma);
Ihalf4=imgaussfilt(Ihalf,k^5*sigma);
Iquarter=imresize(Ihalf,0.5);
Iquarter1=imgaussfilt(Iquarter,k^4*sigma);
Iquarter2=imgaussfilt(Iquarter,k^5*sigma);
Iquarter3=imgaussfilt(Iquarter,k^6*sigma);
Iquarter4=imgaussfilt(Iquarter,k^7*sigma);

DoG1=I1-I2;
DoG2=I2-I3;
DoG3=I3-I4;
DoGHalf1=Ihalf1-Ihalf2;
DoGHalf2=Ihalf2-Ihalf3;
DoGHalf3=Ihalf3-Ihalf4;
DoGQ1=Iquarter1-Iquarter2;
DoGQ2=Iquarter2-Iquarter3;
DoGQ3=Iquarter3-Iquarter4;

extremaCoorFull = extrema(DoG1,DoG2,DoG3);
% figure;imshow(uint8(I));hold on ;plot(extremaCoorFull(2:end,2),extremaCoorFull(2:end,1),'*');

extremaCoorHalf = extrema(DoGHalf1,DoGHalf2,DoGHalf3);
% figure;imshow(uint8(Ihalf));hold on ;plot(extremaCoorHalf(2:end,2),extremaCoorHalf(2:end,1),'*');

extremaCoorQuarter = extrema(DoGQ1,DoGQ2,DoGQ3);
% figure;imshow(uint8(Iquarter));hold on ;plot(extremaCoorQuarter(2:end,2),extremaCoorQuarter(2:end,1),'*');

% discardedExtrema = discard(extremaCoorFull,DoG1);
% figure;imshow(uint8(I));hold on ;plot(discardedExtrema(2:end,2),discardedExtrema(2:end,1),'*');

%Bunlar esas keypointslerimiz
keypointsFull = interpolatedDoG(DoG1,DoG2,DoG3,extremaCoorFull,1);
discardedKeypointsFull = discard2(keypointsFull, DoG1);
%figure;imshow(uint8(I));hold on ;plot(discardedKeypointsFull(2:end,2),discardedKeypointsFull(2:end,1),'*');

keypointsHalf = interpolatedDoG(DoGHalf1,DoGHalf2,DoGHalf3,extremaCoorHalf,2);
discardedKeypointsHalf = discard2(keypointsHalf, DoGHalf1);
%figure;imshow(uint8(Ihalf));hold on ;plot(discardedKeypointsHalf(2:end,2),discardedKeypointsHalf(2:end,1),'*');

keypointsQ = interpolatedDoG(DoGQ1,DoGQ2,DoGQ3,extremaCoorQuarter,3);
discardedKeypointsQ = discard2(keypointsQ, DoGQ1);
%figure;imshow(uint8(Iquarter));hold on ;plot(discardedKeypointsQ(2:end,2),discardedKeypointsQ(2:end,1),'*');

[features1,locations1]=KeypointOrientation(DoG2,discardedKeypointsFull,16,1.6); 
[features2,locations2]=KeypointOrientation(DoGHalf2,discardedKeypointsHalf,16,2*1.6);
[features3,locations3]=KeypointOrientation(DoGQ2,discardedKeypointsQ,16,4*1.6);

locations1 = locations1(:,1:2);
locations2 = locations2(:,1:2)*2;
locations3 = locations3(:,1:2)*4;

features=[];
features=cat(2,features,features1);
features=cat(2,features,features2);
features=cat(2,features,features3);

locations=[];
locations=cat(1,locations,locations1);
locations=cat(1,locations,locations2);
locations=cat(1,locations,locations3);

end