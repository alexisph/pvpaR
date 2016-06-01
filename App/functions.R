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

source("sim_vdc.R")
source("sim_idc.R")
source("sim_pdc.R")
source("sim_tmod.R")
source("sim_irrad.R")
source("outlier_det.R")
source("fault_classification.R")

# Create a dark theme for graphs
dark_theme <- theme_dark() %+% theme(panel.grid.minor = element_line(colour = "grey55", size = 0.125),
                                     panel.grid.major = element_line(colour = "grey50", size = 0.25),
                                     text = element_text(colour = "grey80"),
                                     axis.text = element_text(colour = "grey70"))

# Create a light theme for graphs
light_theme <- theme_dark()

# Create a transparent theme for graphs
trans_theme <- theme(panel.background = element_rect(fill = NA), plot.background = element_blank())
