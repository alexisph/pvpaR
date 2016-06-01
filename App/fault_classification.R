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

fault_classification <- function(g_meas, p_dc_meas, g_sim, p_dc_sim, i_dc_meas,
                                 i_dc_sim, v_dc_meas, v_dc_sim, p_max) {

  # Fault classification methodology, based on S. Silvestre, A. Chouder,
  # and E. Karatepe, "Automatic fault detection in grid connected PV systems,"
  # Sol. Energy, vol. 94, pp. 119–127, 2013.

  # Capture losses
  yr_meas <- g_meas / 1000
  yr_sim <- g_sim / 1000
  ya_meas <- p_dc_meas / p_max
  ya_sim <- p_dc_sim / p_max
  lc_meas <- yr_meas - ya_meas
  lc_sim <- yr_sim - ya_sim

  # Error parameters
  elc <- ifelse(lc_sim == 0, 0, abs(lc_meas - lc_sim))
  ei <- abs(i_dc_meas - i_dc_sim)
  ev <- abs(v_dc_meas - v_dc_sim)
  ei[is.nan(ei)] <- 0
  elc[mapply(is.infinite, elc)] <- 0
  ei[mapply(is.infinite, ei)] <- 0
  ev[mapply(is.infinite, ev)] <- 0

  # Thresholds for identifying faults
  elc_lim_up <- mean(elc, na.rm = TRUE) + 2 * sqrt(var(elc, na.rm = TRUE))
  elc_lim_down <- mean(elc, na.rm = TRUE) - 2 * sqrt(var(elc, na.rm = TRUE))
  ei_lim_up <- mean(ei, na.rm = TRUE) + 2 * sqrt(var(ei, na.rm = TRUE))
  ei_lim_down <- mean(ei, na.rm = TRUE) - 2 * sqrt(var(ei, na.rm = TRUE))
  ev_lim_up <- mean(ev, na.rm = TRUE) + 2 * sqrt(var(ev, na.rm = TRUE))
  ev_lim_down <- mean(ev, na.rm = TRUE) - 2 * sqrt(var(ev, na.rm = TRUE))

  # Mark faulty operation
  alarm <- elc > elc_lim_up | elc < elc_lim_down
  curr_fault <- ei > ei_lim_up | ei < ei_lim_down
  volt_fault <- ev > ev_lim_up | ev < ev_lim_down

  # Classify faults
  false_alarm <- alarm & curr_fault & volt_fault
  short_circuit <- alarm & curr_fault & !volt_fault
  disconnection <- alarm & !curr_fault & volt_fault
  shading <- alarm & !curr_fault & !volt_fault

  data.frame(elc, elc_lim_up, elc_lim_down,
             ei, ei_lim_up, ei_lim_down,
             ev, ev_lim_up, ev_lim_down,
             alarm, curr_fault, volt_fault,
             false_alarm, short_circuit, disconnection, shading)
}
