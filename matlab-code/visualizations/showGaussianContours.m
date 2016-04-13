% Show the countours of the used Gaussians for synthetic data generation

mu1a = [2 3];   Sigma1a = [.7 .2; .2 .5];
mu1b = [4.5 2]; Sigma1b = [.2 0; 0 .2];
mu2  = [2 1.5]; Sigma2 = [.6 .1; .1 .7];

x = -0:.1:6; %// x axis
y = -0:.1:4.5; %// y axis

[X Y] = meshgrid(x,y); %// all combinations of x, y
Z1a = mvnpdf([X(:) Y(:)],mu1a,Sigma1a); %// compute Gaussian pdf
Z1a = reshape(Z1a,size(X)); %// put into same size as X, Y

Z1b = mvnpdf([X(:) Y(:)],mu1b,Sigma1b); %// compute Gaussian pdf
Z1b = reshape(Z1b,size(X)); %// put into same size as X, Y

Z2 = mvnpdf([X(:) Y(:)],mu2,Sigma2); %// compute Gaussian pdf
Z2 = reshape(Z2,size(X)); %// put into same size as X, Y


% surf(X,Y,Z) %// ... or 3D plot
figure(1);
contour3(X,Y,Z1a), axis equal  %// contour plot; set same scale for x and y...
hold on; contour3(X,Y,Z1b);
hold on; contour3(X,Y,Z2);

f1 = figure(2);
surf(X,Y,Z1a), %axis equal  %// contour plot; set same scale for x and y...
hold on; surf(X,Y,Z1b);
hold on; surf(X,Y,Z2);

f2 = figure(3);
contour(X,Y,Z1a), axis equal  %// contour plot; set same scale for x and y...
hold on; contour(X,Y,Z1b);
hold on; contour(X,Y,Z2);