function ex3

    % Consts
    DATA_SIZE = 2048;
    NOISE_POWER = 0.1;
        
    % Not all the bit stream will actually be used
    bit_stream = generateData(DATA_SIZE);
    symbols = bi2de(reshape(bit_stream, round(length(bit_stream)/2), 2));
    source_ofdm = qammod(symbols, 4)/sqrt(2);

    % Inserting guard band
    source_ofdm(1:100) = 0;
    source_ofdm(end-100+1:end) = 0;
    y1 = ifft(source_ofdm);
    len = size(y1, 1);
    gi = round(len/8);

    % Add guard interval
    gi_y = zeros(len+gi, 1);
    gi_y(1:gi) = y1(end-gi+1:end);
    gi_y(gi+1:end) = y1;

    received_signal1 = gi_y;

    % Removing guard interval
    received_signal1 = received_signal1(gi+1:end);
    received_ofdm1 = fft(received_signal1);        
    received_ofdm_symbols1 = qamdemod(received_ofdm1, 4);
    % Demodulate
    received_bit_stream1 = reshape(de2bi(received_ofdm_symbols1), DATA_SIZE, 1)';
    pilot1 = source_ofdm(101:end-100)./received_ofdm1(101:end-100);


    received_signal2 = channel2(gi_y);
    % Removing guard interval
    [received_ofdm_symbols2, received_ofdm_values2] = receiveSignal(received_signal2, gi);

    % Demodulate
    received_bit_stream2 = reshape(de2bi(received_ofdm_symbols2), DATA_SIZE, 1)';
    pilot2 = source_ofdm(101:end-100)./received_ofdm_values2(101:end-100);        
% 
%     figure;
%     subplot(1,2,1);
%     xlabel('Subcarrier');
%     ylabel('|b_k|');
%     stem([1:10:length(received_ofdm1)], abs(received_ofdm1(1:10:end)));
%     title('h[n]=\delta[n]');
%     subplot(1,2,2);
%     xlabel('Subcarrier');
%     ylabel('|b_k|');
%     stem([1:3:length(received_ofdm_values2)], abs(received_ofdm_values2(1:3:end)));
%     title('h[n]=1*\delta[n-1]+0.9j*\delta[n-10]');


    received_signal3 = channel1(gi_y);
    received_signal3 = delaySignal(received_signal3, 30);
    [received_ofdm_symbols3, received_ofdm_values3] = receiveSignal(received_signal3, gi);
    received_signal4 = channel2(gi_y);
    received_signal4 = delaySignal(received_signal4, 30);
    [received_ofdm_symbols4, received_ofdm_values4] = receiveSignal(received_signal4, gi);

%     figure;
%     subplot(1,2,1);
%     xlabel('Subcarrier');
%     ylabel('|b_k|');
%     stem([1:10:length(received_ofdm_values3)], abs(received_ofdm_values3(1:10:end)));
%     title('h[n]=\delta[n-30]');
%     subplot(1,2,2);
%     xlabel('Subcarrier');
%     ylabel('|b_k|');
%     stem([1:length(received_ofdm_values4)], abs(received_ofdm_values4(1:end)));
%     title('h[n]=1*\delta[n-31]+0.9j*\delta[n-40]');
    
    snr_to_matches = [];
    for snr=[0:1:35]
        matches = 0;
        for i=[1:26]
            bit_stream = generateData(DATA_SIZE);
            symbols = bi2de(reshape(bit_stream, round(length(bit_stream)/2), 2));
            source_ofdm = qammod(symbols, 4)/sqrt(2);
            
             % Inserting guard band
            source_ofdm(1:100) = 0;
            source_ofdm(end-100+1:end) = 0;
            y1 = ifft(source_ofdm);
            len = size(y1, 1);
            gi = round(len/8);

            % Add guard interval
            gi_y = zeros(len+gi, 1);
            gi_y(1:gi) = y1(end-gi+1:end);
            gi_y(gi+1:end) = y1;
            

            received_signal5 = channel1(gi_y);
            received_signal5 = addNoiseToSignal(received_signal5, snr);
            [received_ofdm_symbols5, received_ofdm_values5] = receiveSignal(received_signal5, gi);
            received_signal6 = channel2(gi_y);
            received_signal6 = addNoiseToSignal(received_signal6, snr);
            [received_ofdm_symbols6, received_ofdm_values6] = receiveSignal(received_signal6, gi);
%             pilot6 = source_ofdm(101:end-100)./received_ofdm_values6(101:end-100);
            received_ofdm_values6 = received_ofdm_values6(101:end-100).*pilot2;
        %     received_ofdm_values6 = received_ofdm_values6(101:end-100);
            received_ofdm_symbols6 = qamdemod(received_ofdm_values6, 4);
%             received_bit_stream6 = reshape(de2bi(received_ofdm_symbols6), 1, length(received_ofdm_symbols6)*2)';
            
            matches = matches + sum(received_ofdm_symbols6 == symbols(101:end-100));
        end
        
        snr_to_matches = [snr_to_matches ; [snr, matches/(length(received_ofdm_symbols6)*26)]];        
        
    end
    
    figure;
    semilogy(snr_to_matches(:,1), 1-snr_to_matches(:,2));
    
    grid on;
    title('SER curve for OFDM');
    xlabel('SNR[db]');
    ylabel('SER');
    
end

function [signalArray, subcarrierData] = createSignalssToSend(bitStream)

    
end

function transSignal = transmitSignals(signalToSend, channelNumber, timeDelay, shouldAddNoise)
    % TRANSMITTER
    
    gi_y = delaySignal(signalToSend, timeDelay);
    
    if shouldAddNoise == 1
        gi_y = addNoiseToSignal(gi_y, NOISE_POWER);
    end
    
    if (channelNumber == 1)
        transSignal = channel1(gi_y);
    elseif (channelNumber == 2)
        transSignal = channel2(gi_y);
    end
    
end


function [ofdmSymbols, ofdmValues] = receiveSignal(signal, gi)
    received_signal = signal(gi+1:end);
    received_ofdm = fft(received_signal);
    ofdmSymbols = qamdemod(received_ofdm, 4);
    ofdmValues = received_ofdm;
end



function noisySignal = addNoiseToSignal(signal, snr)
    noisySignal = awgn(signal, snr, 'measured');
end

function intervaledSignal = delaySignal(signal, delay)
    len = length(signal);
    intervaledSignal = zeros(len, 1);
    intervaledSignal(delay+1:end) = signal(1:end-delay);
    
end


function outputSignal = channel1(signal)
    outputSignal = signal;
end

function outputSignal = channel2(signal)
    len = length(signal);
    outputSignal = zeros(len, 1);
    outputSignal(2:end) = outputSignal(2:end) + 1*signal(1:end-1);
    outputSignal(11:end) = outputSignal(11:end) + 0.9j*signal(1:end-10);
end