# OpenTempus-DataScience

OpenTempus long-term (annual) weather forecast for temperature and rainfall in order to help smallholder farmers make better decisions about what to and when to plant for a given location.

The OpenTempus DataScience R scripts can be run with the following instructions:

## Pre-requisites
Install R libraries jsonlite, forecast & nasapower.
While installing forecasting library for R versions > 4.0.0, compilation from source is known to fail.
Binary versions < 8.16 can be installed.

## Setup and Running the R Script
### R-Studio:
Set the working directory in the script where you want the output files to be saved.
Running from R Studio is very simple, select the script and press the run button to generate the results.
At times, connection with nasapower may timout, check for timeout error in the console log and you may have to run the script again.

### CMD Line:
While running from the command line, mirrors are required to be provided, you may choose a mirror nearst to your location.
Set the working directory in the script.
The script can be executed as: Rscript myscript.R


## Setup and Running the R Script in a Docker Container
While running the script in a docker container, the libraries mentioned in the docker file are required.
The script is tested with r-base docker image. After the execution is complete, the container will shutdown, so it is advisible to use bind mounts to store the results from the script.
