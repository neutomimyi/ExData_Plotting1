
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
        
        ##open png graphics device with the name plot4.png and resolution 480x480 pixels
        png(filename = "plot4.png", width=480, height=480, units = "px", type = "cairo")
        
        ##set up structure how multiple plots will be located on the graphics device
        par(mfrow = c(2,2))
        
        ##draw first plot. Global Active Power
        plot(x=df$DateTime,
             y=df$Global_active_power,
             type="l",
             xlab = "",
             ylab="Global Active Power")
        
        ##draw second plot on the first row. Voltage
        plot(x = df$DateTime,
             y = df$Voltage,
             type = "l",
             xlab = "datetime",
             ylab = "Voltage")
        
        ##Draw the thirt plot. Energy sub metering
        
        ##draw the plot for sub_metering_1
        plot(y=df$Sub_metering_1, 
             x=df$DateTime, 
             type="l", 
             col = "black",
             xlab="",
             ylab="Energy sub metering")
        
        ##draw line for Sub_metering_2 in red
        lines(x=df$DateTime, y=df$Sub_metering_2, col="red")
        
        ##draw line for Sub_metering_3 in blue
        lines(x=df$DateTime, y=df$Sub_metering_3, col="blue")
        
        ##add legend
        legend("topright", 
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
               col=c("black", "red", "blue"), 
               lty=1,
               bty = "n")
        
        ##Draw the forth plot. Global_reactive_power
        plot(x = df$DateTime,
             y = df$Global_reactive_power,
             type = "n",
             xlab = "datetime",
             ylab = "Global_reactive_power")
        lines(x = df$DateTime,
              y = df$Global_reactive_power,col="black", lwd=1)
        
        ##write the created plot to disk
        dev.off()      
        message("File plot4.png has been created")
