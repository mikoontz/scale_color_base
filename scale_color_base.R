### Title: scale_color_base() function
###
### Author: Michael Koontz
### Email: mikoontz@gmail.com
###
### Date Created: 20150922

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