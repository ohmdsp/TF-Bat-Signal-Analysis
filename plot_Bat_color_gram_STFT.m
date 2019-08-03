function plot_color_gram_STFT(gram,data,Fs,interval,int_overlap,titletext,fmax)% Author D.R.Ohm% Sept.3,2004% gram --  a 2-D array of values from TFA_Analysis_complex script, %          arranged by columns of frequency bins vs rows of the center %          analysis time values; each row contains all the frequency bins %          corresponding to a center times. Thus a row index corresponds%          to particular center time and a column index corresponds to a%          particular frequency bin in Hz.% data --  The original data array (data must be complex-valued)% Fs --    The sampling rate in samples per second (Hz)% interval --  The analysis interval used to create gram, in number of%              samples (use same value as entered in the%              TFA_Analysis_complex script% int_overlap  --  The overlap between analysis center times, in number of%                  samples.% titletext -- Title of gram plot entered between quotes ('STFT ...')%**************************************************************************%**************************************************************************Ts=1/Fs;    % sampling interval in sec [n_rows,n_cols]=size(gram);n_step = interval - (interval - int_overlap);max_gram = max(max(abs(gram)));log_gram = 10*log10(abs(gram)/max_gram);dB_top = input('Enter top range in dB (sugest 0): ');dB_bottom = input('Enter bottom range in dB (suggest 50): ');vec = find(log_gram < (-dB_bottom));log_gram(vec) = -dB_bottom*ones(size(vec));vec = find(log_gram > (-dB_top));log_gram(vec) = -dB_top*ones(size(vec));selection = input('Enter 0 for gray scale, 1 for color scale: ');%%% Plot Titlefig1 = figure('PaperOrientation','portrait',...              'PaperPosition',[1.1,1,6.5,9],...              'Position',[10,10,820,620],...              'Units','pixel');fmax=Fs/2/1000;                      % max frequency in KHz tmax = 1000*(n_rows-1)*n_step*Ts;    % max time in seconds %f_axis = (0:n_cols/2)*(Fs/n_cols);  % if real dataf_axis = 1/1000*(-n_cols/2:n_cols/2)*(Fs/n_cols);size(f_axis)axwidth = .64;ax_title = axes('Position',[.2,.97,axwidth,1],...                'Units','normalized',...                'Visible','off');% Figure titletitle_text = text('Position',[.5,0],...                  'Units','normalized',...                  'FontSize',[12],...                  'HorizontalAlignment','center',...                  'VerticalAlignment','bottom',...                  'String','TIME - VS - FREQUENCY  ANALYSIS  GRAM');% Time-vs-frequency gram plotaxbottom = .19;axheight = .73;t_spacing = .1*tmax;  % spacing between time ticks in msf_spacing = (.2*fmax);   % spacing between freq ticks in kHznt_tick = (tmax/t_spacing);YY = t_spacing*(0:nt_tick);nf_tick = (fmax/f_spacing);%% Test to see if data is complex-valuesif any(any(imag(data)~=0))       fmax_b = -fmax;    nf_tick_b = -nf_tick;else    fmax_b = 0;    nf_tick_b = 0;endXX = f_spacing*(nf_tick_b:nf_tick)';ax1 = axes('Position',[.20,axbottom,axwidth,axheight],...           'Units','normalized',...           'FontSize',[12],...           'Box','on',...           'TickDir','out',...           'NextPlot','add',...           'XGrid','off',...           'XLim',[fmax_b,fmax],...           'YLim',[0,tmax],...           'XTick',XX,...           'YTick',YY);%selection=1;if selection == 0    colormap(gray(256));else    map = hsv(329);    colormap(map(256:-1:1,:));endtitle(titletext)set(ax1,'FontSize',[9])t_axis = 1000*(0:n_rows-1)*n_step*Ts;xlabel('Frequency  (kHz)')ylabel('Center Time of Analysis Window  (msec)')imagesc(f_axis,t_axis,log_gram)%% Signal-vs-time plot to left of time-vs-frequency gram plotdata_max = max(abs(data));ax2 = axes('Position',[.01,axbottom,.11,axheight],...           'Units','normalized',...           'Box','on',...           'NextPlot','add',...           'FontSize',[9],...           'XLim',[-data_max,data_max],...           'XDir','reverse',...           'YTickLabelMode','manual',...           'YTickLabel',[],...           'YLim',[0,tmax]);    t_axis = (1:length(data))*Ts*1000;plot(real(data),t_axis,'k')xlabel('In-Phase')%% Signal-vs-time plot to right of time-vs-frequency gram plotdata_max = max(abs(data));ax3 = axes('Position',[.88,axbottom,.11,axheight],...           'Units','normalized',...           'Box','on',...           'NextPlot','add',...           'FontSize',[9],...           'XLim',[-data_max,data_max],...           'XDir','reverse',...           'YTickLabelMode','manual',...           'YTickLabel',[],...           'YLim',[0,tmax]);    t_axis = (1:length(data))*Ts*1000;plot(imag(data),t_axis,'k')xlabel('Quad-Phase')%% Long term FFT of data record plot on bottom of time-vs-frequency gram%% plotfmax = Fs/2;%fft_size = 2^ceil(log(length(data))/log(2));fft_size = 1024;%tfr_long = flipud(perogram(fft_size,1,0,length(data),1,data));dB_range = dB_bottom+20;        % add 20 dB to the bottome of the plotif any(any(imag(data)~=0))    tfr_long = flipud(perogram(fft_size,1,0,length(data),1,data));    freq_axis = (-fft_size/2:fft_size/2-1)*(Fs/(fft_size));    fmax_fft = -fmax;else     tfr_long = (perogram(fft_size,1,0,length(data),1,data));    n_tfr= length(tfr_long);    tfr_long = flipud(tfr_long(1:(n_tfr/2)));    freq_axis = (0:fft_size/2-1).*(Fs/(fft_size));    fmax_fft = 0;endax4 = axes('Position',[.20,.03,axwidth,.09],...           'Units','normalized',...           'Box','on',...           'NextPlot','add',...           'FontSize',[9],...           'TickDir','in',...           'XTickLabelMode','manual',...           'XTickLabel',[],...           'XLim',[fmax_fft,fmax],...           'YLim',[-dB_range,5]);    tfr_norm = tfr_long./(max(tfr_long));log_tfr = 10*log10(tfr_norm);vec = find(log_tfr < (-dB_range));log_tfr(vec) = -dB_range*ones(size(vec));plot(freq_axis,log_tfr,'k')ylabel('Spectrum (dB)')%Color bar legend on left bottomax5 = axes('Position',[.01,.07,.10,.03],...           'Units','normalized',...           'Box','on',...           'NextPlot','add',...           'FontSize',[9],...           'YLim',[1,2],...           'TickDir','out',...           'YTickLabelMode','manual',...           'YTickLabel',[],...           'XLim',[-dB_bottom,-dB_top]);vec = (-dB_bottom:-dB_top)';barr = [vec vec]';imagesc((-dB_bottom:-dB_top),(1:2),barr)xlabel('dB colormap')%% figure(10)% plot(freq_axis,log_tfr,'k')% ylabel('Spectrum (dB)')% xlabel('Frequency (Hz)')