# -------------------------------------------
#   Miguel A. Castellanos
# -------------------------------------------

# Fecha:
# Descripcion:
# -------------------------------------------



# source("config.R")
# source("questions.R")


# -------------------------------------------
#' Clase R6 para la gestion de los cuestionarios
#'
#' @description
#' Gestiona los cuestionarios
#'
#' @details
#' Crea cuestionarios compuestos por preguntas moodleQ
#' @export
quiz <- R6::R6Class("moodleQQuiz",
      public = list(
        quiz = list()
      ))

# -------------------------------------------
quiz$set("public", "initialize",  function(...) private$addqs(list(...)))

# -------------------------------------------
quiz$set("public", "add", function(...) private$addqs(list(...)))

# -------------------------------------------
quiz$set("private", "addqs",
  function(l){
   n = length(self$quiz)
   for (i in 1:length(l)) self$quiz[[n+i]] <- l[[i]]
  })


# -------------------------------------------
quiz$set("public", "print",
  function(...){
   cat("\nnquestions: ", length(self$quiz), "\n")
   for(i in 1:length(self$quiz)){ cat("\n-----------\n"); print(self$quiz[[i]])}
  })


# -------------------------------------------
quiz$set("public", "xml",
  function(file){
   doc <- XML::newXMLNode("quiz")
   n = length(self$quiz)
   for(i in 1:n) XML::addChildren(doc, kids = list(self$quiz[[i]]$xml()), append = TRUE)
   return(doc)
  })

# -------------------------------------------
quiz$set("public", "remove",
  function(qids){
   for (i in 1:length(qids)) self$quiz[[qids[i]]] <- NULL
   invisible(self)
  })

# -------------------------------------------
quiz$set("public", "save_xml",
  function(file){
   XML::saveXML(self$xml(), file)
  })
# --------------------------------------------------------------------
# Ejemplos de uso
# --------------------------------------------------------------------

# q0 <- question$new(
#     type="category",
#     'category$text' = "$course$/pruebas_moodleQ")
#
# q0$xml()
# q1 <- question$new(
#   type="multichoice",
#   'name' = "P001",
#   'question' = "Enunciado",
#   'answer' = list("Answer 1", 100),
#   'answer' = list("Answer 2", 50),
#   'answer' = list("Answer 3"))
#
# q2 <- question$new(
#   type="multichoice",
#   'name' = "P002",
#   'question' = "Enunciado",
#   'answer' = list("Verdadero", 100),
#   'answer' = list("Falso"))
#
#
# Q <- quiz$new(q1, q2)
# Q




#
#
# Q$remove(1)
# Q
# Q$add(q1)
# Q
# saveXML(Q$xml(), "kk.xml")
# Q$save_xml("mikk.xml")

#
# q1 <- question$new(type="multichoice", name = "P001")
# q2 <- question$new(type="multichoice", name = "P002")
#
# Q <- quiz$new(q1, q2)
#
# Q$xml()
# Q$save_xml("mikk.xml")
# #
# Q$xml()
#
# q3 <- question$new(type="multichoice", name = "P003")
#
# Q <- quiz$new(q1, q2)
# Q$add(q3)
#
# Q
