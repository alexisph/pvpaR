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

outlier_det <- function(sim, meas) {

  # Determine erroneous measurements
  # Returns fault instances and corrected values

  # Model sim ~ meas
  model <- lm(sim ~ meas)
  slope <- model$coefficients[2]
  intercept <- model$coefficients[1]

  # Add a 25% threshold to the slope
  limit_up <- ((slope * 1.25) * sim) + intercept + intercept * 2
  limit_down <- ((slope * 0.75) * sim) + intercept - intercept * 2

  # Mark faulty operation
  fault <- meas > limit_up | meas < limit_down
  corr <- ifelse(fault, (slope * sim) + intercept, meas)

  data.frame(fault, corr)
}
