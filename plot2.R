        ##Check if data file exists. If not, provide a message and end the function
        
        if (!file.exists("./household_power_consumption.txt")) {
                stop(paste("household_power_consumption.txt doesn't exist in the working directory ",getwd()))    
        }
        
        ##load data.table library and stop funtion execution if the library is not installed
        
        if (!require(data.table, quietly = TRUE)) {
                stop("Install data.table package before running the function")
        }
        
        ##Load data file. Just 2 dates
        dt <- subset(fread("./household_power_consumption.txt", sep = ";", colClasses=rep("character",9), 
                           stringsAsFactors = FALSE, na.strings = "?"),
                     subset = (Date == "1/2/2007" | Date == "2/2/2007"))
        
        ##convert loaded data.table to data.frame for ease of manipulation
        df <- as.data.frame(dt)
        
        ##add DateTime column as a concatenation of Date and Time
        df <- data.frame(df, DateTime = do.call(paste, df[1:2]), stringsAsFactors = FALSE)
        
        ##convert DateTime column to POSIXlt 
        ##and all numeric columns from character to numeric
        df <- transform(df, DateTime = strptime(DateTime,"%d/%m/%Y %H:%M:%S"),
                        Global_active_power = as.numeric(Global_active_power),
                        Global_reactive_power = as.numeric(Global_reactive_power),
                        Voltage = as.numeric(Voltage),
                        Global_intensity = as.numeric(Global_intensity),
                        Sub_metering_1 = as.numeric(Sub_metering_1),
                        Sub_metering_2 = as.numeric(Sub_metering_2),
                        Sub_metering_3 = as.numeric(Sub_metering_3))
        
        ##open png graphics device with the name plot2.png and resolution 480x480 pixels
        png(filename = "plot2.png", width=480, height=480, units = "px")
        
        ##draw the required plot
        plot(y=df$Global_active_power, 
             x=df$DateTime, 
             type="l", 
             xlab="", 
             ylab="Global Active Power (kilowatts)")
        
        ##write the created plot to disk
        dev.off()      
        message("File plot2.png has been created")
