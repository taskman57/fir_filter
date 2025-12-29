function myfir()
%------------------------------------------------------------
% Golden Reference FIR Script (Octave)
% Implements 54-tap FIR filter in fixed-point arithmetic
% Produces output file to use as gold result by Vitis HLS
%------------------------------------------------------------

    close all;
    clear all;
    clc;
    %% Parameters
    N = 54;                 % Number of taps
    SAMPLES = 2000;         % Number of input samples
    mid = 32768;            % For converting uint16 -> int16
    fs = 100e6;             % 100 MHz sampling frequency
    nf = 16384;             % fine resolution for better cutoff estimate
    L = SAMPLES;            % Number of fft samples

% Coefficients (int16)
    taps = int16([...
    -4, 19, 25, 39, 59, 85, 118, 158, 205,...
    261, 324, 395, 473, 558, 647, 741, 837, 933,...
    1028, 1119, 1204, 1282, 1350, 1407, 1451, 1481, 1496,...
    1496, 1481, 1451, 1407, 1350, 1282, 1204, 1119, 1028,...
    933, 837, 741, 647, 558, 473, 395, 324, 261,...
    205, 158, 118, 85, 59, 39, 25, 19, -4 ]);

    % Input signal (uint16)
    inpsig = [...
    0xFFF8,0xFD19,0xF4DC,0xE857,0xD92E,0xC957,0xBAD3,0xAF6C,...
    0xA86C,0xA675,0xA96C,0xB075,0xBA1D,0xC485,0xCDAC,0xD3B6,...
    0xD52F,0xD13E,0xC7C8,0xB972,0xA78C,0x93DE,0x8071,0x6F3F,...
    0x61EF,0x599D,0x56AF,0x58CA,0x5EDF,0x6750,0x702E,0x777D,...
    0x7B7F,0x7AED,0x752E,0x6A66,0x5B77,0x49DE,0x3781,0x2668,...
    0x1878,0x0F2E,0x0B6A,0x0D4E,0x143D,0x1EF0,0x2BA4,0x3859,...
    0x431B,0x4A48,0x4CCD,0x4A48,0x431B,0x3859,0x2BA4,0x1EF0,...
    0x143D,0x0D4E,0x0B6A,0x0F2E,0x1878,0x2668,0x3781,0x49DE,...
    0x5B77,0x6A66,0x752E,0x7AED,0x7B7F,0x777D,0x702E,0x6750,...
    0x5EDF,0x58CA,0x56AF,0x599D,0x61EF,0x6F3F,0x8071,0x93DE,...
    0xA78C,0xB972,0xC7C8,0xD13E,0xD52F,0xD3B6,0xCDAC,0xC485,...
    0xBA1D,0xB075,0xA96C,0xA675,0xA86C,0xAF6C,0xBAD3,0xC957,...
    0xD92E,0xE857,0xF4DC,0xFD19];

    % Convert unsigned to signed int16
    sig_signed = int16(int32(inpsig) - mid);

    % Preallocate shift registers
    shift_reg = int16(zeros(1, N));

    %% FIR Filtering
    for n = 1:SAMPLES
        x(n) = sig_signed(mod(n-1, length(sig_signed)) + 1);    % 20 periods

        % Shift registers
        for i = N:-1:2
            shift_reg(i) = shift_reg(i-1);
        end
        shift_reg(1) = x(n);

        % Accumulate (int32)
        acc = int32(0);
        for i = 1:N
            acc = acc + int32(shift_reg(i)) * int32(taps(i));
        end

        % Scale down (match HLS >>16)
        y = bitshift(acc, -16);      % int32
        output(n) = int16(y);        % cast to int16
    end
    t=[1:SAMPLES]/fs;
    subplot(2,1,1);
    plot(t,x);
    title(' Input signal containing main and out of band tones');
    xlabel('Time (s)');
    grid minor on;
    subplot(2,1,2);
    plot(t,output);
    title(' Output of filter');
    xlabel('Time (s)');
    grid minor on;

    black_win = blackman(L)';
    x_win = x .* black_win;                         % Windowing to reduce spectral leakage and improve dynamic range.
    inp_fft = fft(x_win,L);
    win_gain = sum(black_win);
    mag2 = abs(inp_fft/win_gain);                   % Normalization by window gain
    inp_mag_fft = mag2(1:L/2+1);                    % discarding negative elements of fft
    inp_mag_fft(2:end-1) = 2*inp_mag_fft(2:end-1);  % only double positive freq? neither DC nor Nyquist!
    f=(fs/L)*[0:L/2];                               % used for scaling the x-axis

    [max_fft1, idx1] = max(inp_mag_fft);            % finding main tone!
    search_offset = 20;                             % to escape from shoulder bins around main bin
    [max_fft2, idx2_rel] = max(inp_mag_fft(idx1+ search_offset +1:end));% finding second tone which will be attenuatesd
    printf(' dB difference of input: %d dB \n', 20*log10(max_fft1/max_fft2));
    idx2 = search_offset + idx2_rel;                % Calculate absolute index of second tone
    idx1
    idx2
    figure;
    subplot(2,1,1);
    plot (f, inp_mag_fft);
    title('Input signal fft main and out of band tones');
    xlabel('Frequency (Hz)');
    grid minor on;
    hold on;
    plot((idx1-1)*(fs/L), inp_mag_fft(idx1), 'ro', 'MarkerSize', 8, 'LineWidth', 3);
    text((idx1-1)*(fs/L), inp_mag_fft(idx1), ...
    sprintf("  main tone"), ...
    'VerticalAlignment', 'bottom', 'Color', 'red', 'FontSize', 12);
    plot((idx2+idx1-1)*(fs/L), inp_mag_fft(idx2+idx1), 'ro', 'MarkerSize', 8, 'LineWidth', 3);
    text((idx2+idx1-1)*(fs/L), inp_mag_fft(idx2+idx1), ...
    sprintf("  Out of band tone"), ...
    'VerticalAlignment', 'bottom', 'Color', 'red', 'FontSize', 12);
    grid minor on;

    out_win = output .* black_win;                  % Windowing to reduce spectral leakage and improve dynamic range.
    out_fft = fft(out_win, L);
    out_fft = out_fft .* black_win;
    mag2 = abs(out_fft/win_gain);
    out_mag_fft = mag2(1:L/2+1);
    out_mag_fft(2:end-1) = 2*out_mag_fft(2:end-1);
    subplot(2,1,2);
    plot(f, out_mag_fft);
    title(' Output signal FFT, Out of band tone attenuation');
    xlabel('Frequency (Hz)')
    grid minor on;
    hold on;
    plot((idx1-1)*(fs/L), out_mag_fft(idx1), 'ro', 'MarkerSize', 8, 'LineWidth', 3);
    text((idx1-1)*(fs/L), out_mag_fft(idx1), ...
    sprintf(" main tone after filtering"), ...
    'VerticalAlignment', 'bottom', 'Color', 'red', 'FontSize', 12);

    plot((idx2+idx1-1)*(fs/L), out_mag_fft(idx2+idx1), 'ro', 'MarkerSize', 8, 'LineWidth', 3);
    text((idx2+idx1-1)*(fs/L), out_mag_fft(idx2+idx1), ...
    sprintf(" Attenuated Out of band tone!"), ...
    'VerticalAlignment', 'bottom', 'Color', 'red', 'FontSize', 12);
##    (idx1-1)*fs/L
    max_fft1 = out_mag_fft(idx1);
##    (idx2+idx1-1)*fs/L
    max_fft2 = out_mag_fft(idx2+idx1);
    final_atten = 20*log10(max_fft1/max_fft2);
    printf(' dB difference after filtering in the output: %d dB \n', final_atten);

    %%%%%%  Filter response analysis  %%%%%%%%
    taps_norm = double(taps)/sum(double(taps));
    [h, w] = freqz(taps_norm, 1, nf);   % normalized filter freq response!
    f = w * fs /(2*pi);
    magdB = 20*log10(abs(h));
    target = -3;
    [~, idx] = min(abs(magdB - target));    % finding index of -3dB point
    f_3dB = f(idx);                         % cutoff frequency in Hz
    fprintf(' Found index for -3dB: %d with converted real freq: %d \n\r',idx, f_3dB);
    figure;
    plot(f/1e6, magdB, 'LineWidth', 1.5);
    grid on;
    xlabel("Frequency (MHz)");
    ylabel("Magnitude (dB)");
    title("FIR Frequency Response with -3 dB Cutoff");
    hold on;
    % Mark the -3 dB point
    plot(f_3dB/1e6, magdB(idx), 'ro', 'MarkerSize', 8, 'LineWidth', 3);
    % Text annotation
    text(f_3dB/1e6, magdB(idx), ...
    sprintf("  -3 dB @ %.3f MHz", f_3dB/1e6), ...
    'VerticalAlignment', 'bottom', 'Color', 'red', 'FontSize', 12);

    %%%%%%%%%   finding out of band tone attenuation in frequency response
    target_freq = 6e6;                 % 6 MHz in Hz
    [~, idx] = min(abs(f - target_freq));
    f_06M = f(idx);
    fprintf(' Out of band tone: %d with scaled freq: %d and ampl: %d \n\r',idx, f_06M, magdB(idx));
    mag_6MHz_dB = magdB(idx);
    %%%%%%%%%%%%%%%%%%%%%
    % Mark 6MHz out of band tone!
    plot(f_06M/1e6, mag_6MHz_dB, 'ro', 'MarkerSize', 8, 'LineWidth', 3);
    % Text annotation
    text(f_06M/1e6, mag_6MHz_dB, ...
    sprintf("  Otu of band tone Att dB @ %.3f MHz", f_06M/1e6), ...
    'VerticalAlignment', 'bottom', 'Color', 'red', 'FontSize', 12);


    %% Write results to file
    fp = fopen('../ref/golden_output.dat', 'w');
    for n = 1:SAMPLES
        fprintf(fp, '%d %d %d\n', n-1, int16(sig_signed(mod(n-1,length(sig_signed))+1)), output(n));
    end
    fclose(fp);
    fprintf(' Golden reference file generated: golden_output.dat\n\r');
endfunction

