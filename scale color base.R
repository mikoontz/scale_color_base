### Title: How to create a color ramp in base R
###
### Author: Michael Koontz
### Email: mikoontz@gmail.com
###
### Date Created: 20150922
### Last Modified: 20151018
###
### Intention: Convenient wrapper function to make a color ramp in base R. Takes a vector of values, a character vector of colors to map to, an optional new numeric range to map to (useful for fixing a numeric range to make two separate vectors comparable), an optional na.rm, and a transparency option.

# Returns
#   a character value of hex color values with a length equal to the length of value where each color value represents the mapping of each value to a continuous color palette.

# Arguments 
#   value is a vector of numeric values

#   colors is a vector of colors that gets passed to colorRamp for interpolation. Can be a character vector of color names, a character vector of hex values, or numeric vector of positive integers. Lower values map to the first elements of the vector, higher values map to the last elements of the vector. Default is palette is white to black. 

#   na.rm gets passed to the range function via the mapToRange argument. Using na.rm=TRUE is required if you want the function to ignore NAs and map to non-NA values. Default is FALSE.

#   mapToRange is a 2-element numeric vector representing the minimum and maximum (in that order) fixed numeric range to map the values to.  Passing the result of any call to range() would be sufficient. Example: range(c(vector1, vector2)) gets the overall range for both vectors. The default is the vector returned by calling the range() function on the supplied value= argument.
#   alpha is a transparency option. Useful when lots of points are being plotted. Default is 1 (totally opaque).

scale_color_base <- function(value, colors=c("white", "black"), na.rm=FALSE, mapToRange=range(value, na.rm=na.rm), alpha=1)
{
  # Check whether there are NAs in the value vector and the user did NOT specify to deal with them. Error results if both of these are true
    if (na.rm==FALSE & any(is.na(value)))
      stop("There are NAs in your vector. Using na.rm=TRUE will remove them for the mapping calculations, but add them back in in the final vector. Try that.")
  
  # Recasting subtracts the minimum from all elements of the value vector and divides by the maximum of the frame-shifed vector. Use na.rm=TRUE if there are NAs. The result is a vector with a length of length(value) of 0's and 1's. Values below the minimum value get a 0 and values above the maximum value get a 1.
    recast_value <- (value[-which(is.na(value))] - mapToRange[1]) / (diff(mapToRange))
    recast_value[recast_value < 0] <- 0
    recast_value[recast_value > 1] <- 1

    # Use the colorRamp function to create a function that will parse values into a 3-column matrix of rgb fields. Specify the range that the colors should span (low to high)
    color_fnc <- colorRamp(colors=colors)

  # Set up storage vector of plot colors starting with all NAs. The non-NA colors will be put into their appropriate position in the vector  
    plot_colors <- rep("NA", length(value))
  
  # Define the plot colors by calling the rgb() function. Divide the 3-column matrix result of color.fnc by 255 such that values remain between 0 and 1. Refill the storage vector only in the places where the value vector wasn't an NA.
    plot_colors[-which(is.na(value))] <- rgb(color_fnc(recast_value)/255, alpha=alpha)
  
    return (plot_colors)
}