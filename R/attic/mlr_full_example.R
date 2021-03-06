library(mlr)

x1 = runif(400, -5, 5)
x2 = runif(400, -5, 5)
xor = (x1 < 0 | x2 < 0) & !(x1 < 0 & x2 < 0)
class = ifelse(xor, "Class 1", "Class 2")

angle = runif(400, 0, 360)
radius_class1 = rexp(200, 1)
radius_class2 = rnorm(200, 16, 3)

data = data.frame(
  x1 = sqrt(c(radius_class1, radius_class2)) * cos(2*pi*angle),
  x2 = sqrt(c(radius_class1, radius_class2)) * sin(2*pi*angle),
  class = c(rep("Class 1", 200), rep("Class 2", 200))
)

#data = data.frame(x1, x2, class)

learner_mlr = mlr::makeLearner("classif.extraTrees")
task_mlr    = makeClassifTask(data = data, target = "class")

rdesc = makeResampleDesc("Holdout", split = 0.5)
results     = mlr::resample(learner_mlr, task_mlr, rdesc)

paste(
  "Please install package(s):",
  paste(listLearners()$package[listLearners()$short.name == "bst"], collapse = ", ")
)

task_mlr    = makeClassifTask(data = data, target = "class")
plotLearnerPrediction(learner_mlr, task = task_mlr)
tryCatch(
  learner_mlr = mlr::makeLearner("classif.boosting"),
  error = function(e) {
    createAlert(session, "learner_error", title = "Can't create learner!",
                content = e, append = FALSE)
  }
)
lrn = setHyperPars(lrn,par.vals=tr$x)

plotLearnerPrediction(learner_mlr, task_mlr)

model       = mlr::train(learner_mlr, task_mlr)


pred = expand.grid(x1 = -50:50/10, x2 = -50:50/10)
#pred$class = rep("Class 1", 121)
#task_mlr    = mlr::makeClassifTask(data = pred, target = "class")

predictions = predictLearner(learner_mlr, model, pred)

#prediction = predict(model, task_mlr)
pred = data.frame(x = unique(pred$x1), y = unique(pred$x2))
pred$pred_matrix = as.numeric(factor(predictions))

plotly::plot_ly(
  data = pred,
  x = ~unique(x1),
  y = ~unique(x2),
  z = ~matrix(pred_matrix, nrow = sqrt(length(predictions)), byrow = TRUE),
  type = "heatmap",
  colorscale = "Greys",
  opacity = 0.5
)

#rdesc       = mlr::makeResampleDesc("CV", iters = 2)
#results     = mlr::resample(learner_mlr, task_mlr, rdesc)

#learningcurve = generateLearningCurveData(learner_mlr, task_mlr)
listLearners()[listLearners()$short.name == "featureless", ]
