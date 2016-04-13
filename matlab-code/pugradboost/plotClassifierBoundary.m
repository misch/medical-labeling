function plotClassifierBoundary(R,C,classif)
figure(4);
MAP = zeros(R,C);

for r=1:R
    for c=1:C
        CC   = [c,r]*0.1;
        for m=1:length(classif)
            MAP(r,c)  = MAP(r,c) + classif{m}.alpha.*evalWL(classif{m}.wl,CC);
        end
    end
end
    
imagesc(MAP);
axis xy
colorbar