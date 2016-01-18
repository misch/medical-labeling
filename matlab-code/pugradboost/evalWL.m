function evlDat  = evalWL(wl,data)
    if wl.pol >0
        evlDat = (2.*( data(:,wl.coord) >  wl.theta ) - 1);
    else
        evlDat = (2.*( data(:,wl.coord) <  wl.theta ) - 1);
    end
end
