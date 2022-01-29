# cambios:
# - Hacer que el print funcione bien
# - decidir si las definicones sera
  # c <- config$set('name$.value' = "kk) o solo
  # c <- config$set('name' = "kk")
# -documentar bien



#' Clase R6 para la gestion de las preguntas de moodle
#'
#' @description
#' creación de bancos de preguntas para moodle con clases R
#'
#' Manual: \url{https://mcstllns.github.io/moodleQ/}
#' @export
loadQconfig <- function(file){ load(file); return(self)}



# -------------------------------------------
#' Clase R6 para la gestion de las preguntas de moodle
#'
#' @description
#' creación de bancos de preguntas para moodle con clases R
#'
#' Manual: \url{https://mcstllns.github.io/moodleQ/}
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
  'questiontext' = list(
    .attrs = c(format = "html"),
    text = list(.value=NA, .cdata=TRUE)),

# '$text' = list(.value=NA, .cdata=TRUE),
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
  'questiontext' = list(
    .attrs = c(format = "html"),
    text = list(.value=NA, .cdata=TRUE)))


category.default = config$new(
  "category",
  '.attrs' = c(type='category'),
  'name$text' = list(.value=NA),
  'category$text' = list(.value=NA))

description.default = config$new(
  "description",
  '.attrs' = c(type='description'),
  'name$text' = list(.value=NA),
  'questiontext' = list(
    .attrs = c(format = "html"),
    text = list(.value=NA, .cdata=TRUE)),
  'format' = list(.value='html'))

essay.default = config$new(
  "essay",
  '.attrs' = c(type='essay'),
  'name$text' = list(.value=NA),
  'questiontext' = list(
    .attrs = c(format = "html"),
    text = list(.value=NA, .cdata=TRUE)),
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
  'questiontext' = list(
    .attrs = c(format = "html"),
    text = list(.value=NA, .cdata=TRUE)))


numerical.default = config$new(
  "numerical",
  '.attrs' = c(type='numerical'),
  'name$text' = list(.value=NA),
  'questiontext' = list(
    .attrs = c(format = "html"),
    text = list(.value=NA, .cdata=TRUE)))

calculated.default = config$new(
  "calculated",
  '.attrs' = c(type='calculated'),
  'name$text' = list(.value=NA),
  'questiontext' = list(
    .attrs = c(format = "html"),
    text = list(.value=NA, .cdata=TRUE)),
  'defaultgrade' = list(.value=1),
  'penalty'	= list(.value=0),
  'hidden' = list(.value=0),
  'synchronize' = list(.value=2),
  'single' = list(.value='true'),
  'answernumbering' = list(.value='abc'),
  'shuffleanswers' = list(.value=1))


gapselect.default = config$new(
  "calculated",
  '.attrs' = c(type='gapselect'),
  'name$text' = list(.value=NA),
  'questiontext' = list(
    .attrs = c(format = "html"),
    text = list(.value=NA, .cdata=TRUE)),
  'defaultgrade' = list(.value=1),
  'penalty'	= list(.value=0),
  'hidden' = list(.value=0),
  'shuffleanswers' = list(.value=0))
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
  calculated = calculated.default,
  gapselect = gapselect.default
)

