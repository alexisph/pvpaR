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

sim_pdc <- function(g_meas, g_sim, t_mod_meas, t_mod_sim, area, gamma, n_stc) {

  # Calculates temperature corrected Pdc using measured and simulated irradiance
  # and module temperature
  # Returns meas_tc and pred_tc

  # Temperature losses
  t_ref <- 25
  n_t_meas <- 1 + (gamma / 100 * (t_mod_meas - t_ref))
  n_t_sim <- 1 + (gamma / 100 * (t_mod_sim - t_ref))

  # Simple efficiency model
  meas_tc <- g_meas * n_t_meas * area * n_stc
  pred_tc <- g_sim * n_t_sim * area * n_stc

  data.frame(meas_tc, pred_tc)
}
