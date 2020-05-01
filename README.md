
<span style="font-size:80px"><i>moodle</i></span><span style="font-size:100px"><b><i>Q</i></b></span>
<span style="font-size:20px">0.5.3</span>


***
__Miguel A. Castellanos__

mcastellanos\@psi.ucm.es

Universidad Complutense de Madrid

***
__moodleQ__ es una librería de R para la creación de bancos de preguntas para moodle desde una perspectiva basada en clases R6 y programación orientada a objetos (POO), permite crear fácilmente preguntas de los principales tipos que tiene moodle. Las preguntas se salvan en un fichero xml que es importado en moodle dentro de su banco de preguntas, este sistema es mucho más rápido que crear una a una las preguntas usando la interfaz gráfica de moodle y permite diseñar cuestionarios más complejos.

***

## Instalación y primeros pasos

El paquete se puede instalar vía devtools y github

```R
devtools::install_github("mcstllns/moodleQ")
```

Si no está instalado previamente devtools puede instalarse con

```R
install.packages("devtools")
```

y una vez instalado el paquete se carga con
```R
library(moodleQ)
```

Las preguntas se crean invocando al constructor _question$new()_. Los argumentos de la función son los parámetros que definen una pregunta. Cada tipo de pregunta tiene definidos unos parámetros o campos por defecto que hay que completar para que sea una pregunta válida, muchos de esos parámetros han sido definidos por defecto, aunque se pueden modificar (ver las configuraciones por defecto al final de este documento); por ejemplo, se pueden modificar los argumentos _single_, _shuffleanswer_ y _answernumbering_ para cambiar la forma de marcar, la aleatorización y el numerado de las alternativas de la pregunta respectivamente. 

```R
q1 <- question$new(
  type="multichoice",
  'name' = "Q001",
  'question' = "This is the question text",
  'single' = 'false',
  'shuffleanswers' = 0,
  'answernumbering' = 'none',
  'answer' = list("Answer #1", 100),
  'answer' = list("Answer #2"),
  'answer' = list("Answer #3"))
```


![](./docs/images/02.png)

***

## Documentación

* Ir a la página con la documentación: [mcstllns.github.io/moodleQ/](https://mcstllns.github.io/moodleQ/)
* Descargar la documentación en pdf y con código de ejemplo: [moodleQ-man.zip](./docs/moodleQ-man.zip)
* Ir a la página de github: [mcstllns/moodleQ](https://github.com/mcstllns/moodleQ)

***
<span style="font-size:15px;float:right">Miguel A. Castellanos (2020)</span>

