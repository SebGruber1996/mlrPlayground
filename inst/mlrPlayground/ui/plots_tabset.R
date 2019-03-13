# only locally used
prediction_tab = tabPanel(
  "Predictions",
  helpText("Learner 1:"),
  withSpinner(
    plotly::plotlyOutput("predictionPlot_1", width = "90%", height = "450px")
  ),
  conditionalPanel(
    "output.learner_amount > 1",
    helpText("Learner 2:"),
    withSpinner(
      plotly::plotlyOutput("predictionPlot_2", width = "90%", height = "450px")
    )
  )
)

# only locally used
learning_curve_tab = tabPanel(
  "Learning Curve",
  withSpinner(
    plotOutput("learningCurve", width = "90%", height = "450px")
  )
)

# only locally used
benchmark_tab = tabPanel(
  "Benchmark",
  withSpinner(
    plotOutput("benchmarkPlot", width = "90%", height = "450px")
  )
)

# only locally used
roc_tab = tabPanel(
  "ROC",
  withSpinner(
    plotOutput("ROCPlot", width = "90%", height = "450px")
  )
)

# exported
plots_tabset = tabsetPanel(
  type = "tabs",
  prediction_tab,
  learning_curve_tab,
  benchmark_tab,
  roc_tab
)