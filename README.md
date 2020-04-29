# moodleQ
Construcción y manejo de preguntas de moodle con clases R6

## Objetivo
MoodelQ permite crear facilmente preguntas de lo sprincipales tipos que tiene moodle. Estas preguntas se salvan en un fichero xml que es importado en moodle dentro de su banco de preguntas. Este sistema es mucho más rápido que crear una a una las preguntas usando la tediosa interfaz de moodle. Este documento explica con ejemplos como utilizar la librería y está basado en el formato xml de moodle expresado en la página de la documentacion de moodle: [enlace](https://docs.moodle.org/38/en/Moodle_XML_format).

Está en una fasemuy preliminar por lo que se debe usar con cuidado y se recuerda que carece totalmente de garantía sobre su funcionamiento.

Un ejemplo sencillo de su uso sería:

```R
q1 <- question$new(
  type="multichoice",
  'name' = "P001",
  'question' = "Enunciado",
  'answer' = list("Alternativa 1", 100),
  'answer' = list("Alternativa 2"),
  'answer' = list("Alternativa 3"))

Q <- quiz$new()
Q$save_xml("mifichero.xml")

```
El código anterior genera una pregunta de elección múltiple con tres alternativas (la primera es la correcta) que es guardado en el fichero "mifichero.xml" que puede ser importado en moodle.

## Instalación

El paquete se puede instalar via devtools y github

```R
devtools::install_github("mcstllns/moodleQ")
```

Si no está instalado previamente devtools puede instalarse

```R
install.packages("devtools")
```
y una vez instalado el paquete cargado con
```{r}
library(moodleQ)
```

## Crear un cuestionario sencillo
Las preguntas se pueden crear llamando al constructor _question$new()_. Los argumantos de la función son los parametros que definen la pregunta. Cada tipo de pregunta tiene definido unos parametros o campos por defecto como se verá más adelante. Los tipos de preguntas de moodle que están definidas son las siguoentes:

* multichoice
* truefalse
* shortanswer
* essay
* numerical
* description

Los tipo de preguntas matching y cloze no han sido implementado aún porque son absolutamente inútiles para trabajar con universitarios aprendiendo disciplinas técnicas.

El siguiente código crea una pregunta categorica (todo lo que venga despues de ella será clasificado en esa categoria) y una elección multiple, empaquetadas ambas en un cuestionario:
```{r}
q0 <- question$new(
  type="category",
  'name' = 'P000',
  'category' = "$course$/pruebas_moodleQ")

q1 <- question$new(
  type="multichoice",
  'name' = "P001",
  'question' = "Enunciado",
  'answer' = list("Alternativa 1", 100),
  'answer' = list("Alternativa 2"),
  'answer' = list("Alternativa 3"))
  
Q <- quiz$new(q0, q1)

```

Para ver el contenido de una pregunta se utiliza el método print o simplemente se escribe el nombre del objeto. Para ver el formato xml de cada pregunta se utiliza el método xml()
