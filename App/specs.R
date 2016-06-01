# Copyright (c) 2014--2016 Alexander Phinikarides <alexisph@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# Spec file ---------------------------------------------------------------

rm(list=ls())

Sys.setenv(TZ = "Etc/GMT+2")    # measurements time zone. see OlsonNames()
lat <- 35.146141                # latitude [DDD.dddddd]
lon <- 33.416916                # longitude [DDD.dddddd]
tiltPV <- 27.5                  # pv array tilt angle [deg]
azPV <- 0                       # pv array azimuth [deg]
refl <- 0.4                     # ground reflectance
panel_soiling <- 2          # pv panel soiling [1=none, 4=max]
dtGMT <- lon %/% 15

nSer <- 4                       # number of pv modules in series
modWp <- 250                    # module Pmax [W]
sysWp <- nSer * modWp
currMpp <- 4.37                 # module Impp [A]
len <- 1.605                    # module length [m]
wid <- 1.336                    # module width [m]
modArea <- len * wid
sysArea <- modArea * nSer
alpha <- 0.1                    # module Isc temperature coefficient [%/K]
beta <- -0.38                   # module Voc temperature coefficient [%/K]
gamma <- -0.47                  # module Pmpp temperature coefficient [%/K]
nSTC <- modWp / modArea / 1000


# Load data ---------------------------------------------------------------

# An example of reading a csv file
# datIn <- read.zoo(gzfile("../input/data3.csv.gz"),
#                   format = "%d/%m/%Y %H:%M",
#                   sep = ",", tz = "Etc/GMT+2", dec = ".", header = TRUE)
# colnames(datIn) <- c("vdc", "idc", "pdc", "pac", "tmod", "gpoa",
#                      "gref", "uw", "aw", "tamb", "hrel", "ghi")

# Load the included data set
datIn <- readRDS(file = "../input/data3.rds")
