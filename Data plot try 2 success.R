#Figuring out how to make a line graph from custom data#

library(ggplot2)

cleanzentra <- read.csv("cleanzentra.csv")

View(cleanzentra)

ggplot(data = cleanzentra, aes(x = timeseriesnumber)) + 
  geom_line(aes(y = atercontentp1), color = "red") +
  geom_line(aes(y = watercontentp2), color = "blue")



ggplot(cleanzentra, aes(x = atercontentp1, y = watercontentp2)) + geom_point(size=2)



