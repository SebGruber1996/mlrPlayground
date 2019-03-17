ClusterLearningProcess = R6Class(
  classname = "ClusterLearningProcess",
  inherit = LearningProcess,

  public = list(

    setData = function(data, train.ratio) {
      super$setData(data, train.ratio)
      self$task$train = makeClusterTask(data = self$data$train.set)
    },

    initLearner = function(short.name, i) {
      super$initLearner(short.name, i, "cluster")
    },

    getDataPlot = function() {
      #' @description Method transforming the data into an interactive plot
      #' @return plotly plot object

      plotly::plot_ly(
        data   = self$data$train.set,
        x      = ~x,
        y      = ~y,
        marker = list(
          size  = 10,
          color = 'rgba(255, 182, 193, .9)',
          line  = list(
            color = 'rgba(152, 0, 0, .8)',
            width = 1
          )
        ),
        type   = "scatter",
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

      learner = self$learners[[i]]
      model   = train(learner, self$task$train)
      pred    = expand.grid(x = -50:50 / 10, y = -50:50 / 10)

      predictions = predictLearner(learner, model, pred)
      pred$z      = as.numeric(factor(predictions))

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
        x = ~unique(pred$x),
        y = ~unique(pred$y),
        z = ~matrix(
          pred$predictions,
          nrow = sqrt(length(pred$predictions)),
          byrow = TRUE
        ),
        type = "heatmap",
        colors = colorRamp(c("red", "blue")),
        opacity = 0.2,
        showscale = FALSE
      ) %>%
        plotly::add_trace(
          data = self$data$train.set,
          x = ~x,
          y = ~y,
          color = ~class,
          colors = c("#2b8cbe", "#e34a33", "#2b8cbe", "#e34a33"),
          type = "scatter",
          mode = "markers"
        ) %>%
        plotly::layout(xaxis = list(title = ""), yaxis = list(title = ""))
    }
  ),

  private = list()
)