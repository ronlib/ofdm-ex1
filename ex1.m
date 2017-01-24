function ex1
    DATA_LENGTH = 2000;
    
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
    
    
%     % MRC 1X2
%     mrc2_snr_ser = [];
%     for snr=[0:25]
%         bits = round(rand(DATA_LENGTH, 1));
%         qpsk_symbols = bi2de(reshape(bits, [], 2));
%         qpsk_values = qammod(qpsk_symbols, 4)/sqrt(2);
%         channel1 = addRayleighNoise(zeros(length(qpsk_values), 1), 0);
%         channel2 = addRayleighNoise(zeros(length(qpsk_values), 1), 0);
%         qpsk_values_after_channel1 = channel1.*qpsk_values;
%         qpsk_values_after_channel2 = channel2.*qpsk_values;
%         noisy_qpsk_values1 = addRayleighNoise(qpsk_values_after_channel1, snr);
%         noisy_qpsk_values2 = addRayleighNoise(qpsk_values_after_channel2, snr);
% %         noisy_qpsk_values1 = qpsk_values_after_channel1;
% %         noisy_    qpsk_values2 = qpsk_values_after_channel2;
% 
% %         demod_noisy_qpsk_symbols = qamdemod(noisy_qpsk_values, 4);
%         demod_noisy_qpsk_symbols = zeros(length(qpsk_values), 1);
%         for i=[1:length(qpsk_values)]
%             channel = [channel1(i) ; channel2(i)];
%             received_value = [noisy_qpsk_values1(i) ; noisy_qpsk_values2(i)];
%             ls_est_value = [channel'*received_value]/(channel'*channel);
%             demod_noisy_qpsk_symbols(i) = lsFindOfdmSymbol(ls_est_value, @(x)(x));
%         end
%         
%         mrc2_snr_ser = [mrc2_snr_ser ; [snr, 1-(sum(demod_noisy_qpsk_symbols==qpsk_symbols)/length(qpsk_values))]];
%     end
%     
%     figure;
%     semilogy(mrc2_snr_ser(:,1), mrc2_snr_ser(:,2));
%     grid on;
%     xlabel('SNR[db]');
%     ylabel('SER');
%     title('SER curve for MRC 1X2');
    
    
    
%     % MRC 1X4
%     mrc4_snr_ser = [];
%     for snr=[0:25]
%         bits = round(rand(DATA_LENGTH, 1));
%         qpsk_symbols = bi2de(reshape(bits, [], 2));
%         qpsk_values = qammod(qpsk_symbols, 4)/sqrt(2);
%         channel1 = addRayleighNoise(zeros(length(qpsk_values), 1), 0);
%         channel2 = addRayleighNoise(zeros(length(qpsk_values), 1), 0);
%         channel3 = addRayleighNoise(zeros(length(qpsk_values), 1), 0);
%         channel4 = addRayleighNoise(zeros(length(qpsk_values), 1), 0);
%         qpsk_values_after_channel1 = channel1.*qpsk_values;
%         qpsk_values_after_channel2 = channel2.*qpsk_values;
%         qpsk_values_after_channel3 = channel3.*qpsk_values;
%         qpsk_values_after_channel4 = channel4.*qpsk_values;
%         noisy_qpsk_values1 = addRayleighNoise(qpsk_values_after_channel1, snr);
%         noisy_qpsk_values2 = addRayleighNoise(qpsk_values_after_channel2, snr);
%         noisy_qpsk_values3 = addRayleighNoise(qpsk_values_after_channel3, snr);
%         noisy_qpsk_values4 = addRayleighNoise(qpsk_values_after_channel4, snr);
% %         noisy_qpsk_values1 = qpsk_values_after_channel1;
% %         noisy_    qpsk_values2 = qpsk_values_after_channel2;
% 
% %         demod_noisy_qpsk_symbols = qamdemod(noisy_qpsk_values, 4);
%         demod_noisy_qpsk_symbols = zeros(length(qpsk_values), 1);
%         for i=[1:length(qpsk_values)]
%             channel = [channel1(i); channel2(i); channel3(i); channel4(i)];
%             received_value = [noisy_qpsk_values1(i) ; noisy_qpsk_values2(i) ; ...
%                 noisy_qpsk_values3(i); noisy_qpsk_values4(i)];
%             ls_est_value = [channel'*received_value]/(channel'*channel);
%             demod_noisy_qpsk_symbols(i) = lsFindOfdmSymbol(ls_est_value, @(x)(x));
%         end
%         
%         mrc4_snr_ser = [mrc4_snr_ser ; [snr, 1-(sum(demod_noisy_qpsk_symbols==qpsk_symbols)/length(qpsk_values))]];
%     end
%     
%     figure;
%     semilogy(mrc4_snr_ser(:,1), mrc4_snr_ser(:,2));
%     grid on;
%     xlabel('SNR[db]');
%     ylabel('SER');
%     title('SER curve for MRC 1X4');


%     figure;
%     semilogy(siso_snr_ser(:,1), siso_snr_ser(:,2));
%     grid on;
%     xlabel('SNR[db]');
%     ylabel('SER');
%     title('SER curve for SISO');
%     
    
%     % STC 2X1
%     stc21_snr_ser = [];
%     for snr=[25:-1:0]
%         bits = round(rand(DATA_LENGTH, 1));
%         qpsk_symbols = bi2de(reshape(bits, [], 2));
%         qpsk_values = qammod(qpsk_symbols, 4)/sqrt(2);
%         channel1 = addRayleighNoise(zeros(length(qpsk_values), 1), 0);
%         channel2 = addRayleighNoise(zeros(length(qpsk_values), 1), 0);
%         demod_noisy_qpsk_symbols = zeros(length(qpsk_values), 1);
%         for i=[1:2:length(qpsk_values)-1]
%             H = [channel1(i), channel2(i); channel2(i)', -channel1(i)']./sqrt(2);
%             signal = [qpsk_values(i) ; qpsk_values(i+1)];
%             qpsk_values_l = H*signal;
%             received_noisy_qpsk_values = addRayleighNoise(qpsk_values_l, snr);
%             ls_est_values = (H'*H)^-1*(H'*received_noisy_qpsk_values);
%             
%             demod_noisy_qpsk_symbols(i) = lsFindOfdmSymbol(ls_est_values(1), @(x)(x));
%             demod_noisy_qpsk_symbols(i+1) = lsFindOfdmSymbol(ls_est_values(2), @(x)(x));
%         end
%         
%         stc21_snr_ser = [stc21_snr_ser ; [snr, 1-(sum(demod_noisy_qpsk_symbols==qpsk_symbols)/length(qpsk_values))]];
%     end
%     
%     figure;
%     semilogy(stc21_snr_ser(:,1), stc21_snr_ser(:,2));
%     grid on;
%     xlabel('SNR[db]');
%     ylabel('SER');
%     title('SER curve for STC 2X1');

    
%     % STC 2X2
%     stc22_snr_ser = [];
%     for snr=[25:-1:0]
%         bits = round(rand(DATA_LENGTH, 1));
%         qpsk_symbols = bi2de(reshape(bits, [], 2));
%         qpsk_values = qammod(qpsk_symbols, 4)/sqrt(2);
%         channel1 = addRayleighNoise(zeros(length(qpsk_values), 1), 0);
%         channel2 = addRayleighNoise(zeros(length(qpsk_values), 1), 0);
%         channel3 = addRayleighNoise(zeros(length(qpsk_values), 1), 0);
%         channel4 = addRayleighNoise(zeros(length(qpsk_values), 1), 0);
%         demod_noisy_qpsk_symbols = zeros(length(qpsk_values), 1);
%         for i=[1:2:length(qpsk_values)-1]
%             H0 = [channel1(i), channel2(i); channel2(i)', -channel1(i)']./sqrt(2);
%             H1 = [channel3(i), channel4(i); channel3(i)', -channel4(i)']./sqrt(2);
%             H = [H0 ; H1];
%             signal = [qpsk_values(i) ; qpsk_values(i+1)];
%             qpsk_values_l = H*signal;
%             received_noisy_qpsk_values = addRayleighNoise(qpsk_values_l, snr);
%             ls_est_values = (H'*H)^-1*(H'*received_noisy_qpsk_values);
%             
%             demod_noisy_qpsk_symbols(i) = lsFindOfdmSymbol(ls_est_values(1), @(x)(x));
%             demod_noisy_qpsk_symbols(i+1) = lsFindOfdmSymbol(ls_est_values(2), @(x)(x));
%         end
%         
%         stc22_snr_ser = [stc22_snr_ser ; [snr, 1-(sum(demod_noisy_qpsk_symbols==qpsk_symbols)/length(qpsk_values))]];
%     end
%     
%     figure;
%     semilogy(stc22_snr_ser(:,1), stc22_snr_ser(:,2));
%     grid on;
%     xlabel('SNR[db]');
%     ylabel('SER');
%     title('SER curve for STC 2X2');

%     % BF 2X2
%     bf22_snr_ser = [];
%     for snr=[25:-1:0]
%         bits = round(rand(DATA_LENGTH, 1));
%         qpsk_symbols = bi2de(reshape(bits, [], 2));
%         qpsk_values = qammod(qpsk_symbols, 4)/sqrt(2);
%         channels = zeros(length(qpsk_values), 4);
%         for i=[1:size(channels, 2)]
%             channels(:,i) = addRayleighNoise(channels(:,i), 0);
%         end
%         
%         demod_noisy_qpsk_symbols = zeros(length(qpsk_values), 1);
%         for i=[1:length(qpsk_values)]
%             H = [channels(i, 1), channels(i, 2) ; channels(i, 3) , channels(i, 4)];
%             [V,D] = eig(H'*H);
%             [~,max_eig_index] = max(max(abs(D)));
%             
%             weighted_H = H*V(:, max_eig_index);
%             sent_signals = weighted_H*qpsk_values(i);
%             received_noisy_qpsk_values = addRayleighNoise(sent_signals, snr);
%                         
%             ls_est_value = (weighted_H'*weighted_H)^-1*(weighted_H'*received_noisy_qpsk_values);
%             demod_noisy_qpsk_symbols(i) = lsFindOfdmSymbol(ls_est_value, @(x)(x));
%         end
%         
%         bf22_snr_ser = [bf22_snr_ser ; [snr, 1-(sum(demod_noisy_qpsk_symbols==qpsk_symbols)/length(qpsk_values))]];
%     end
%     
%     figure;
%     semilogy(bf22_snr_ser(:,1), bf22_snr_ser(:,2));
%     grid on;
%     xlabel('SNR[db]');
%     ylabel('SER');
%     title('SER curve for BF 2X2');

    
%     % BF 4X2
%     bf42_snr_ser = [];
%     for snr=[25:-1:0]
%         bits = round(rand(DATA_LENGTH, 1));
%         qpsk_symbols = bi2de(reshape(bits, [], 2));
%         qpsk_values = qammod(qpsk_symbols, 4)/sqrt(2);
%         channels = zeros(length(qpsk_values), 8);
%         for i=[1:size(channels, 2)]
%             channels(:,i) = addRayleighNoise(channels(:,i), 0);
%         end
%         
%         demod_noisy_qpsk_symbols = zeros(length(qpsk_values), 1);
%         for i=[1:length(qpsk_values)]
%             H = [channels(i, 1), channels(i, 2) , channels(i, 3) , channels(i, 4) ; ...
%                 channels(i, 5), channels(i, 6) , channels(i, 7) , channels(i, 8)];
%             [V,D] = eig(H'*H);
%             [~,max_eig_index] = max(max(abs(D)));
%             
%             weighted_H = H*V(:, max_eig_index);
%             sent_signals = weighted_H*qpsk_values(i);
%             received_noisy_qpsk_values = addRayleighNoise(sent_signals, snr);
%                         
%             ls_est_value = (weighted_H'*weighted_H)^-1*(weighted_H'*received_noisy_qpsk_values);
%             demod_noisy_qpsk_symbols(i) = lsFindOfdmSymbol(ls_est_value, @(x)(x));
%         end
%         
%         bf42_snr_ser = [bf42_snr_ser ; [snr, 1-(sum(demod_noisy_qpsk_symbols==qpsk_symbols)/length(qpsk_values))]];
%     end
%     
%     figure;
%     semilogy(bf42_snr_ser(:,1), bf42_snr_ser(:,2));
%     grid on;
%     xlabel('SNR[db]');
%     ylabel('SER');
%     title('SER curve for BF 4X2');

    
    % SM ML 2X2
    sm22_snr_ser = [];
    for snr=[25:-1:0]
        bits = round(rand(DATA_LENGTH, 1));
        qpsk_symbols = bi2de(reshape(bits, [], 2));
        qpsk_values = qammod(qpsk_symbols, 4)/sqrt(2);
        channels = zeros(length(qpsk_values), 4);
        for i=[1:size(channels, 2)]
            channels(:,i) = addRayleighNoise(channels(:,i), 0);
        end
        
        demod_noisy_qpsk_symbols = zeros(length(qpsk_values), 1);
        for i=[1:2:length(qpsk_values)]
            H = [channels(i, 1), channels(i, 2) ; channels(i, 3) , channels(i, 4)];
            
            sent_signals = H*[qpsk_values(i) ; qpsk_values(i+1)]/sqrt(2);
            received_noisy_qpsk_values = addRayleighNoise(sent_signals, snr);
            
            ofdm_symbol_guesses = zeros(16, 3);
            index = 1;
            for t1=[0:3]
                for t2=[0:3]
                    v1 = qammod(t1, 4)/sqrt(2);
                    v2 = qammod(t2, 4)/sqrt(2);
                    guess_value = (received_noisy_qpsk_values - H*[v1;v2])'*(received_noisy_qpsk_values - H*[v1;v2]);
                    ofdm_symbol_guesses(index,:) = [t1, t2, guess_value];
                    index = index+1;
                end
            end
            
            [~,min_guess_value_index] = min(ofdm_symbol_guesses(:,3));
            
            demod_noisy_qpsk_symbols(i) = ofdm_symbol_guesses(min_guess_value_index, 1);
            demod_noisy_qpsk_symbols(i+1) = ofdm_symbol_guesses(min_guess_value_index, 2);
        end
        
        sm22_snr_ser = [sm22_snr_ser ; [snr, 1-(sum(demod_noisy_qpsk_symbols==qpsk_symbols)/length(qpsk_values))]];
    end
    
    figure;
    semilogy(sm22_snr_ser(:,1), sm22_snr_ser(:,2));
    grid on;
    xlabel('SNR[db]');
    ylabel('SER');
    title('SER curve for SM ML 2X2');

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