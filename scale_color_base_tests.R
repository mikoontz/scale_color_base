### Title: scale_color_base() tests
###
### Author: Michael Koontz
### Email: mikoontz@gmail.com
### Twitter: @_mikoontz
###
### Date Created: 20151110
### Last Updated: 20151110
###
### Description: Test cases for scale_color_base() function, which maps values in a numeric vector to a user defined range and user defined color palette

#--------
# The function
#--------

scale_color_base <- function(value, colors=c("white", "black"), na.rm=FALSE, mapToRange=range(value, na.rm=na.rm), alpha=1)
{
  if (na.rm==FALSE & any(is.na(value)))
    stop("There are NAs in your vector. Using na.rm=TRUE will remove them for the mapping calculations, but add them back in in the final vector. Try that.")
  
  recast_value <- (value[!is.na(value)] - mapToRange[1]) / (diff(mapToRange))
  recast_value[recast_value < 0] <- 0
  recast_value[recast_value > 1] <- 1

  color_fnc <- colorRamp(colors=colors)
  
  plot_colors <- rep("NA", length(value))
  plot_colors[!is.na(value)] <- rgb(color_fnc(recast_value)/255, alpha=alpha)
  
  return (plot_colors)
}

#------- 
# End function
#-------

#-------
# Default case
#-------

x <- 1:50
y <- rep(1, 50)

plot(x, y, pch=19, col=scale_color_base(x))
value=x
#-------
# End default case
#-------

#-------
# Start 2 custom color case
#-------

plot(x, y, pch=19, col=scale_color_base(x, colors=c("blue", "red")))

#-------
# End 2 custom color case
#-------

#-------
# Start 3 custom color case
#-------

plot(x, y, pch=19, col=scale_color_base(x, colors=c("blue", "green", "red")))

#-------
# End 3 custom color case
#-------

#-------
# Start NA case
#-------

# Turn half of the points into NAs
x[sample(50, 25)] <- NA

# Without explicitly calling na.rm=TRUE, this breaks.
plot(x, y, pch=19, col=scale_color_base(x, colors=c("blue", "green", "red")))

plot(x, y, pch=19, col=scale_color_base(x, colors=c("blue", "green", "red"), na.rm=TRUE))

#-------
# End NA case
#-------

#-------
# Start alpha case
#-------

# Adjust transparency when there are a lot of points

x <- 1:100
y <- 1:100
xy <- expand.grid(x=x, y=y)
plot(xy$x, xy$y, pch=19, col=scale_color_base(1:10000))
