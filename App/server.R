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

shinyServer(
  function(input, output) {
    source("functions.R")
    # plot_theme <- dark_theme + trans_theme
    theme_set(light_theme %+% trans_theme)

    # Selected date range -----------------------------------------------------

    # Reactive object returning the data of the selected range
    dataWithNA_range <- reactive({
      sp <- as.POSIXct(input$dateRange[1])
      ep <- as.POSIXct(input$dateRange[2])
      window(datIn, start = sp + dtGMT * 3600, end = ep + dtGMT * 3600)
    })

    #reactive object returning the data without NA on the selected range
    dataWithoutNA_range <- reactive({
      sp <- as.POSIXct(input$dateRange[1])
      ep <- as.POSIXct(input$dateRange[2])
      window(na.omit(datIn), start = sp + dtGMT * 3600, end = ep + dtGMT * 3600)
    })


    # Print the PV system specs table and map ---------------------------------

    output$location <- renderTable({
      data.frame(Longitude = sprintf("%.6f", lon),
                 Latitude = sprintf("%.6f", lat),
                 row.names = NULL)
    })

    output$system_map <- renderGvis({
      d_f <- data.frame(loc = paste(lat, lon, sep = ":"), tip = "PV system")
      gvisMap(d_f, "loc", "tip", options = list(showTip = TRUE,
                                                showLine = FALSE,
                                                enableScrollWheel = TRUE,
                                                mapType = "hybrid",
                                                useMapTypeControl = FALSE,
                                                zoomLevel = 19))
    })

    output$specs <- renderTable({
      data.frame(
        Variable = c(
          "PV array tilt angle [°]:",
          "PV array azimuth [°]:",
          "Reflection losses:",
          "Modules in series:",
          "Module Pmax [W]:",
          "Module Impp [A]:",
          "Module efficiency [%]:",
          "Isc temp. coef. [%/°C]:",
          "Voc temp. coef. [%/°C]:",
          "Pmax temp. coef. [%/°C]:"),
        Value = as.character(c(
          sprintf("%.2f", tiltPV),
          sprintf("%.2f", azPV),
          sprintf("%.2f", refl),
          nSer,
          modWp,
          sprintf("%.2f", currMpp),
          sprintf("%.2f", nSTC * 100),
          sprintf("%.2f", alpha),
          sprintf("%.2f", beta),
          sprintf("%.2f", gamma))),
        stringsAsFactors = FALSE, row.names = NULL)
    })


    # Missing data ------------------------------------------------------------

    output$missing_vdc <- renderTable({
      vdc <- data.frame(var = dataWithNA_range()$vdc[is.na(dataWithNA_range()$vdc)])
      if(nrow(vdc) != 0) vdc
    })

    output$missing_idc <- renderTable({
      idc <- data.frame(var = dataWithNA_range()$idc[is.na(dataWithNA_range()$idc)])
      if(nrow(idc) != 0) idc
    })

    output$missing_pdc <- renderTable({
      pdc <- data.frame(var = dataWithNA_range()$pdc[is.na(dataWithNA_range()$pdc)])
      if(nrow(pdc) != 0) pdc
    })

    output$missing_pac <- renderTable({
      pac <- data.frame(var = dataWithNA_range()$pac[is.na(dataWithNA_range()$pac)])
      if(nrow(pac) != 0) pac
    })

    output$missing_tmod <- renderTable({
      tmod <- data.frame(var = dataWithNA_range()$tmod[is.na(dataWithNA_range()$tmod)])
      if(nrow(tmod) != 0) tmod
    })

    output$missing_gpoa <- renderTable({
      gpoa <- data.frame(var = dataWithNA_range()$gpoa[is.na(dataWithNA_range()$gpoa)])
      if(nrow(gpoa) != 0) gpoa
    })

    output$missing_gref <- renderTable({
      gref <- data.frame(var = dataWithNA_range()$gref[is.na(dataWithNA_range()$gref)])
      if(nrow(gref)!= 0) gref
    })

    output$missing_ghi <- renderTable({
      ghi <- data.frame(var = dataWithNA_range()$ghi[is.na(dataWithNA_range()$ghi)])
      if(nrow(ghi) != 0) ghi
    })

    output$missing_uw <- renderTable({
      uw <- data.frame(var = dataWithNA_range()$uw[is.na(dataWithNA_range()$uw)])
      if(nrow(uw) != 0) uw
    })

    output$missing_aw <- renderTable({
      aw <- data.frame(var = dataWithNA_range()$aw[is.na(dataWithNA_range()$aw)])
      if(nrow(aw) != 0) aw
    })

    output$missing_tamb <- renderTable({
      tamb <- data.frame(var = dataWithNA_range()$tamb[is.na(dataWithNA_range()$tamb)])
      if(nrow(tamb) != 0) tamb
    })

    output$missing_hrel <- renderTable({
      hrel <- data.frame(var = dataWithNA_range()$hrel[is.na(dataWithNA_range()$hrel)])
      if(nrow(hrel) != 0) hrel
    })


    # Calculate the performance and detect the faults -------------------------

    # Model results
    modelled <- reactive({
      if(length(dataWithoutNA_range()) != 0) {
        irrad_sim <- sim_irrad(dataWithoutNA_range()$ghi, dataWithoutNA_range()$tamb,
                               lat, tiltPV, azPV, input$panel_soiling, refl)
        tmod_sim <- sim_tmod(dataWithoutNA_range()$tmod, dataWithoutNA_range()$tamb,
                             dataWithoutNA_range()$gpoa, dataWithoutNA_range()$uw,
                             dataWithoutNA_range()$aw, dataWithoutNA_range()$hrel)
        vdc_sim <- sim_vdc(dataWithoutNA_range()$gpoa, dataWithoutNA_range()$tmod,
                           dataWithoutNA_range()$vdc, dataWithoutNA_range()$uw, beta)
        idc_sim <- sim_idc(dataWithoutNA_range()$gpoa, irrad_sim$global,
                           dataWithoutNA_range()$tmod,
                           tmod_sim, alpha, dataWithoutNA_range()$idc)
        pdc_sim <- sim_pdc(dataWithoutNA_range()$gpoa, irrad_sim$global,
                           dataWithoutNA_range()$tmod,
                           tmod_sim, sysArea, gamma, nSTC)
        data.frame(irrad_sim = irrad_sim, tmod_sim = tmod_sim, vdc_sim = vdc_sim,
                   idc_sim = idc_sim, pdc_sim = pdc_sim)
      } else return(0)
    })

    # Calculate outliers
    outliers <- reactive({
      if(length(dataWithoutNA_range()) != 0) {
        irrad_outliers <- outlier_det(dataWithoutNA_range()$gpoa,
                                      modelled$irrad_sim$global)
        tmod_outliers <- outlier_det(dataWithoutNA_range()$tmod,
                                     modelled$tmod_sim)
        vdc_outliers <- outlier_det(modelled$vdc_sim$meas_tc,
                                    modelled$vdc_sim$pred_tc)
        idc_outliers <- outlier_det(modelled$idc_sim$meas_tc,
                                    modelled$idc_sim$pred_tc)
        pdc_outliers <- outlier_det(modelled$pdc_sim$meas_tc,
                                    modelled$pdc_sim$pred_tc)
        pac_outliers <- outlier_det(dataWithoutNA_range()$pdc,
                                    dataWithoutNA_range()$pac)
        data.frame(irrad_outliers = irrad_outliers, tmod_outliers = tmod_outliers,
                   vdc_outliers = vdc_outliers, idc_outliers = idc_outliers,
                   pdc_outliers = pdc_outliers, pac_outliers = pac_outliers)
      } else return(0)
    })

    # Calculate Capture Losses and classify faults
    classified <- reactive({
      if(length(dataWithoutNA_range()) != 0) {
        fault_classification(dataWithoutNA_range()$gpoa, modelled$pdc_sim$meas_tc,
                             modelled$irrad_sim$global, modelled$pdc_sim$pred_tc,
                             modelled$idc_sim$meas_tc, modelled$idc_sim$pred_tc,
                             modelled$vdc_sim$meas_tc, modelled$vdc_sim$pred_tc,
                             sysWp)
      } else return(0)
    })


    # Measurements tab --------------------------------------------------------

    output$p_range <- renderDygraph({
      if(length(dataWithoutNA_range()) != 0) {
        dygraph(dataWithoutNA_range()[, c("pdc", "pac")],
                xlab = "Time",
                ylab = "Measured Power [W]",
                group = "meas") %>%
          dyOptions(colors = RColorBrewer::brewer.pal(8, "Dark2"),
                    useDataTimezone = TRUE) %>%
          dyRangeSelector()
      }
    })

    output$g_range <- renderDygraph({
      if(length(dataWithoutNA_range()) != 0) {
        dygraph(dataWithoutNA_range()[, c("gpoa", "gref")],
                xlab =  "Time",
                main = "",
                ylab = "Measured Global Irradiance [Wm-2]",
                group = "meas") %>%
          dyOptions(colors = RColorBrewer::brewer.pal(3, "Set1"),
                    useDataTimezone = TRUE) %>%
          dyRangeSelector()
      }
    })

    output$t_range <- renderDygraph({
      if(length(dataWithoutNA_range()) != 0) {
        dygraph(dataWithoutNA_range()[, c("tmod", "tamb")],
                xlab = "Time",
                main = "",
                ylab = "Measured Temperature [°C]",
                group = "meas") %>%
          dyOptions(colors = RColorBrewer::brewer.pal(6, "Spectral"),
                    useDataTimezone = TRUE) %>%
          dyRangeSelector()
      }
    })

    output$ac_dc_range <- renderPlot({
      if(length(dataWithoutNA_range()) != 0) {
        m <- lm(dataWithoutNA_range()$pac ~ dataWithoutNA_range()$pdc)
        eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2,
                         list(a = format(coef(m)[1], digits = 2),
                              b = format(coef(m)[2], digits = 2),
                              r2 = format(summary(m)$r.squared, digits = 3))
        ) %>% as.expression %>% as.character
        ggplot(dataWithoutNA_range(), aes(x = pdc, y = pac)) +
          geom_point() +
          geom_smooth(method = "lm") +
          xlab("DC Power, Pdc [W]") +
          ylab("AC Power, Pac [W]") +
          annotate(label = eq, geom = "text", x = mean(fitted(m)),
                   y = 3 * mean(fitted(m)), parse = TRUE)
      }
    }, bg = "transparent")


    # Model results tab -------------------------------------------------------

    output$gpoa_model_range <- renderDygraph({
      if(length(dataWithoutNA_range()) != 0) {
        d <- as.zoo(data.frame(global = modelled()$irrad_sim.global,
                               direct = modelled()$irrad_sim.direct,
                               diffuse = modelled()$irrad_sim.diffuse,
                               albedo = modelled()$irrad_sim.albedo),
                    order.by = index(dataWithoutNA_range()))
        dygraph(d,
                xlab = "Time",
                main = "",
                ylab = "Transposed GHI Components on the POA [Wm-2]",
                group = "models") %>%
          dyOptions(colors = RColorBrewer::brewer.pal(9, "Set1"),
                    useDataTimezone = TRUE) %>%
          dyRangeSelector()
      }
    })

    output$gpoa_comp_range <- renderPlot({
      if(length(dataWithoutNA_range()) != 0) {
        m <- lm(dataWithoutNA_range()$gpoa ~ modelled()$irrad_sim.global)
        eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2,
                         list(a = format(coef(m)[1], digits = 2),
                              b = format(coef(m)[2], digits = 2),
                              r2 = format(summary(m)$r.squared, digits = 3))
        ) %>% as.expression %>% as.character
        d <- data.frame(modelled = modelled()$irrad_sim.global,
                        measured = dataWithoutNA_range()$gpoa)
        ggplot(d, aes(x = measured, y = modelled)) +
          geom_point() +
          geom_smooth(method = "lm") +
          xlab("Measured Global Irradiance on the POA [Wm-2]") +
          ylab("Transposed GHI on the POA [Wm-2]") +
          annotate(label = eq, geom = "text", x = mean(fitted(m)),
                   y = 3 * mean(fitted(m)), parse = TRUE)
      }
    }, bg = "transparent")

    output$diffuse_range <- renderDygraph({
      if (length(dataWithoutNA_range()) != 0) {
        d <- as.zoo(data.frame(diffuse = modelled()$irrad_sim.diffuse,
                               isotropic = modelled()$irrad_sim.diffuse_iso,
                               anisotropic = modelled()$irrad_sim.diffuse_aniso),
                    order.by = index(dataWithoutNA_range()))
        dygraph(d,
                xlab = "Time",
                main = "",
                ylab = "Diffuse Irradiance on the POA [Wm-2]",
                group = "models")  %>%
          dyOptions(colors = RColorBrewer::brewer.pal(8, "Set1"),
                    useDataTimezone = TRUE)  %>%
          dyRangeSelector()
      }
    })


    # Outlier detection tab -----------------------------------------------------

    output$pdc_outliers_range <- renderPlot({
      ggplot(outliers(), aes(x = index(dataWithoutNA_range()))) +
        geom_point(aes(y = ifelse(pdc_outliers.fault, pdc_outliers.corr, NA),
                       col = "red", size = 1.5)) +
        geom_line(aes(y = pdc_outliers.corr)) +
        theme(legend.position = "none")
    })

    output$vdc_outliers_range <- renderPlot({
      ggplot(outliers(), aes(x = index(dataWithoutNA_range()))) +
        geom_point(aes(y = ifelse(vdc_outliers.fault, vdc_outliers.corr, NA),
                       col = "red", size = 1.5)) +
        geom_line(aes(y = vdc_outliers.corr)) +
        theme(legend.position = "none")
    })

    output$irrad_outliers_range <- renderPlot({
      ggplot(outliers(), aes(x = index(dataWithoutNA_range()))) +
        geom_point(aes(y = ifelse(irrad_outliers.fault, irrad_outliers.corr, NA),
                       col = "red", size = 1.5)) +
        geom_line(aes(y = irrad_outliers.corr)) +
        theme(legend.position = "none")
    })

    output$elc_range <- renderDygraph({
      if(length(dataWithoutNA_range()) != 0) {
        d <- classified()[, c()]
        dygraph(y$eLc, main = "") %>%
          dyOptions(colors = RColorBrewer::brewer.pal(8, "Set1"),
                    useDataTimezone = TRUE)  %>%
          # dyAxis("y", label = "ELc", valueRange = c(-70, 70)) %>%
          # dyLimit(15, color = "red") %>%
          # dyLimit(-25, color = "red") %>%
          dyRangeSelector()
      }
    })

    output$ei_ev_range <- renderDygraph({
      if(length(dataWithoutNA_range()) != 0) {
        y <- determining_fault_gcsi_range()
        toplot<- cbind(y$ei, y$ev)
        colnames(toplot) <- c("Ei", "Ev")
        dygraph(toplot, main = "") %>%
          dyOptions(colors = RColorBrewer::brewer.pal(8, "Dark2"),
                    useDataTimezone = TRUE)  %>%
          # dyAxis("y", label = "Ei, Ev",valueRange = c(-1.5, 2)) %>%
          # dyLimit(-0.5, color = "red") %>%
          # dyLimit(1.5, color = "red") %>%
          # dyLimit(-0.5, color = "red") %>%
          # dyLimit(1.5, color = "red") %>%
          dyRangeSelector()
      }
    })

    output$ghi_error_range <- renderPlot({
      if(length(dataWithoutNA_range()) != 0) {
        data <- irrad_sim_on_inclined_surface_range()
        model <- lm(data$irrad_gsim ~ data$irrad_gcsi)
        qplot(y = data$irrad_gsim, x = data$irrad_gcsi) +
          geom_abline() +
          geom_abline(slope = (model$coefficients[2]) * 0.75,
                      intercept = model$coefficients[1] - 30, col = "red") +
          geom_abline(slope = (model$coefficients[2]) * 1.25,
                      intercept = model$coefficients[1] + 30, col = "red") +
          xlab("Measured Solar Irradiance [Wm-2]") +
          ylab("Modelled Solar Irradiance [Wm-2]")
      }
    }, bg = "transparent")

    output$pdc_error_range <- renderPlot({
      if(length(dataWithoutNA_range()) != 0) {
        model <- lm(models_gcsi_range()$power_dc_sim_gsim ~ dataWithoutNA_range()$pdc)
        qplot(y = models_gcsi_range()$power_dc_sim_gsim,
              x = dataWithoutNA_range()$pdc) +
          geom_abline() +
          geom_abline(slope = (model$coefficients[2]) * 0.75,
                      intercept = model$coefficients[1] - 30, col = "red") +
          geom_abline(slope = (model$coefficients[2]) * 1.25,
                      intercept = model$coefficients[1] + 30, col = "red") +
          xlab("Measured Pdc [W]") + ylab("Modelled Pdc [W]")
      }
    }, bg = "transparent")


    # Fault classification tab ------------------------------------------------



  })
