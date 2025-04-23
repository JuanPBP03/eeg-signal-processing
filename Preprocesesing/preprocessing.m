%% ===== Initialize Dataset Objects =====
load
fs = 256; % sample rate in Hz
testNodes = ["Cz","F4"];
H_CzF4 = EEGData(MC(1:6),testNodes,fs);
A_CzF4 = EEGData(MADHD(1:6),testNodes,fs);

%% ===== Data Visualization =====
figure(1);
plotFFTComparisonGrid(H_CzF4,A_CzF4);
figure(2);
plotStackedEEGComparisonGrid(H_CzF4,A_CzF4);
figure(3);
plotPSDComparisonGrid(H_CzF4,A_CzF4);

%% ===== Data Filtering =====
ButterHP = designfilt('highpassiir', ...
    'StopbandFrequency',0.5, ...
    'PassbandFrequency',1.5, ...
    'StopbandAttenuation',30, ...
    'PassbandRipple',1, ...
    'SampleRate',256);
ButterLP = designfilt('lowpassiir', ...
    'StopbandFrequency',45, ...
    'PassbandFrequency',40, ...
    'StopbandAttenuation',30, ...
    'PassbandRipple',1, ...
    'SampleRate',256);
HCF = H_CzF4.filteredData(ButterHP);
ACF = A_CzF4.filteredData(ButterHP);
HCFF = HCF.filteredData(ButterLP);
ACFF = ACF.filteredData(ButterLP);

%% ===== Filtered Data Comparison =====
figure(4);
plotFFTComparisonGrid(HCF,ACF);
figure(5);
plotStackedEEGComparisonGrid(HCFF,ACFF);
figure(6);
plotPSDComparisonGrid(HCFF,ACFF);

%% ===== Bulk Plotting Functions =====
function plotFFTComparisonGrid(H, A)
    tiledlayout(2,6,"Padding","compact");
    for i = 1:(H.Ntests)
        nexttile(i)
        subjectComparisonPlot(H.Task(i));
        title("Healthy Task " + string(i));

        nexttile(i+H.Ntests)
        subjectComparisonPlot(A.Task(i));
        title("ADHD Task " + string(i));

    end
end

function plotStackedEEGComparisonGrid(H, A)
tiledlayout(2,6,"Padding","compact");    
    for i = 1:(H.Ntests)
        nexttile(i)
        plotStackedEEG(H.Task(i));
        title("Healthy Task " + string(i));
        xlim([0 H.Task(i).Duration])
        nexttile(i+H.Ntests)
        plotStackedEEG(A.Task(i));
        title("ADHD Task " + string(i));
        xlim([0 A.Task(i).Duration])
    end
end
function plotPSDComparisonGrid(H, A)
    fmax = 100;
    tiledlayout(2,6,"Padding","compact");
    for i = 1:(H.Ntests)
        nexttile(i)
        cmpPSD(H.Task(i));
        title("Healthy Task " + string(i));
        xlim([0, fmax]);

        nexttile(i+H.Ntests)
        cmpPSD(A.Task(i));
        title("ADHD Task " + string(i));
        xlim([0, fmax]);

    end
end