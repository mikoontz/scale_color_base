### Title: How to create a color ramp in base R
###
### Author: Michael Koontz
### Email: mikoontz@gmail.com
###
### Date Created: 20150922
### Last Modified: 20150922
###
### Intention: Demonstrate how to map values from a vector to a custom color ramp

scale_color_base <- function(value, colors=c("black", "white"), na.rm=FALSE, alpha=1)
{
  # Values need to be between 0 and 1
  recast_value <- (value-min(value, na.rm=na.rm)) / max(value-min(value, na.rm=na.rm), na.rm=na.rm)

  # Use the colorRamp function to create a function that will parse values into a 3-column matrix of rgb fields. Specify the range that the colors should span (low to high)
  color_fnc <- colorRamp(colors=colors)

  # Define the plot colors by calling the rgb() function. Divide the 3-column matrix result of color.fnc by 255 such that values remain between 0 and 1.
  plot_colors <- rgb(color_fnc(recast_n)/255, alpha=alpha)
  
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

