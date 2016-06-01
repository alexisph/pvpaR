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

sim_idc <- function(g_meas, g_sim, t_mod_meas, t_mod_sim, alpha, i_dc) {

  # Calculate temperature corrected Idc using measured and simulated irradiance and
  # module temperature
  # Returns meas_tc and pred_tc

  # Temperature losses
  t_ref <- 25
  n_t_meas <- 1 + (alpha / 100 * (t_mod_meas - t_ref))
  n_t_sim <- 1 + (alpha / 100 * (t_mod_sim - t_ref))

  # Temperature corrected Idc
  meas <- (i_dc * g_meas) / 1000
  pred <- (i_dc * g_sim) / 1000
  meas_tc <- meas * n_t_meas
  pred_tc <- pred * n_t_sim

  data.frame(meas_tc, pred_tc)
}
