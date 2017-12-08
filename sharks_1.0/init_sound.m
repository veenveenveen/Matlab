function ai = init_sound(samp_len)
% Function 'init_sound' initializes microphone input for voice
% 'fs' is the sampling rate, 'samp_len' is the time to record
%   in seconds.

v = ver;
name = {v.Name};
ind = find(strcmp(name,'MATLAB'));
if isempty(ind)
	ind = find(strcmp(name,'MATLAB Toolbox'));
end

v_num = str2num(v(ind).Version);

ai = analoginput('winsound');
addchannel(ai, 1);
if (v_num == 6.1) | (v_num == 6.5)
	set(ai, 'StandardSampleRates', 'Off');
end
set(ai, 'SampleRate', 8000);
actual_fs = get(ai, 'SampleRate');
set(ai, 'TriggerType', 'software');
set(ai, 'TriggerRepeat', 0);                
set(ai, 'TriggerCondition', 'Rising'); 
set(ai, 'TriggerConditionValue', 0.01);
set(ai, 'TriggerChannel', ai.Channel(1)); 
set(ai, 'TriggerDelay', -0.1);
set(ai, 'TriggerDelayUnits', 'seconds');
set(ai, 'SamplesPerTrigger', actual_fs*samp_len+1);
set(ai, 'TimeOut', 10);
