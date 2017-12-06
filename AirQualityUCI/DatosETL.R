# ---
# title: "Preparando los datos de Data AirQuality"
# author: "Javier Alvarez"
# date: "December 1, 2017"
# ---


require(tm)
require(dplyr)
require(ggplot2)
require(hexbin)
require(lubridate)
require(ggpubr)

DocName <- "AirQualityUCI.csv"       # Document Name with extension
datos <- read.csv(DocName, sep = ";", dec = ",", stringsAsFactors = FALSE)
colnames(datos) <- c("Date","Time","CO","Sensor1","NMHC","C6H6","Sensor2","NOX","Sensor3","NO2","Sensor4","Sensor5","T","RH","AH")

## ANALISIS DE DATOS INVALIDOS CON MICE Y VIM
#require(VIM)    #Visualization and Imputation of Missing Values##Cargando los datos del archivo CSV
#require(mice)   ##Load mice package for Multivariate Imputation by Chained Equations (MICE)
#Ver patron de datos invalidos con mice
#md.pattern(datos)                           
#Grafico de Valores invalidos en numeros con VIM
#aggr(datos, prop = F, numbers = T)          
#Matrix Plot. Red for missing values, Darker values are high values. VIM
#matrixplot(datos, interactive = F, sortby = "Date")
#Scatter plot matrix with VIM package
#scattmatrixMiss(datos, interactive = F, highlight = c("Date"))
#sum(is.na(datos))           #Verificamos numero de celdas con valores invalidos

## Limpieza de Datos
#Eliminar las ultimas 2 columnas con datos NA
datos <- datos[ ,c(-16,-17)]                

#Eliminar FILAS invalidos usando VIM
datos <-datos[complete.cases(datos),]       

#Convertir Fecha al tipo Fecha correcto
datos["DateFmt"] <- dmy(datos$Date)
# Adicionar un campo para el Dia de la semana
datos["Dia"] <- strftime(datos$DateFmt, '%u')
datos["DiaLabel"] <- weekdays(datos$DateFmt)

#Adicionar un indice para procesar los datos con -200
datos$indice <- 1:nrow(datos)
totalFilas <- nrow(datos)

#Crear funcion para calcular el promedio de los valores cercanos
promCercanos <- function(indice, nombreCampo) {
  #Asigna a la muestra los dos valores anteriores al indice
  muestra <- datos[(indice-1):(indice-2), nombreCampo]
  i <- 1
  j <- 3
  #Buscar y adicionar los dos valores siguientes al indice, que sean diferentes de -200, si existen
  while (j<=4 & i<4 & (indice + i < totalFilas)) {
    if (datos[(indice + i), nombreCampo] != -200) {
      muestra[j] <- datos[(indice + i), nombreCampo]
      j <- j + 1
    }
    i <- i +1
  }
  return(mean(muestra))
}


# Para cada columna buscar valores perdidos (-200) y reemplazarlos por la media de los mas cercanos
Indices <- datos[datos$CO == -200,"indice"]
for (x in Indices) { datos[x,"CO"] <- promCercanos(x, "CO") }
Indices <- datos[datos$Sensor1 == -200,"indice"]
for (x in Indices) { datos[x,"Sensor1"] <- promCercanos(x, "Sensor1") }
Indices <- datos[datos$NMHC == -200,"indice"]
for (x in Indices) { datos[x,"NMHC"] <- promCercanos(x, "NMHC") }
Indices <- datos[datos$C6H6 == -200,"indice"]
for (x in Indices) { datos[x,"C6H6"] <- promCercanos(x, "C6H6") }
Indices <- datos[datos$Sensor2 == -200,"indice"]
for (x in Indices) { datos[x,"Sensor2"] <- promCercanos(x, "Sensor2") }
Indices <- datos[datos$NOX == -200,"indice"]
for (x in Indices) { datos[x,"NOX"] <- promCercanos(x, "NOX") }
Indices <- datos[datos$Sensor3 == -200,"indice"]
for (x in Indices) { datos[x,"Sensor3"] <- promCercanos(x, "Sensor3") }
Indices <- datos[datos$NO2 == -200,"indice"]
for (x in Indices) { datos[x,"NO2"] <- promCercanos(x, "NO2") }
Indices <- datos[datos$Sensor4 == -200,"indice"]
for (x in Indices) { datos[x,"Sensor4"] <- promCercanos(x, "Sensor4") }
Indices <- datos[datos$Sensor5 == -200,"indice"]
for (x in Indices) { datos[x,"Sensor5"] <- promCercanos(x, "Sensor5") }
Indices <- datos[datos$T == -200,"indice"]
for (x in Indices) { datos[x,"T"] <- promCercanos(x, "T") }
Indices <- datos[datos$RH == -200,"indice"]
for (x in Indices) { datos[x,"RH"] <- promCercanos(x, "RH") }
Indices <- datos[datos$AH == -200,"indice"]
for (x in Indices) { datos[x,"AH"] <- promCercanos(x, "AH") }

# #Usemos un scatter plot para ver la relacion entre esta dos variables T y CO
# ggplot(
#   data = datos,
#   aes(x = T,  y = CO)) + 
#   geom_point() + geom_smooth() +
#   ggtitle("Concentracion CO con respecto a la Temperatura") +
#   xlab("Temperatura") +
#   ylab("Niveles de CO")
# 
# 
# ggplot(datos, aes(T, CO)) +
#   geom_point() + geom_smooth()
# 
# 
# ## CO - Agrupar por dia
# datosCODia <- datos %>%
#   select(CO, Dia) %>%
#   group_by(Dia) %>%
#   summarize(promedioDia = mean(CO), totalCODia = sum(CO))
  

# # Usemos un scatter plot para ver la relacion entre esta dos variables
# ggplot(
#   data = datosCODia,
#   aes(
#     x = Dia,
#     y =totalCODia)) + 
#   geom_point() + 
#   ggtitle("Concentracion CO con respecto al dia") +
#   xlab("Dia") +
#   ylab("Niveles de CO")
# 
# ggplot(
#   data = datos,
#   aes(x = Dia,y =CO)) + 
#   geom_boxplot() + 
#   ggtitle("Concentracion CO con respecto al dia") +
#   xlab("Dia") +
#   ylab("Niveles de CO")
# 
# 
# # CO - Agrupado por Mes
# datosCOMes <- datos %>%
#   select(CO) %>%
#   mutate(Mes = lubridate::month(datos$Date, label = TRUE)) %>%
#   group_by(Mes) %>%
#   summarize(promedio = mean(CO), total = sum(CO))
# 
# #usemos un scatter plot para ver la relacion entre esta dos variables
# ggplot(
#   data = datosCOMes,
#   aes(
#     x = Mes,
#     y =promedio)) + 
#   geom_point() + 
#   ggtitle("Concentracion") +
#   xlab("Mes") +
#   ylab("Niveles de CO Promedio")
# 
# ggplot(
#   data = datos,
#   aes(
#     x = lubridate::month(datos$Date, label = TRUE),
#     y =CO)) + 
#   geom_boxplot() + 
#   ggtitle("Concentracion por Mes de CO") +
#   xlab("Mes") +
#   ylab("Niveles de CO")


#Analisis del comportamiento de vbles numericas

# #Verificar si se comporta como una distribucion normal
# ggqqplot(datos$CO, ylab = "CO concentracion")
# shapiro.test(head(datos$CO,5000))
# 
# ggqqplot(datos$NOX, ylab = "NOx concentracion")
# shapiro.test(head(datos$NOX,5000))
# 
# cor.test(datos$CO, datos$NOX, method=c("pearson"))
# cor.test(datos$CO, datos$NO2, method=c("pearson")) 
# cor.test(datos$CO, datos$C6H6, method=c("pearson")) 
# 
# summary(datos$CO)
# plot(density(datos$CO))
# plot(density(datos$NMHC))
# 
# plot(density(datos$C6H6))
