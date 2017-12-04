# ---
# title: "Preparando los datos de Data AirQuality"
# author: "Javier Alvarez"
# date: "December 1, 2017"
# ---


require(tm)
require(dplyr)
require(ggplot2)
require(lubridate)

DocName <- "AirQualityUCI.csv"       # Document Name with extension
datos <- read.csv(DocName, sep = ";", dec = ",", stringsAsFactors = FALSE)

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

##Renombrar las columnas a algo mas facil de leer
colnames(datos)[3] <- "CO"
colnames(datos)[4] <- "Sensor1"
colnames(datos)[5] <- "NMHC"
colnames(datos)[6] <- "C6H6"
colnames(datos)[7] <- "Sensor2"
colnames(datos)[8] <- "NOX"
colnames(datos)[9] <- "Sensor3"
colnames(datos)[10] <- "NO2"
colnames(datos)[11] <- "Sensor4"
colnames(datos)[12] <- "Sensor5"

#Convertir Fecha al tipo Fecha correcto
datos["DateFmt"] <- dmy(datos$Date)
# Adicionar un campo para el Dia de la semana
datos["Dia"] <- strftime(datos$DateFmt, '%u')
datos["DiaLabel"] <- weekdays(datos$DateFmt)

#Adicionar un indice para procesar los datos con -200
datos$indice <- 1:nrow(datos)

#Crear funcion para calcular el promedio de los valores cercanos
promCercanos <- function(indice, nombreCampo) {
  #Asigna a la muestra los dos valores anteriores al indice
  muestra <- datos[(indice-1):(indice-2), nombreCampo]
  i <- 1
  j <- 3
  #Buscar y adicionar los dos valores siguientes al indice
  while (j<=4) {
    if (datos[(indice + i), nombreCampo] != -200) {
      muestra[j] <- datos[(indice + i), nombreCampo]
      j <- j + 1
    }
    i <- i +1
  }
  return(mean(muestra))
}


# Para cada columna buscar valores perdidos (-200) y reemplazarlos por la media de los mas cercanos
IndicesCO <- datos[datos$CO == -200,"indice"]
tail(IndicesCO)
for (x in IndicesCO) {
  print(x)
  datos[IndicesCO[x],"CO"] <- promCercanos(x)    
}



x<- datos %>%
  select(rownumber,CO)

rownames(datos[1:10,1:2])

select(rownames(CO),CO)
nrow(datos)

datos$indice <- 1:nrow(datos)
#summary(datos)



##Obtener datos de CO con Temperatura
COTemp <- datos %>% 
  select(CO, T) %>%
  filter(CO != -200 & T != -200)  # Eliminar datos malos

#usemos un scatter plot para ver la relacion entre esta dos variables
ggplot(
  data = COTemp,
  aes(
    x = T,
    y = CO)) + 
  geom_point() + 
  ggtitle("Concentracion CO con respecto a la Temperatura") +
  xlab("Temperatura") +
  ylab("Niveles de CO")


## CO - Agrupar por dia
datosCODia <- datos %>%
  select(CO, Dia) %>%
  filter(CO != -200) %>%
  group_by(Dia) %>%
  summarize(promedioDia = mean(CO), totalCODia = sum(CO))
  

# Usemos un scatter plot para ver la relacion entre esta dos variables
ggplot(
  data = datosCODia,
  aes(
    x = Dia,
    y =totalCODia)) + 
  geom_point() + 
  ggtitle("Concentracion CO con respecto al dia") +
  xlab("Dia") +
  ylab("Niveles de CO")

# CO - Agrupado por Mes
datosCOMes <- datos %>%
  select(CO) %>%
  mutate(Mes = lubridate::month(datos$Date, label = TRUE)) %>%
  filter(CO != -200) %>%
  group_by(Mes) %>%
  summarize(promedio = mean(CO), total = sum(CO))

#usemos un scatter plot para ver la relacion entre esta dos variables
ggplot(
  data = datosCOMes,
  aes(
    x = Mes,
    y =promedio)) + 
  geom_point() + 
  ggtitle("Concentracion") +
  xlab("Mes") +
  ylab("Niveles de CO Promedio")


# Crear una funcion para encontrar el promedio de los valores mas cercanos
