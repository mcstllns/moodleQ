# cambios:
# - Hacer que el print funcione bien
# - decidir si las definicones sera
  # c <- config$set('name$.value' = "kk) o solo
  # c <- config$set('name' = "kk")
# -documentar bien



#' @description
#' Carga una configuración previamente guardada
#'
#' @details
#' Estos son los detalles de la clase
#' @export
loadQconfig <- function(file){ load(file); return(self)}



# -------------------------------------------
#' Clase R6 para la gestion de los modelos de pregunta
#'
#' @description
#' Gestiona las definiciones de preguntas
#'
#' @details
#' Esta clase permite utilizar y modificar definiciones de preguntas típicas de los cuestionarios de moodle. También permite crear una definición propia.
#'
#' Las definiciones de moodle son: multichoice|truefalse|shortanswer|essay|numerical|description. Las preguntas cloze y matching aún no están definidas.
#'
#' La definiciones se pueden ver en esta página: https://docs.moodle.org/all/es/Formato_Moodle_XML
#'
#' @export
# -------------------------------------------
config <- R6::R6Class("moodleQConfig",
  public= list(
    type = NA,
    prop = list()
  ))

# -------------------------------------------
config$set("private", "insert",
  function(l){
    if (length(l)==0) return()
    key <- names(l)
    for (i in 1:length(l))  eval(parse(text= paste("self$prop$", key[i], "<-", "l[[i]]")))
  })

# -------------------------------------------
config$set("public", "initialize",
  function(type, ...){
    self$type = type
    #self$prop$.attrs = c(type=type)
    private$insert(list(...))
  })

# -------------------------------------------
config$set("public", "print",
  function(){
    k <- as.data.frame(unlist(self$prop))
    row.names(k) <- gsub("\\..value*","",row.names(k))
    names(k) <- ""
    print(k)
  })

# -------------------------------------------
config$set("public", "set",
  function(...) private$insert(list(...)))

# -------------------------------------------
config$set("public", "remove",
  function(...){
    key <- unlist(list(...))
    for (i in 1:length(key)) self$prop[[key[i]]] <- NULL
    invisible(self)
})
# -------------------------------------------
config$set("public", "save",
  function(f){
    save(self, file= f)
  })

# ----------------------------------------------------------------------------
# Inicializamos nuestros default
# ----------------------------------------------------------------------------

multichoice.default = config$new(
  "multichoice",
  '.attrs' = c(type='multichoice'),
  'name$text' = list(.value=NA),
  'questiontext$text' = list(.value=NA, .cdata=TRUE),
  'defaultgrade' = list(.value=1),
  'penalty'	= list(.value=0),
  'hidden' = list(.value=0),
  'synchronize' = list(.value=2),
  'single' = list(.value='true'),
  'answernumbering' = list(.value='abc'),
  'shuffleanswers' = list(.value=1),
  'unitgradingtype' = list(.value=0),
  'unitpenalty' = list(.value=0.1),
  'showunits' = list(.value=3),
  'unitsleft' = list(.value=0),
  'format' = list(.value='html')
)

truefalse.default = config$new(
  "truefalse",
  '.attrs' = c(type='truefalse'),
  'name$text' = list(.value=NA),
  'questiontext$text' = list(.value=NA, .cdata=TRUE))

category.default = config$new(
  "category",
  '.attrs' = c(type='category'),
  'name$text' = list(.value=NA),
  'category$text' = list(.value=NA))

description.default = config$new(
  "description",
  '.attrs' = c(type='description'),
  'name$text' = list(.value=NA),
  'questiontext$text' = list(.value=NA, .cdata=TRUE),
  'format' = list(.value='html'))

essay.default = config$new(
  "essay",
  '.attrs' = c(type='essay'),
  'name$text' = list(.value=NA),
  'questiontext$text' = list(.value=NA, .cdata=TRUE),
  'defaultgrade' = list(.value=1),
  'penalty'	= list(.value=0),
  'hidden' = list(.value=0),
  'responseformat' = list(.value="editor"),
  'responsefieldlines' = list(.value=5),
  'attachments' = list(.value=0))

shortanswer.default = config$new(
  "shortanswer",
  '.attrs' = c(type='shortanswer'),
  'name$text' = list(.value=NA),
  'questiontext$text' = list(.value=NA, .cdata=TRUE))

numerical.default = config$new(
  "numerical",
  '.attrs' = c(type='numerical'),
  'name$text' = list(.value=NA),
  'questiontext$text' = list(.value=NA, .cdata=TRUE))

calculated.default = config$new(
  "calculated",
  '.attrs' = c(type='calculated'),
  'name$text' = list(.value=NA),
  'questiontext$text' = list(.value=NA, .cdata=TRUE),
  'defaultgrade' = list(.value=1),
  'penalty'	= list(.value=0),
  'hidden' = list(.value=0),
  'synchronize' = list(.value=2),
  'single' = list(.value='true'),
  'answernumbering' = list(.value='abc'),
  'shuffleanswers' = list(.value=1))
# --------------------------------------------------------------------

#' @export
def_conf <- list(
  multichoice = multichoice.default,
  truefalse = truefalse.default,
  category = category.default,
  description = description.default,
  essay = essay.default,
  shortanswer = shortanswer.default,
  numerical = numerical.default,
  calculated = calculated.default
)

