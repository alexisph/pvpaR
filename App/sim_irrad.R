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

sim_irrad <- function(ghi, tamb, lat, tiltPV, azPV, panel_soiling, refl) {

  # Transposes GHI to POA
  # Returns the modelled POA irradiance

  # Use local2solar to convert the time zone of a POSIXct object to the mean solar time
  # and set its time zone to UTC as a synonym of mean solar time.
  # It includes two corrections: the difference of longitudes between the location and
  # the time zone, and the daylight saving time.

  # The function CBIND combines several objects (zoo, data.frame or matrix) preserving
  # the index of the first of them or asigning a new one with the index argument.

  solarf <- as.zoo(merge(G0 = as.xts(lag.xts(ghi, k = 1)), Ta = as.xts(tamb)))
  gef <- calcGef(lat, modeTrk = "fixed", modeRad = "bdI", dataRad = solarf,
                 keep.night = TRUE, beta = tiltPV, alfa = azPV, iS = panel_soiling,
                 alb = refl, horizBright = TRUE, HCPV = FALSE)

  gpoa_sim <- as.zooI(gef, complete = TRUE)[, c("Gef", "Bef", "Def",
                                                "Dief", "Dcef", "Ref")]
  colnames(gpoa_sim) <- c("global", "direct", "diffuse",
                          "diffuse_iso", "diffuse_aniso", "albedo")
  data.frame(gpoa_sim)
}
