function [segments] = getSuperPixels(image,size,regularizer)
    vl_feat_path = '../../vlfeat/toolbox/';
    run([vl_feat_path,'vl_setup.m']);
    
    segments = vl_slic(image, size, regularizer);