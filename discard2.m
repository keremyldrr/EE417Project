function [ discardedKeypoints ] = discard2( keypoints, DoG )

    thresContrast = 0.03;
    eigenRatio = 10;
    
    discardedKeypoints = zeros(1,2);

    for i=2:size(keypoints,1)
        rowCoor = max(round(keypoints(i,2)),2);
        colCoor = max(round(keypoints(i,3)),2);
        value = mat2gray(keypoints(i,7));
        
        if (abs(value) > thresContrast)
            
            % x ve y directionlari image processing'de ters! sorun cikarir
            % mi bilmiyorum. Edge detection yaptigimiz icin fark etmiyor
            % olmasi gerek
            
            fxx = DoG(rowCoor-1,colCoor) + DoG(rowCoor+1,colCoor) - 2*DoG(rowCoor,colCoor);
            fyy = DoG(rowCoor,colCoor-1) + DoG(rowCoor,colCoor+1) - 2*DoG(rowCoor,colCoor);
            fxy = DoG(rowCoor-1,colCoor-1) + DoG(rowCoor+1,colCoor+1) - DoG(rowCoor-1,colCoor+1) - DoG(rowCoor+1,colCoor-1);
            
            trace = fxx + fyy;
            deter = fxx*fyy - fxy*fxy;
            
            curvature = (trace^2)/deter;
            thresCurv = ((eigenRatio+1)^2)/eigenRatio;
            
            if (curvature < thresCurv)
                discardedKeypoints(end+1,1) = rowCoor;
                discardedKeypoints(end,2) = colCoor;
            end
        end
    end

end
