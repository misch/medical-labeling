function [rescaled] = rescale_data(data)
% RESCALE_DATA rescale the features such that all the values lie within [0,1]

rescaled = (data - repmat(min(data),size(data,1),1)) ./(repmat(max(data) - min(data), size(data,1),1)+0.0001);