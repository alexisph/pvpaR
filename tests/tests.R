source("App/packages.R")
source("App/functions.R")

# Modelling
irrad_sim <- sim_irrad(datIn$ghi, datIn$tamb, lat, tiltPV, azPV, panel_soiling, refl)
str(irrad_sim)

tmod_sim <- sim_tmod(datIn$tmod, datIn$tamb, datIn$gpoa, datIn$uw, datIn$aw, datIn$hrel)
str(tmod_sim)

vdc_sim <- sim_vdc(datIn$gpoa, datIn$tmod, datIn$vdc, datIn$uw, beta)
str(vdc_sim)

idc_sim <- sim_idc(datIn$gpoa, irrad_sim$global, datIn$tmod, tmod_sim, alpha, datIn$idc)
str(idc_sim)

pdc_sim <- sim_pdc(datIn$gpoa, irrad_sim$global, datIn$tmod, tmod_sim, sysArea, gamma, nSTC)
str(pdc_sim)

modelled <- data.frame(irrad_sim = irrad_sim,
                       tmod_sim = tmod_sim,
                       vdc_sim = vdc_sim,
                       idc_sim = idc_sim,
                       pdc_sim = pdc_sim)
str(modelled)
as.zoo(data.frame(global = modelled$irrad_sim.global,
                  direct = modelled$irrad_sim.direct,
                  diffuse = modelled$irrad_sim.diffuse,
                  albedo = modelled$irrad_sim.albedo),
       order.by = index(datIn)) %>% head

# Outliers
irrad_outliers <- outlier_det(datIn$gpoa, irrad_sim$global)
str(irrad_outliers)

tmod_outliers <- outlier_det(datIn$tmod, tmod_sim)
str(tmod_outliers)

vdc_outliers <- outlier_det(vdc_sim$meas_tc, vdc_sim$pred_tc)
str(vdc_outliers)

idc_outliers <- outlier_det(idc_sim$meas_tc, idc_sim$pred_tc)
str(idc_outliers)

pdc_outliers <- outlier_det(pdc_sim$meas_tc, pdc_sim$pred_tc)
str(pdc_outliers)

pac_outliers <- outlier_det(datIn$pdc, datIn$pac)
str(pac_outliers)


# Fault detection
outliers <- data.frame(irrad_outliers = irrad_outliers,
                       tmod_outliers = tmod_outliers,
                       vdc_outliers = vdc_outliers,
                       idc_outliers = idc_outliers,
                       pdc_outliers = pdc_outliers,
                       pac_outliers = pac_outliers)
str(outliers)

ggplot(outliers[1:200, ], aes(x = index(datIn[1:200]))) +
  geom_point(aes(y = ifelse(vdc_outliers.fault, vdc_outliers.corr, NA),
                 col = "red", size = 1.5)) +
  geom_line(aes(y = vdc_outliers.corr)) +
  theme(legend.position = "none")

# Fault classification
fault_class <- fault_classification(datIn$gpoa,
                                    pdc_sim$meas_tc,
                                    irrad_sim$global,
                                    pdc_sim$pred_tc,
                                    idc_sim$meas_tc,
                                    idc_sim$pred_tc,
                                    vdc_sim$meas_tc,
                                    vdc_sim$pred_tc,
                                    sysWp)
str(fault_class)
names(fault_class)

ggplot(fault_class, aes(x = index(datIn))) +
  geom_line(aes(y = elc)) +
  geom_line(aes(y = elc_lim_up, colour = "red")) +
  geom_line(aes(y = elc_lim_down, colour = "red")) +
  theme(legend.position = "none")

ggplot(fault_class, aes(x = index(datIn))) +
  geom_point(aes(y = short_circuit)) +
  geom_point(aes(y = disconnection)) +
  geom_point(aes(y = shading)) +
  theme(legend.position = "none")
