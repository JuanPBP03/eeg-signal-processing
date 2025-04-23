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

    for i = 1:(H.Ntests)
        subplot(2, H.Ntests, i);
        subjectComparisonPlot(H.Task(i));
        title("Healthy Task " + string(i));

        subplot(2, H.Ntests, i+6);
        subjectComparisonPlot(A.Task(i));
        title("ADHD Task " + string(i));

    end
end

function plotStackedEEGComparisonGrid(H, A)
    for i = 1:(H.Ntests)
        subplot(2, H.Ntests, i);
        plotStackedEEG(H.Task(i));
        title("Healthy Task " + string(i));

        subplot(2, H.Ntest, i+6);
        plotStackedEEG(A.Task(i));
        title("ADHD Task " + string(i));
    end
end
function plotPSDComparisonGrid(H, A)
    fmax = 100;
    for i = 1:(H.Ntests)
        subplot(2, H.Ntests, i);
        cmpPSD(H.Task(i));
        title("Healthy Task " + string(i));
        xlim([0, fmax]);

        subplot(2, H.Ntests, i+6);
        cmpPSD(A.Task(i));
        title("ADHD Task " + string(i));
        xlim([0, fmax]);

    end
end