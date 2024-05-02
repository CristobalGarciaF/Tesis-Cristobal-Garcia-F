#Leemos el archivo csv y le asignamos el nombre "datos"
datos = read.csv("Sistema oriente-poniente 2010-2023.csv", sep = ";")
#eliminamos el rango de años 2010 a 2015 de la base
datos = datos[!(datos$Agno %in% c(2010:2015)), ]
#con esto guardamos una nueva base con los cambios realizados
write.csv(datos, file = 'Costanera_editado.csv', row.names = FALSE)

#volvemos a realizar el proceso, esta vez eliminando las columnas "Sigla" y "Nombre"
#ademas borramos los años 2020 y 2021 ya que por la pandemia la gente uso mucho menos las autopistas
datos_final = read.csv("Costanera_editado.csv")
datos_final = datos_final[!(datos_final$Agno %in% c(2020, 2021)), ]
datos_final = datos_final[, !(names(datos_final) %in% c('Sigla', 'Nombre'))]
write.csv(datos_final, file ='Costanera_final.csv', row.names = FALSE)
View(datos_final)
