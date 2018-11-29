%% Add path to use EEGLAB Matlab functions; Change path to your local copy of EEGLab
addpath(genpath('D:\Dropbox\119 FRACTAL ANALYSIS\119 CODE\119 MATLAB\eeglab14_1_1b'));

%% Change to filepath with files on local disk
filepathName = 'D:\\Dropbox\\119 FRACTAL ANALYSIS\\119 CODE\\119 MATLAB\\';

%% Get file(s)
myFolderInfo = dir([filepathName, '*.RAW']); 
myFolderInfo = myFolderInfo(~cellfun('isempty', {myFolderInfo.date}));

%% Read binary simple Netstation file
iFile = 1; % Get the first file
filename = myFolderInfo(iFile).name; 
EEG = pop_readegi(filename, [],[],'auto');

%% Correct delay 
EEG = correctDelay(EEG,25);

%% Edit channel locations 
myChanLocs = 'GSN-HydroCel-129.sfp';
EEG = pop_chanedit(EEG, 'load',{myChanLocs 'filetype' 'autodetect'},'setref',{'4:128' 'Cz'},'changefield',{132 'datachan' 0});

%% Re-reference and add 'Cz' back to the data
EEG = pop_reref( EEG, [],'refloc',struct('labels',{'Cz'},'Y',{0},'X',{5.4492e-16},'Z',{8.8992},'sph_theta',{0},'sph_phi',{90},'sph_radius',{8.8992},'theta',{0},'radius',{0},'type',{''},'ref',{'Cz'},'urchan',{132},'datachan',{0}));

%% Filter the data; 0.1 for low and 50 for high
EEG = pop_eegfiltnew(EEG, 0.1,50,33000,0,[],1);

%% Correct DINs
EEG.event = cleanTriggers(EEG.event);

%% Extract Epochs 
%EEG = pop_epoch( EEG, {  'DIN8'  }, [-1  1], 'newname', strrep(filename,'.RAW','_epochs'), 'epochinfo', 'yes');

%% Plot for checking
%pop_eegplot( EEG, 1, 1, 1);

%% Run ICA
%EEG = pop_runica(EEG, 'extended',1,'interupt','on');

%% Use for checking consistency of dataset
EEG = eeg_checkset(EEG);

%% Save dataset; 
EEG = pop_saveset( EEG, 'filename',strrep(filename,'.RAW','Fltrd.set'),'filepath',filepathName);

%% Calculate fractal dimensions and save the output to Excel spreadsheet
% Prepare table for output; allocate memory
tableOutput = struct2table(EEG.event);
for jChan=1:size(EEG.chanlocs,2)
    tableOutput(1, strcat(EEG.chanlocs(jChan).labels,'_CD')) = {0}; 
    tableOutput(1, strcat(EEG.chanlocs(jChan).labels,'_PK')) = {0}; 
    tableOutput(1, strcat(EEG.chanlocs(jChan).labels,'_FNN')) = {0}; 
    tableOutput(1, strcat(EEG.chanlocs(jChan).labels,'_LE')) = {0}; 
    tableOutput(1, strcat(EEG.chanlocs(jChan).labels,'_HFD')) = {0}; 
    tableOutput(1, strcat(EEG.chanlocs(jChan).labels,'_MSE')) = {0}; 
    tableOutput(1, strcat(EEG.chanlocs(jChan).labels,'_DFA')) = {0}; 
end

%% Check type of file and then process it accordingly
% Check if RMET and then iterate through DIN8 events [DIN8 DIN8]
% Check if BCST and then iterate through [DIN1 DIN4(8)+100]

eventVec = []; % Clean vector

% RMET
if size(tableOutput,1)==sum(arrayfun(@(x) strcmp(x.type, 'DIN0') + strcmp(x.type, 'DIN8'), EEG.event))
    eventVec = find(arrayfun(@(x) strcmp(x.type, 'DIN8'), EEG.event));
end

% BCST
if size(tableOutput,1)>=10 && sum(arrayfun(@(x) strcmp(x.type, 'DIN1') + strcmp(x.type, 'DIN4'), EEG.event))>=1
    eventVec = find(arrayfun(@(x) strcmp(x.type, 'DIN1'), EEG.event));
end

% Eyes Open -> Closed == used for benchmarking

for iEvent = eventVec
    for jChan = 1:size(EEG.chanlocs,2)
        tic;
        % Extract epochs
        % RMET
        if size(tableOutput,1)==sum(arrayfun(@(x) strcmp(x.type, 'DIN0') + strcmp(x.type, 'DIN8'), EEG.event))
           tempData = EEG.data(jChan, EEG.event(iEvent).latency:EEG.event(iEvent + 1).latency);
        end
        % BCST
        if size(tableOutput,1)>=10 && sum(arrayfun(@(x) strcmp(x.type, 'DIN1') + strcmp(x.type, 'DIN4'), EEG.event))>=1
            tempData = EEG.data(jChan, EEG.event(iEvent).latency:EEG.event(iEvent + 1).latency+100);
        end

        % Correlation dimension, PK
        d = 10; 
        [CD, PK, ~] = fcnCD_PK(tempData,d);

        % False nearest neighbors
        tao = 10;
        mmax = 10;
        rtol = 10;
        atol = 2;
        thresh = 0.05;
        FNN = find(fcnFNN(tempData,tao,mmax,rtol,atol) < thresh,1);

        % Lyapunov Spectrum
        LE = 0;

        % Higuchi FD
        kmax = 5;
        HFD = fcnHFD(tempData, kmax);

        % MSE
        [MSE, ~, ~] = fcnSE(tempData);

        % DFA
        [DFA, ~] = fcnDFA(tempData);

        % Save output to a table
        tableOutput(iEvent, strcat(EEG.chanlocs(jChan).labels,'_CD')) = {CD}; 
        tableOutput(iEvent, strcat(EEG.chanlocs(jChan).labels,'_PK')) = {PK}; 
        tableOutput(iEvent, strcat(EEG.chanlocs(jChan).labels,'_FNN')) = {FNN}; 
        tableOutput(iEvent, strcat(EEG.chanlocs(jChan).labels,'_LE')) = {LE}; 
        tableOutput(iEvent, strcat(EEG.chanlocs(jChan).labels,'_HFD')) = {HFD}; 
        tableOutput(iEvent, strcat(EEG.chanlocs(jChan).labels,'_MSE')) = {MSE}; 
        tableOutput(iEvent, strcat(EEG.chanlocs(jChan).labels,'_DFA')) = {DFA}; 
        
        % Show progress
        if rem(jChan, 10)==0
            disp([' Channel: ', num2str(jChan)])
        end
    end
    % Save length of epoch
    tableOutput(iEvent, 'Epoch_length') = {length(tempData)}; 
    disp([' Event: ', num2str(iEvent)])
    toc;
end

%% Save output to Excel spreadsheet for checking
writetable(tableOutput,strrep(filename,'.RAW','.xlsx'),'Sheet',1,'Range','A1')





%% Use headplot to show it
% Setup phase
%headplot('setup', EEG.chanlocs, 'outsplinefile'); 
% Plot phase
%headplot(Higuchi_FD_aft,'outsplinefile');
    




