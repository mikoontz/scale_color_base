### Title: How to create a color ramp in base R
###
### Author: Michael Koontz
### Email: mikoontz@gmail.com
###
### Date Created: 20150922
### Last Modified: 20151017
###
### Intention: Convenient wrapper function to make a color ramp in base R. Takes a vector of values, a character vector of colors to map to, an optional new numeric range to map to (useful for fixing a numeric range to make two separate vectors comparable), an optional na.rm, and a transparency option.

scale_color_base <- function(value, colors=c("black", "white"), new_range=NA, na.rm=FALSE, alpha=1)
{
  if (any(is.na(new_range))) {
  # Values need to be between 0 and 1
    recast_value <- (value-min(value, na.rm=na.rm)) / max(value-min(value, na.rm=na.rm), na.rm=na.rm)
  }
  else {
    recast_value <- (value - new_range[1]) / (diff(new_range))
    recast_value[recast_value < 0] <- 0
    recast_value[recast_value > 1] <- 1
    
  }
  # Use the colorRamp function to create a function that will parse values into a 3-column matrix of rgb fields. Specify the range that the colors should span (low to high)
  color_fnc <- colorRamp(colors=colors)

  # Define the plot colors by calling the rgb() function. Divide the 3-column matrix result of color.fnc by 255 such that values remain between 0 and 1.
  plot_colors <- rgb(color_fnc(recast_value)/255, alpha=alpha)
  
  return (plot_colors)
}

#-------------
# Example use
#-------------

set.seed(0727)
# Vector to that we want mapped to a color palette
n <- runif(20, min=-20, max=20)

# Default is black to white
plot(n, col=scale_color_base(n), pch=19)

# Colors can be set using the colors= argument
plot(n, col=scale_color_base(n, colors=c("blue", "red")), pch=19)

# More than two colors are possible
plot(n, col=scale_color_base(n, colors=c("blue", "purple", "red")), pch=19)

# Recasting subtracts the minimum from all elements of the value vector and divides by the maximum of the frame-shifed vector. Use na.rm=TRUE if there are NAs.
range(n)

plot(n, col=scale_color_base(n, colors=c("blue", "purple", "red"), new_range=c(-50, 0)), pch=19)