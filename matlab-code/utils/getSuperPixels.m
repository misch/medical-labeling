function [segments] = getSuperPixels(image,size,regularizer)
% GETSUPERPIXELS get superpixels from the SLIC algorithm implemented in vlfeat
    vl_feat_path = '../../vlfeat/toolbox/';
    run([vl_feat_path,'vl_setup.m']);
    
    segments = vl_slic(image, size, regularizer);