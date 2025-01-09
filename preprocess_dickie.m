function xp=preprocess_dickie(sig, sig2, time)
    F = 10E3;
    for i=1:1:15
        A = (normalize(sig2, "range", [0 1]));
        B = 1:1:length(sig2);
        C = B(A>0.8);
        start_idx = C(1)+2E-6/(time(2)-time(1))+(i-1)*(1/(9.8E3*(time(2)-time(1))));
        end_idx = start_idx + (1/(2*F))/(time(2)-time(1));
        ss1 = sig(round(start_idx+100):round(end_idx-100));
        
        sv1 = sig(round(end_idx+100):round(end_idx+ 1/(2*F)/(time(2)-time(1))-100));
        dt = 5E-9;
        dt_scope = time(2)-time(1);
        n = round(dt/dt_scope);
        ssint = arrayfun(@(i) sum((ss1(i:i+n-1))), 1:n:length(ss1)-n+1)';       
        svint = arrayfun(@(i) sum((sv1(i:i+n-1))), 1:n:length(sv1)-n+1)';
        %v(i) = var(svint);
        xp(i, :) = (ssint-mean(ssint)+abs(mean(ssint)-mean(svint)))*sqrt(1/(4*var(svint)));
    end

end
