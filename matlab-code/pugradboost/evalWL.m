function evlDat  = evalWL(wl,data)
% EVALWL evaluate the label for the data that the weak learner yields
    if wl.pol >0
        evlDat = (2.*( data(:,wl.coord) >  wl.theta ) - 1);
    else
        evlDat = (2.*( data(:,wl.coord) <  wl.theta ) - 1);
    end
end
