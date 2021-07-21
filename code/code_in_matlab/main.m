clear
clc
profile on
 
bandwidth = 1;
%% load the data

load("./data/data1.mat");
data_load = data1;

one=data_load(:,1).*cos(data_load(:,2)); %tranfer the data from [r, theta] to [x,y]
two=data_load(:,1).*sin(data_load(:,2));
len = length(one);
x=zeros(len,2);

x(:,2)=data_load(:,1); %only use "r" in Mean shift
x=x';

%% Mean Shift
tic
[clustCent,point2cluster,clustMembsCell] = MeanShiftCluster(x,bandwidth);
% clustCent：the center D*K, point2cluster：result label, 1*N
toc
%% Plot

x(1,:)=one;
x(2,:)=two;

numClust = length(clustMembsCell);
figure(2),clf,hold on
cVec = 'bgrcmykbgrcmykbgrcmykbgrcmyk';%, cVec = [cVec cVec];
for k = 1:min(numClust,length(cVec))
    myMembers = clustMembsCell{k};
    myClustCen = clustCent(:,k);
    fprintf('the mean value of the %d cluster is (%f,%f)\n',k,mean(x(1,myMembers)),mean(x(2,myMembers)))
    fprintf('the covariance value of the %d cluster is ',k)
    cov([x(1,myMembers);x(2,myMembers)]')
    plot(x(1,myMembers),x(2,myMembers),[cVec(k) '.'])
    plot(mean(x(1,myMembers)),mean(x(2,myMembers)),'o','MarkerEdgeColor','k','MarkerFaceColor',cVec(k), 'MarkerSize',10)
end
title(['numClust:' int2str(numClust)])