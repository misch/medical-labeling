function [rescaled] = rescale_data(data)


rescaled = (data - repmat(min(data),size(data,1),1)) ./(repmat(max(data) - min(data), size(data,1),1)+0.0001);