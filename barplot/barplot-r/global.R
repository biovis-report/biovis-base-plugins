library(configr)
library(dplyr)

config <- read.config(file = 'shiny.ini')
dataConfig <- config$data
attributes <- config$attributes

if (dataConfig$dataType == 'rds') {
    rawData <- readRDS(dataConfig$dataFile)
} else if (dataConfig$dataType == 'csv') {
    rawData <- read.csv(dataConfig$dataFile, header=TRUE)
}

getVector <- function(value) {
    if (!is.null(value)) {
        return(as.vector(as.matrix(value)))
    } else {
        return(NULL)
    }
}

getBool <- function(value) {
    if (value %in% c('True', 'TRUE', 'T', '1')) {
        return(TRUE)
    } else {
        return(FALSE)
    }
}

getInt <- function(value) {
    int <- as.integer(value)
    if (is.na(int)) {
        return(1)
    } else {
        return(int)
    }
}

getDouble <- function(value) {
    double <- as.double(value)
    if (is.na(double)) {
        return(0.01)
    } else {
        return(double)
    }
}

data <- rawData

attrs <- list(
    title=getVector(attributes$title),
    subtitle=getVector(attributes$subtitle),
    xyLabelsize=getInt(getVector(attributes$xyLabelsize)),
    xyTitleSize=getInt(getVector(attributes$xyTitleSize)),
    legendLabelsize=getInt(getVector(attributes$legendLabelsize)),
    errorBarWidth=getDouble(getVector(attributes$errorBarWidth)),
    text=getVector(attributes$text),
    xTitle=getVector(attributes$xTitle),
    xAngle=getInt(getVector(attributes$xAngle)),
    yTitle=getVector(attributes$yTitle),
    queryURL=getVector(attributes$queryURL),
    showpanel=getBool(getVector(attributes$showpanel)),
    enableSE=getBool(getVector(attributes$enableSE))
)

rawColnames <- colnames(data)
for (col in c('xAxis', 'yAxis', 'colorAttr')) {
    colname <- getVector(attributes[col])
    if (is.null(colname) || !(colname %in% rawColnames)) {
        if (col == 'xAxis' || col == 'yAxis') {
            stop("You must specify xAxis and yAxis in shiny.ini.")
        } else {
            attrs[col] <- 'None'
        }
    } else {
        attrs[col] <- colname
    }
}
