### Title: Raw R script of scale_color_base() function examples
###
### Author: Michael Koontz
### Email: mikoontz@gmail.com
###
### Date Created: 20151018
### Last Modified: 20171120
###
### Intention: Example uses of convenience function for base R that maps values to a continuous palette.

### Function description: scale_color_base() is a convenient wrapper function to make a color ramp in base R. Takes a vector of values, a character vector of colors to map to, an optional new numeric range to map to (useful for fixing a numeric range to make two separate vectors comparable), an optional na.rm, and a transparency option.

# Returns
#   a character value of hex color values with a length equal to the length of value where each color value represents the mapping of each value to a continuous color palette.

# Arguments 
#   value is a vector of numeric values

#   colors is a vector of colors that gets passed to colorRamp for interpolation. Can be a character vector of color names, a character vector of hex values, or numeric vector of positive integers. Lower values map to the first elements of the vector, higher values map to the last elements of the vector. Default is palette is white to black. 

#   na.rm gets passed to the range function via the mapToRange argument. Using na.rm=TRUE is required if you want the function to ignore NAs and map to non-NA values. Default is FALSE.

#   mapToRange is a 2-element numeric vector representing the minimum and maximum (in that order) fixed numeric range to map the values to.  Passing the result of any call to range() would be sufficient. Example: range(c(vector1, vector2)) gets the overall range for both vectors. The default is the vector returned by calling the range() function on the supplied value= argument.

#   alpha is a transparency option. Useful when lots of points are being plotted. Default is 1 (totally opaque).

# printRecast is a logical that specifies whether the recast values are to be printed to the console. This might be useful when determining how a particular numeric vector might be mapped to a new range (when also using mapToRange= argument)


scale_color_base <- function(value, colors=c("white", "black"), na.rm=FALSE, mapToRange=range(value, na.rm=na.rm), alpha=1, printRecast=FALSE)
{
  # Check whether there are NAs in the value vector and the user did NOT specify to deal with them. Error results if both of these are true
  if (na.rm==FALSE & any(is.na(value)))
    stop("There are NAs in your vector. Using na.rm=TRUE will remove them for the mapping calculations, but add them back in in the final vector. Try that.")
  
  # Recasting subtracts the minimum from all elements of the value vector and divides by the maximum of the frame-shifed vector. Use na.rm=TRUE if there are NAs. The result is a vector with a length of length(value) of 0's and 1's. Values below the minimum value get a 0 and values above the maximum value get a 1.
  recast_value <- (value[!is.na(value)] - mapToRange[1]) / (diff(mapToRange))
  recast_value[recast_value < 0] <- 0
  recast_value[recast_value > 1] <- 1
  
  # Use the colorRamp function to create a function that will parse values into a 3-column matrix of rgb fields. Specify the range that the colors should span (low to high)
  color_fnc <- colorRamp(colors=colors)
  
  # Set up storage vector of plot colors starting with all NAs. The non-NA colors will be put into their appropriate position in the vector  
  plot_colors <- rep("NA", length(value))
  
  # Define the plot colors by calling the rgb() function. Divide the 3-column matrix result of color.fnc by 255 such that values remain between 0 and 1. Refill the storage vector only in the places where the value vector wasn't an NA.
  plot_colors[!is.na(value)] <- rgb(color_fnc(recast_value)/255, alpha=alpha)

  # Print the recast_value if the printRecast argument is TRUE
  if (printRecast) {
    print(recast_value)
  }
  
  return (plot_colors)
}

#-------------
# Example use
#-------------

set.seed(0727)
# Vector to that we want mapped to a color palette
n <- runif(20, min=-20, max=20)

# Default is white to black
plot(n, col=scale_color_base(n), pch=19)

# Colors can be set using the colors= argument
plot(n, col=scale_color_base(n, colors=c("blue", "red")), pch=19)

# More than two colors are possible
plot(n, col=scale_color_base(n, colors=c("blue", "purple", "red")), pch=19)



# Fix the numeric range to map the values to. Useful for comparing two vectors with the same color palette.
par(mfrow=c(1,2))
x <- 1:50
y <- seq(from=1, to=2, by=0.05)
xy <- expand.grid(x, y)
names(xy) <- c("x", "y")

plot(x=xy$x, y=xy$y, pch=19)

# Use the scale_color_base() function to map to the range of the x*y values
plot(x=xy$x, y=xy$y, pch=19, col=scale_color_base((xy$y), colors=c("blue", "red")))

# New variable y2 is 0.5 greater (50% of original range) than y. Mapping to its range will show the exact same plot as when the range was 1 to 2 as when the range is 1.5 to 2.5:
xy$y2 <- xy$y + 0.5
plot(x=xy$x, y=xy$y2, pch=19, col=scale_color_base((xy$y2), colors=c("blue", "red")))

# But if we want to compare the two ranges side by side, we want the color palette to reflect that the second range is greater than the first. So we can use the mapToRange to fix the range that we want to map the values of each vector to.
par(mfrow=c(1,2))
# The range we want to map to is the min and max of the WHOLE range of the data, including both vectors.
new_range <- range(c(xy$y, xy$y2))
new_range

plot(x=xy$x, y=xy$y, pch=19, col=scale_color_base((xy$y), colors=c("blue", "red"), mapToRange=new_range))

plot(x=xy$x, y=xy$y2, pch=19, col=scale_color_base((xy$y2), colors=c("blue", "red"), mapToRange=new_range))