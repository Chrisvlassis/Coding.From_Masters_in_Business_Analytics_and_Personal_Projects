ctrl <- trainControl(method = 'cv', number = 10)



DT_1 <- train(response ~ ., data = train, method = 'rpart', trControl = ctrl, tuneLength = 10)


plot(DT_1)



DT_1$finalModel
pr<- predict(DT_1, test)

confusionMatrix(table(test$response, pr))



plot(DT_1$finalModel)
text(DT_1$finalModel)
