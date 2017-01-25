function ex2
%     frequency_spectrum = [2500000000-1000000:50:2500000000+1000000];
%     h_f = zeros(length(frequency_spectrum), 2);
%     f_m = 3/300000;
%     
%     delays = 10^-9*[0, 110, 190, 410];
%     power_fade_db = [0, -9.7, -19.2, -22.8];
%     for i=[1:length(frequency_spectrum)]
% %         distance_fade = db2mag(40*log10(2.5) + 30*log10(frequency_spectrum(i)/1000000)+49)^2;
%         distance_fade = db2mag(40*log10(2.5) + 30*log10(frequency_spectrum(1)/1000000)+49)^2;
%         h_f(i, 1) = frequency_spectrum(i);
%         
% %         h_f(i, 2) = abs((1/distance_fade)*sum((db2mag(power_fade_db).^2).*exp(-j*2*pi*frequency_spectrum(i)*delays)));
%         h_f(i, 2) = abs(sum(exp(-j*2*pi*frequency_spectrum(i)*delays)));
%         
%     end

    % Delays, in nanoseconds
    delays = [0, 110, 190, 410];
    power_fade_db = [0, -9.7, -19.2, -22.8];
    N = 10000;
    FM_MAX = (3/3.6)*2.5e9/3e8;
    TIMES_TO_SAMPLE = round([linspace(1,5,4) ; linspace(1,100,4) ; linspace(1,300,4)])';
    
    
    PSD_FILTER_HZ = 1000;
    psd_filter = zeros(1, N);
    k = round(N*FM_MAX/PSD_FILTER_HZ);
    psd_filter(1:k) = 1;
    psd_filter(end-k:end) = 1;
    
    % a contains the a_i(t) random process. t is in nanoseconds
    a = zeros(length(delays), N);
    for i=[1:length(delays)]
        a(i,:) = (randn(1, N) + j*randn(1, N))/sqrt(2);
        a(i,:) = ifft(fft(a(i,:)).*psd_filter);
        a(i,:) = (a(i,:) / sqrt(var(a(i,:))))*db2mag(power_fade_db(i));
    end
    
    figure;
    for idx=[1:numel(TIMES_TO_SAMPLE)]
        channel = zeros(N, 1);
        channel(delays+1) = a(:,TIMES_TO_SAMPLE(idx));
        
        subplot(size(TIMES_TO_SAMPLE, 2), size(TIMES_TO_SAMPLE, 1), idx);
        plot((1:N)/10, mag2db(abs(fft(channel)))/2);
        title(sprintf('t = %d ns', TIMES_TO_SAMPLE(idx)));
        xlabel('HZ');
        ylabel('power(db)');
        ylim([-30, 30]);
        grid on;
    end
    
    figure;
    
    % taken from https://www.mathworks.com/help/signal/ug/power-spectral-density-estimates-using-fft.html
    
    channel = zeros(N, 1);
    channel(delays+1) = a(:,1);
    xdft = fft(channel);
    xdft = xdft(1:N/2+1);
    psdx = (1/(PSD_FILTER_HZ*N)) * abs(xdft).^2;
    psdx(2:end-1) = 2*psdx(2:end-1);
    freq = 0:PSD_FILTER_HZ/length(channel):PSD_FILTER_HZ/2;

    plot(freq,10*log10(psdx))
    grid on
    title('Periodogram Using FFT')
    xlabel('Frequency (Hz)')
    ylabel('Power/Frequency (dB/Hz)')

end


