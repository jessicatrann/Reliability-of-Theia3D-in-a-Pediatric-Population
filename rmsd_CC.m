clear
% Valid input options
valid_input = ["lankle_x", "lankle_y", "lankle_z", "lhip_x", "lhip_y", "lhip_z", "lknee_x", "lknee_y", "lknee_z", "rankle_x", "rankle_y", "rankle_z", "rhip_x", "rhip_y", "rhip_z", "rknee_x", "rknee_y", "rknee_z"];

% Specify the data directory
pathway1 = pwd;

% Prompt and validate trial input
user_input = lower(input("Please enter the joint and plane for the trials you would like to analyze: ","s"));
while ~ismember(user_input, valid_input)
    disp('The input is invalid. Please try again.')
    user_input = lower(input("Please enter the joint and plane for the trials you would like to analyze: ","s"));
end

% Define the common part of the file names
file_name_prefix = strcat('*', upper(user_input(1)), lower(user_input(2:end)), 'out.csv*');

% Obtain mb file
[mb_files, mb_path] = uigetfile(fullfile(pathway1, file_name_prefix), 'Select the MB trials', 'MultiSelect', 'on');
mb_files = cellstr(mb_files);

% Obtain ml file
[ml_files, ml_path] = uigetfile(fullfile(pathway1, file_name_prefix), 'Select the ML trials', 'MultiSelect', 'on');
ml_files = cellstr(ml_files);

% Load data from mb trials file(s)
mb_trials = [];
for i = 1:length(mb_files)
    mb_data = readmatrix(fullfile(mb_path, mb_files{i}));
    % test(i,:)=mb_data; (puts each new file into a new column)
    mb_trials = [mb_trials; mb_data];
end

% Load data from ml trials file(s)
ml_trials = [];
for i = 1:length(ml_files)
    ml_data = readmatrix(fullfile(ml_path, ml_files{i}));  
    ml_trials = [ml_trials; ml_data];
end

% Puts each new data set into a new column
new_mb_trials = reshape(mb_trials, 101, []);
new_ml_trials = reshape(ml_trials, 101, []);

% Calculates the mean of each row for each trial
mean_mb = mean(new_mb_trials, 2);
mean_ml = mean(new_ml_trials, 2);

mean_mb_1 = mean_mb.*-1;
mean_ml_1 = mean_ml.*-1;

% Calculates the difference for each trial between the two trials
difference = mean_mb - mean_ml;
difference_1 = mean_mb_1 - mean_ml_1;

% Calculate RMSE for ml trials and mb trials
length = length(difference);
[s, n] = sumsqr(difference);
a = s/length;
rmse = sqrt(a);

% Displays the RMSD value
disp(['The RMSD value for ', user_input, ' is: ', num2str(rmse)]);

% Plots the mean of the mb and ml trials on the same plot
plot(mean_mb_1)
hold on
plot(mean_ml_1)
legend('MB', 'ML')
title(user_input)
ylabel([user_input,' Flexion'])
xlabel('% Gait Cycle')
str = {'RMSE: ', rmse};
text(7, 7, str)
hold off