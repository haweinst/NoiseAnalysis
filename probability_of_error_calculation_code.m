%Find probability of error given two data sets, one for a set with ASE and
%one for a coherent state set 

close all;
clear all;
%directory where signal files are kept 
D = "C:\Users\haley\OneDrive - USC ISI\Documents\variance measurement\";

%preallocate lists for coherent vs. ase datasets
xp = [];
xpnoamp = [];

%choose span of number of samples to use to calculate variance
ns=100:100:1E5;
%choose mean photon numbers
meanphotons = [1 10];
pe = zeros(1, length(ns));
id = 0;

for mp = meanphotons
    id = id + 1;
    xp = [];
    xpnoamp = [];
    for s=1:1:9
        fname = sprintf("ASE_meanphoton%i_%i", mp, s);
        fname2 = sprintf("coherentmeanphoton%i_%i", mp, s);
        load(fullfile(D, fname))
        xpn = preprocess_dickie(signals(1, :), signals(2, :), time);
        xp=[xp xpn];
        load(fullfile(D, fname2))
        xpn = preprocess_dickie(signals(1, :), signals(2, :), time);
        xpnoamp=[xpnoamp xpn];
        
    end
    [a, b] = size(xpnoamp);
    xpnoamp = reshape(xpnoamp, 1, a*b);
    xp = reshape(xp, 1, a*b);
    i = 0;
    
    
    %ns = 1E3;
    for n=ns
        noampdist =  (arrayfun(@(i) var(xpnoamp(i:i+n-1)),1:n:length(xpnoamp)-n+1)'); 
        ampdist = (arrayfun(@(i) var(xp(i:i+n-1)),1:n:length(xp)-n+1)');
        decision_threshold = abs(mean(noampdist)-mean(ampdist))/2+mean(noampdist);
        pcd = sum(noampdist<decision_threshold)/length(noampdist);
        pfa = sum(ampdist<decision_threshold)/length(ampdist);
        i = i + 1;
        pe(id, i) = pfa/2+(1-pcd)/2;
    end
    loglog(ns, pe)
    hold on
end