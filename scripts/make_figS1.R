
if(!exists('root'))
	root <- here::here()

samples = list.files(file.path(root, 'Data', 'FigS1', 'Run 1'), full.names = TRUE)

gs1 <- list()

for(i in 1:length(samples)){
	log = read.csv(samples[i], skip = 1)
	log$date = lubridate::mdy_hms(log$Date.Time..GMT.04.00)
	log = log[log$date <= lubridate::ymd_hms('2015-08-03 16:00:00'), ]
	log$temp = log[, grep('Temp', colnames(log))]
	
	gs1[[i]] <- ggplot(log, aes(date, temp)) +
		geom_line() +
		labs(x = 'Date',
	       y = 'Temperature (°C)', 
	       title = paste('Experiment_1', gsub('.csv', '', basename(samples[i])))) +
		ylim(c(12, 24))
}



samples = list.files(file.path(root, 'Data', 'FigS1', 'Run 2'), full.names = TRUE)

for(i in 1:length(samples)){
	log = read.csv(samples[i])
	log$Date = lubridate::mdy_hm(log$Date)
	log = log[log$Date <= lubridate::ymd_hms('2017-08-31 15:02:00'), ]
	
	gs1[[i + 6]] <- ggplot(log, aes(Date, Value)) +
		geom_line() +
		labs(x = 'Date',
	       y = 'Temperature (°C)', 
	       title = paste('Experiment_2', gsub('.csv', '', basename(samples[i])))) +
		ylim(c(12, 24))
}

#dev.copy2pdf(file = 'figS1.pdf', height = 10, width = 12)





















# samples = list.files('make_FigS1/Run 1', full.names = TRUE)
# d = lapply(samples, function(i){
# 	log = read.csv(i, skip = 1)
# 	log$date = lubridate::mdy_hms(log$Date.Time..GMT.04.00)
# 	log = log[log$date <= lubridate::ymd_hms('2015-08-03 16:00:00'), ]
# 	log$temp = log[, grep('Temp', colnames(log))]
# 	log$trial = 'Experiment 1'
# 	log$repl = gsub('.csv', '', basename(i))
# 	return(log[, c('trial', 'repl', 'date', 'temp')])
# })
# d = do.call('rbind', d)

# exp1 = ggplot(d, aes(date, temp)) +
# 	geom_path() +
# 	facet_wrap(~repl) +
# 	labs(x = 'Date', y = 'Temperature (°C)') +
# 	scale_x_datetime(date_minor_breaks = '1 day')




# samples = list.files('make_FigS1/Run 2', full.names = TRUE)
# d = lapply(samples, function(i){
# 	log = read.csv(i)
# 	log$date = lubridate::mdy_hm(log$Date)
# 	log = log[log$date <= lubridate::ymd_hms('2017-08-31 15:02:00'), ]
# 	log$temp = log$Value
# 	log$trial = 'Experiment 2'
# 	log$repl = gsub('.csv', '', basename(i))
# 	return(log[, c('trial', 'repl', 'date', 'temp')])
# })
# d = do.call('rbind', d)

# d = filter(d, temp <= 24)

# exp2 = ggplot(d, aes(date, temp)) +
# 	geom_path() +
# 	facet_wrap(~repl) +
# 	labs(x = 'Date', y = 'Temperature (°C)') +
# 	scale_x_datetime(date_minor_breaks = '1 day')

# cowplot::plot_grid(exp1, exp2, ncol = 1)
# ggsave(filename = 'figS1.pdf', height = 8, width = 12)
