% This Is For Reading The Images From Folder
D = 'C:\Users\h p\Documents\MATLAB\Surface Crack';
S = dir(fullfile(D,'*.jpg'));
N = numel(S);
C = cell(1,N);
for k = 1:N
    C{k} = imread(fullfile(D,S(k).name));
end
% The Images Are Stored In A Matrix Called C %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Transforming Image From RGB To Gray
gray_images = cell(1,N);
for k = 1:N
    gray_images{k} = rgb2gray(C{k});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Remove Noise From Pictures

de_noise = cell(1,N);
for k = 1:N
    f = 1/16*[1 2 1;2 4 2;1 2 1];
    de_noise{k} = filter2(f,gray_images{k},'full');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adding Median Filter

median_images = cell(1,N);
for k = 1:N
    median_images{k}=ordfilt2(gray_images{k},13,ones(5,5));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Enhancements Of Image 

sharp_mask = fspecial('laplacian');
resulted_filter = cell(1,N);
result_sharp = cell(1,N);
for k = 1:N
  resulted_filter{k} = filter2(sharp_mask,median_images{k},'full');
end

for k = 1:N
    result_sharp{k} = imfuse(median_images{k},resulted_filter{k});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sharpening The Image

mask = fspecial('laplacian');
sharpened_img = cell(1,N);
sharpen_mask = cell(1,N);
for k = 1:N
    sharpen_mask{k} = filter2(mask,median_images{k});
    sharpened_img{k} = uint8(sharpen_mask{k}) + uint8(median_images{k});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Segementation Of The Images To Extract The Borders
% Converting to Binary make better results 
binary_img = cell(1,N);
for k = 1:N
    binary_img{k} = im2bw(sharpened_img{k});
end

segemented_images = cell(1,N);
for k = 1:N
    segemented_images{k} = edge(binary_img{k},'sobel');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This Code Is For Showing All Processing Done On The Images

f = figure;
f.Position(1:2) = [200 -10];
f.Position(3:4) = [800 700];
number = 1;
figure(number);
for i = 1:N 
    if mod(i,5) == 0
        subplot(5,8,33);imshow(C{i});title('Original Image');
        subplot(5,8,34);imshow(gray_images{i});title('Grey Image');
        subplot(5,8,35);imshow(de_noise{i}/256);title('Weight Average');
        subplot(5,8,36);imshow(median_images{i});title('Median Filter');
        subplot(5,8,37);imshow(sharpened_img{i});title('Sharpened');
        subplot(5,8,38);imshow(result_sharp{i});title('More Details');
        subplot(5,8,39);imshow(segemented_images{i});title('Segementation');
        subplot(5,8,40);histogram(sharpened_img{i});title('Depth Histogram');
        
        
    else
        subplot(5,8,(mod(i,5)*8)-7);imshow(C{i});title('Original Image')
        subplot(5,8,(mod(i,5)*8)-6);imshow(gray_images{i});title('Grey Image');
        subplot(5,8,(mod(i,5)*8)-5);imshow(de_noise{i}/256);title('Weight Average');
        subplot(5,8,(mod(i,5)*8)-4);imshow(median_images{i});title('Median Filter');
        subplot(5,8,(mod(i,5)*8)-3);imshow(sharpened_img{i});title('Sharpened');
        subplot(5,8,(mod(i,5)*8)-2);imshow(result_sharp{i});title('More Details');
        subplot(5,8,(mod(i,5)*8)-1);imshow(segemented_images{i});title('Segementation');
        subplot(5,8,(mod(i,5)*8));histogram(sharpened_img{i});title('Depth Histogram');
        
        
      
    end
    if i >= N
        break;
    end    
    if floor(i/5) >= number
        f = figure;
        f.Position(1:2) = [200 -10];
        f.Position(3:4) = [800 700];
        number = floor(i/5)+1;
        figure(number)
    end  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
