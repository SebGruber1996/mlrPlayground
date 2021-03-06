Regr3dLearningProcess = R6Class(
  classname = "Regr3dLearningProcess",
  inherit = RegrLearningProcess,

  public = list(

    getDataPlot = function() {
      #' @description Method transforming the data into an interactive plot
      #' @return plotly plot object
      plotly::plot_ly(
        data = self$data$train.set,
        name = "Train",
        type = "scatter3d",
        x    = ~x,
        y    = ~y,
        z    = ~z,
        size = 10
      ) %>%
      layout(scene = list(
        xaxis = list(title = 'xaxis'),
        yaxis = list(title = 'yaxis'),
        zaxis = list(title = 'zaxis'))
      )%>%
      plotly::add_trace(
        data   = self$data$test.set,
        name   = "Test",
        x      = ~x,
        y      = ~y,
        z      = ~z,
        type   = "scatter3d",
        mode   = "markers"
        )
    },

    calculatePred = function(i) {
      #' @description Method for calculating equidistant predictions in a 2D box
      #' @param i Index of the learner in self$learners to calculate the
      #' predictions for
      #' @return list(x = <<x-coordinates>>, y = <<predictions>>)

      # Must use string to index into reactivevalues
      i = as.character(i)

      learner     = self$learners[[i]]
      model       = train(learner, self$task$train)
      pred        = expand.grid(x = -50:50 / 10)

      predictions = predictLearner(learner, model, pred)
      pred$y      = as.numeric(factor(predictions))

      return(pred)
    },

    getPredPlot = function(i) {
      #' @description Method to recieve prediction surface of a trained learner
      #' as an interactive plot
      #' @param i Index of the learner in self$learners to return the
      #' predictions plot for
      #' @return plotly plot object

      pred = self$calculatePred(i)

      plotly::plot_ly(
        x         = ~pred$x,
        y         = ~pred$y,
        type      = "line",
        showscale = FALSE
      ) %>%
      plotly::add_trace(
        data      = self$data$test.set,
        name      = "Test",
        x         = ~x,
        y         = ~y,
        symbol    = I('o'),
        type      = "scatter",
        mode      = "markers"
        )%>%
        plotly::add_trace(
          data    = self$data$train.set,
          name    = "Train",
          x       = ~x,
          y       = ~y,
          symbol  = I('x'),
          type    = "scatter",
          mode    = "markers"
        ) %>%
        plotly::layout(xaxis = list(title = ""), yaxis = list(title = ""))
    }
  ),

  private = list()
)
