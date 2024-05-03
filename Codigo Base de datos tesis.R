#Leemos el archivo csv y le asignamos el nombre "datos"
datos = read.csv("Sistema oriente-poniente 2010-2023.csv", sep = ";")
#eliminamos el rango de años 2010 a 2015 de la base
datos = datos[!(datos$Agno %in% c(2010:2015)), ]
#con esto guardamos una nueva base con los cambios realizados
write.csv(datos, file = 'Costanera_editado.csv', row.names = FALSE)

#volvemos a realizar el proceso, esta vez eliminando las columnas "Sigla" y "Nombre"
#ademas borramos los años 2020 y 2021 debido a que en la pandemia la gente uso menos las autopistas y puede sesgar futuros analisis
datos_final = read.csv("Costanera_editado.csv")
datos_final = datos_final[!(datos_final$Agno %in% c(2020, 2021)), ]
datos_final = datos_final[, !(names(datos_final) %in% c('Sigla', 'Nombre'))]
write.csv(datos_final, file ='Costanera_final.csv', row.names = FALSE)
View(datos_final)


autos_por_fecha_portico = read.csv("Costanera_final.csv")
# Filtrar los datos para obtener solo la categoría de vehículo "autos"
autos_data <- subset(autos_por_fecha_portic, CategoriaVehiculo == "Autos y camionetas con/sin  remolque")

# Agrupar por portico, año, mes y día, y sumar el flujo vehicular
autos_por_fecha_portico <- aggregate(Flujo ~ Portico + Agno + NumeroMes + Dia, data = autos_data, FUN = sum)

# Imprimir el resultado
print(autos_por_fecha_portico)

#ver los porticos que existenen la columna
Nombres_porticos = unique(autos_por_fecha_portico$Portico)
print(Nombres_porticos)
#Eliminar los porticos que empiecen con P8 (eje Kennedy)
porticos_usar =grep("^P8", autos_por_fecha_portico$Portico)
autos_por_fecha_portico = autos_por_fecha_portico [-porticos_usar, ]

Nombres_porticos = unique(autos_por_fecha_portico$Portico)
print(Nombres_porticos)
#Añadimos la orientacion "Oriente" a los siguientes porticos, mientras que el resto se le asigna "Poniente" 
autos_por_fecha_portico$Orientacion <- ifelse(autos_por_fecha_portico$Portico %in% c("P9 Ruta 68 - Americo Vespucio Poniente", "P6.2 Americo Vespucio Poniente - Petersen", "P6.1 Petersen Carrascal", "P5 Carrascal - Vivaceta", "P4 Vivaceta - Torres Tajamar", "P3 Torres Tajamar - Puente Lo Saldes", "P2.2  Puente Lo Saldes - Centenario", "P2.1  Centenario – Gran Vía", "P1 Gran Vía – Puente San Francisco", "P0 Puente San Francisco  Puente Padre Arteaga"),
                                              "Oriente", "Poniente")


#Sumamos los porticos para que nos de un total año hacia el oriente y hacia el poniente
autos_por_fecha_portico_ANUAL <- autos_por_fecha_portico[, !(names(autos_por_fecha_portico) %in% c('Portico'))]

flujo_por_orientacion <- autos_por_fecha_portico_ANUAL %>%
  group_by(Agno, Orientacion) %>%
  summarise(Flujo_Total = sum(Flujo))

#añadimos comas para visualizar mejor los numeros
flujo_por_orientacion$Flujo_Total <- format(flujo_por_orientacion$Flujo_Total, big.mark = ".", decimal.mark = ",", scientific = FALSE)


#Un print para corroborar que los porticos estan bien asignados
print(unique(autos_por_fecha_portico[, c("Portico", "Orientacion")]))