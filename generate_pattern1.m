% --------------------------------------------------------
% MDP Tracking
% Copyright (c) 2015 CVGL Stanford
% Licensed under The MIT License [see LICENSE for details]
% Written by Yu Xiang
% --------------------------------------------------------
function pattern = generate_pattern1(img, bb, featsize, patchsize, model, im_mean)
% get patch under bounding box (bb), normalize it size, reshape to a column
% vector and normalize to zero mean and unit variance (ZMUV)

% initialize output variable
nBB = size(bb,2);
patches = zeros([patchsize(2), patchsize(1), 3, nBB]);
% for every bounding box
for i = 1:nBB
    % sample patch
    patches(:, :, :, i) = process(img, bb(:,i), patchsize, im_mean);
    
end

pattern = double(model.forward(patches, 'gpu', 4));

function pattern = process(img, bb, patchsize, im_mean)



x1 = int32(max([1 bb(1)]));
y1 = int32(max([1 bb(2)]));
x2 = int32(min([size(img,2) bb(3)]));
y2 = int32(min([size(img,1) bb(4)]));
patch = double(img(y1:y2, x1:x2, :));


patch = imresize(patch, patchsize); % 'bilinear' is faster
patch = permute(patch, [3, 1, 2]);
patch = patch - im_mean;
pattern = permute(patch, [3, 2, 1]);
