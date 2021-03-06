library(dplyr)
# Import data

pow_data <- read.delim(file = "./household_power_consumption.txt",
                       header = TRUE, sep = ";", stringsAsFactors = FALSE,
                       blank.lines.skip = TRUE, strip.white = TRUE)

#Format columns
pow_data$Date_Time <- paste(pow_data$Date,pow_data$Time)
pow_data[,"Date"] <- as.Date(pow_data$Date, "%d/%m/%Y")
pow_data[,"Time"] <- as.POSIXct(strptime(pow_data$Date_Time, format = "%d/%m/%Y %H:%M"))
pow_data[,"Date_Time"] <- NULL

num_cols <- pow_data %>% select_if(is.character) %>% colnames()
pow_data[,num_cols] <- data.frame(sapply(pow_data[,num_cols], as.numeric))

#Filter down to required dates
pow_data <- pow_data %>% select(Date, Time, Global_active_power, Global_reactive_power, Voltage,
                                Global_intensity, Sub_metering_1,
                                Sub_metering_2, Sub_metering_3) %>% filter(Date >= "2007-02-01" & Date <= "2007-02-02")

#Plot graph
png(filename = "plot4.png",height = 1000,width = 1000,)

#Set martgins
par(mfrow = c(2,2), mar = c(5, 4, 4, 2))

#Graph 1
with(pow_data, plot(x = Time, y = Global_active_power,type = "l", xlab = "",
                    ylab = "Global Active Power (kilowatts)"))

#Graph 2
with(pow_data, plot(x = Time, y = Voltage,type = "l", xlab = "datetime",
                    ylab = "Voltage"))

#Graph 3
with(pow_data, plot(x = Time,y = Sub_metering_1,type = "l",xlab = "", ylab = "Energy sub metering"))
points(x = pow_data$Time, y = pow_data$Sub_metering_2, type = "l", col = "red")
points(x = pow_data$Time, y = pow_data$Sub_metering_3, type = "l", col = "blue")
legend("topright", col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),lty = 1)

#Graph 4
with(pow_data, plot(x = Time, y = Global_reactive_power,type = "l", xlab = "datetime"))
dev.off()