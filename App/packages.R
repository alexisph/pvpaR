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

# Load the required packages ----------------------------------------------

if (!require("zoo")) install.packages("zoo")
library(zoo)
if (!require("xts")) install.packages("xts")
library(xts)
if (!require("date")) install.packages("date")
library(date)
if (!require("ggplot2")) install.packages("ggplot2")
library(ggplot2)
if (!require("googleVis")) install.packages("googleVis")
library(googleVis)
if (!require("shinydashboard")) install.packages("shinydashboard")
library(shinydashboard)
if (!require("solaR")) install.packages("solaR")
library(solaR)
if (!require("dygraphs")) install.packages("dygraphs")
library(dygraphs)
if (!require("magrittr")) install.packages("magrittr")
library(magrittr)
if (!require("dplyr")) install.packages("dplyr")
library(dplyr)
