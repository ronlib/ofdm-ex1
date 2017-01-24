function ex1
    DATA_LENGTH = 20000;
    
    x = zeros(1024, 1);
    nx = addRayleighNoise(x, 0);
    
%     % SISO
%     siso_snr_ser = [];
%     for snr=[40:-1:-10]
%         bits = round(rand(DATA_LENGTH, 1));
%         qpsk_symbols = bi2de(reshape(bits, [], 2));
%         qpsk_values = qammod(qpsk_symbols, 4)/sqrt(2);
%         channel = addRayleighNoise(zeros(length(qpsk_values), 1), 0);
%         qpsk_values_after_channel = qpsk_values.*channel;
%         noisy_qpsk_values = addRayleighNoise(qpsk_values_after_channel, snr);
%         
% %         demod_noisy_qpsk_symbols = qamdemod(noisy_qpsk_values, 4);
%         demod_noisy_qpsk_symbols = zeros(length(noisy_qpsk_values), 1);
%         for i=[1:length(noisy_qpsk_values)]
%             demod_noisy_qpsk_symbols(i) = lsFindOfdmSymbol(noisy_qpsk_values(i)./channel(i), @(x)(x));
%         end
%         
%         siso_snr_ser = [siso_snr_ser ; [snr, 1-(sum(demod_noisy_qpsk_symbols==qpsk_symbols)/length(qpsk_values))]];
%     end
    
%     figure;
%     semilogy(siso_snr_ser(:,1), siso_snr_ser(:,2));
%     grid on;
%     xlabel('SNR[db]');
%     ylabel('SER');
%     title('SER curve for SISO');
    
    
    % MRC 1X2
    mrc2_snr_ser = [];
    for snr=[0:25]
        bits = round(rand(DATA_LENGTH, 1));
        qpsk_symbols = bi2de(reshape(bits, [], 2));
        qpsk_values = qammod(qpsk_symbols, 4)/sqrt(2);
        channel1 = addRayleighNoise(zeros(length(qpsk_values), 1), 0);
        channel2 = addRayleighNoise(zeros(length(qpsk_values), 1), 0);
        qpsk_values_after_channel1 = channel1.*qpsk_values;
        qpsk_values_after_channel2 = channel2.*qpsk_values;
        noisy_qpsk_values1 = addRayleighNoise(qpsk_values_after_channel1, snr);
        noisy_qpsk_values2 = addRayleighNoise(qpsk_values_after_channel2, snr);
%         noisy_qpsk_values1 = qpsk_values_after_channel1;
%         noisy_    qpsk_values2 = qpsk_values_after_channel2;

%         demod_noisy_qpsk_symbols = qamdemod(noisy_qpsk_values, 4);
        demod_noisy_qpsk_symbols = zeros(length(qpsk_values), 1);
        for i=[1:length(qpsk_values)]
            channel = [channel1(i) ; channel2(i)];
            received_value = [noisy_qpsk_values1(i) ; noisy_qpsk_values2(i)];
            ls_est_value = [channel'*received_value]/(channel'*channel);
            demod_noisy_qpsk_symbols(i) = lsFindOfdmSymbol(ls_est_value, @(x)(x));
        end
        
        mrc2_snr_ser = [mrc2_snr_ser ; [snr, 1-(sum(demod_noisy_qpsk_symbols==qpsk_symbols)/length(qpsk_values))]];
    end
    
    figure;
    semilogy(mrc2_snr_ser(:,1), mrc2_snr_ser(:,2));
    grid on;
    xlabel('SNR[db]');
    ylabel('SER');
    title('SER curve for MRC 1X2');
    
    
    
    mrc4_snr_ser = [];
    for snr=[25:-1:0]
        bits = round(rand(DATA_LENGTH, 1));
        qpsk_symbols = bi2de(reshape(bits, [], 2));
        qpsk_values = qammod(qpsk_symbols, 4)/sqrt(2);
        noisy_qpsk_values1 = addRayleighNoise(qpsk_values, snr);
        noisy_qpsk_values2 = addRayleighNoise(qpsk_values, snr);
        noisy_qpsk_values3 = addRayleighNoise(qpsk_values, snr);
        noisy_qpsk_values4 = addRayleighNoise(qpsk_values, snr);
%         demod_noisy_qpsk_symbols = qamdemod(noisy_qpsk_values, 4);
        demod_noisy_qpsk_symbols = zeros(length(qpsk_values), 1);
        for i=[1:length(qpsk_values)]
            demod_noisy_qpsk_symbols(i) = lsFindOfdmSymbol([noisy_qpsk_values1(i), noisy_qpsk_values2(i), ...
                noisy_qpsk_values3(i), noisy_qpsk_values4(i)], @(x)([x, x, x, x]));
        end
        
        mrc4_snr_ser = [mrc4_snr_ser ; [snr, 1-(sum(demod_noisy_qpsk_symbols==qpsk_symbols)/length(qpsk_values))]];
    end
    
    figure;
    semilogy(mrc4_snr_ser(:,1), mrc4_snr_ser(:,2));
    grid on;
    xlabel('SNR[db]');
    ylabel('SER');
    title('SER curve for MRC 1X4');

end


function noisySignal = addRayleighNoise(signal, snrDb)
    % Assuming the signal power is 1

    len = length(signal);
    noise = normrnd(0, 1, len, 2)/(sqrt(2*power(10, snrDb/10)));
    noisySignal = signal + noise(:, 1) + j*noise(:, 2);
end

function lsOfdmSymbol = lsFindOfdmSymbol(value, functional);
    possible_values = qammod([0:3], 4)./sqrt(2);
    comparison = [];
    for i=[1:4]
        diff = (value - functional(possible_values(i))).^2;
        comparison = [comparison ; sum(diff(:))];
    end
    [~,i] = min(abs(comparison));
    lsOfdmSymbol = i-1;
end