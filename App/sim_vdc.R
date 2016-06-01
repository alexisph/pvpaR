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

sim_vdc <- function(g, t_mod, v_dc, u_w, beta) {

  # Predicts the expected Vdc from meteorological measurements
  # Returns meas_tc and pred_tc

  t_ref <- 25
  try(log_g <- log10(g), silent = TRUE)
  inv_g <- 1 / g
  d_f <- data.frame(inv_g, log_g)

  # Replace Inf with zeroes
  d_f[mapply(is.infinite, d_f)] <- 0
  d_f[mapply(is.nan, d_f)] <- 0

  # Regress measurements
  d_f <- cbind(d_f, e = 1)
  model <- lm(v_dc ~ d_f$log_g + d_f$inv_g + t_mod + u_w + I(d_f$e))

  # Predict Vdc and calculate temperature corrected Vdc
  n_t <- 1 + (beta / 100 * (t_mod - t_ref))
  pred_tc <- fitted(model) * n_t
  meas_tc <- v_dc * n_t

  data.frame(meas_tc, pred_tc)
}
