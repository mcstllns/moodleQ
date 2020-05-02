

# -------------------------------------------
#' Clase R6 para la gestion de las preguntas de moodle
#'
#' @description
#' creación de bancos de preguntas para moodle con clases R
#'
#' Manual: \url{https://mcstllns.github.io/moodleQ/}
#' @export
# -------------------------------------------
question <- R6::R6Class("moodleQQuestion",
  public = list(
    #' @field type El tipo de pregunta
    type = NA,
    #' @field prop Contiene todas las propiedades de las preguntas
    prop = list()
  ))

# -------------------------------------------
question$set("private", "insert",
  function(l){
   if (length(l)==0) return()
   key <- names(l)
   for (i in 1:length(l))
      if (key[i] == 'question') eval(parse(text= paste("self$prop$", 'questiontext$text$.value', "<-", "l[[i]]")))
      else if (key[i] == 'dataset') do.call(self$addDataset, l[[i]])
      else if (key[i] == 'file') do.call(self$addfile, l[[i]])
      else if (key[i] == 'answer') do.call(self$addanswer, l[[i]])
      else if (key[i] == 'category') self$prop$category$text$.value <- l[[i]]
      else if (key[i] == 'name') self$prop$name$text$.value <- l[[i]]
      else if (key[i] == 'format'){
         self$prop$questiontext$.attrs <- c(format = l[[i]])
         self$prop$format$.value <- l[[i]]
      }
      else eval(parse(text= paste("self$prop$", key[i], "$.value ", "<-", "l[[i]]")))
  })

# -------------------------------------------
question$set("public", "initialize",
  function(type = NA, confuser = 0, ...){
   self$type = type
   if (!hasArg(confuser)) configuration <- def_conf[[type]]
   else configuration <- confuser
   self$prop = configuration$prop
   private$insert(list(...))
   invisible(self)
  })

# -------------------------------------------
question$set("public", "set",
  function(...){
   l <- list(...)
   # si se va a definir answer entonces se elimnan todas o no seria un set sino un addanswer
   if ("answer" %in% names(l)) self$prop[which(names(self$prop)=='answer')] <- NULL
   private$insert(l)
   invisible(self)
  })


# -------------------------------------------
question$set("public", "remove",  # CON DUDAS
  function(...){
   key <- unlist(list(...))
   for (i in 1:length(key)) self$prop[[key[i]]] <- NULL
   invisible(self)
  })

# -------------------------------------------
question$set("public", "print",
  function(){
   u <- unlist(self$prop)
   print(
     data.frame(props=gsub("\\..attrs*","", gsub("\\..value*","",names(u))),
                value = as.vector(u)))
  })

# -------------------------------------------
question$set("public", "errorHandler",
  function(id){
   cat("Se ha producido el error: ", id)
   stop()
  })

# -------------------------------------------
question$set("public", "xml_parser",
  function(l, nombre){
   options(warn=-1)
   #    cat("\n -- ", nombre)
   doc = XML::newXMLNode(
     nombre,
     if(!is.null(l$.value)) l$.value else NULL,
     attrs = if(!is.null(l$.attrs)) l$.attrs else NULL,
     cdata = if(!is.null(l$.cdata)) l$.cdata else FALSE)

   for(i in 1:length(l)){
     if (!startsWith(names(l)[i], ".")) XML::addChildren(doc, self$xml_parser(l[[i]], names(l)[i]))
   }
   return(doc)
  })

# -------------------------------------------
question$set("public", "xml",
  function(...){
   doc <- self$xml_parser(self$prop, nombre = 'question')
   return(doc)
  })

# -------------------------------------------
question$set("public", "removeanswer",
  function(num){
   v <- which(names(self$prop)=='answer')
   self$prop[[v[num]]] <- NULL
  })


# -------------------------------------------
question$set("public", "addanswer",
  function(text, fraction = 0, format = self$prop$format$.value,
          tolerance = 0.001, tolerancetype = 2, correctanswerformat = 1, correctanswerlength = 3){
   self$prop[[length(self$prop)+1]] <- NA
   names(self$prop)[length(self$prop)] <- "answer"
   if (self$type=="calculated"){
     self$prop[length(self$prop)][['answer']] <- list(
       .attrs = c(fraction = fraction),
       text = list(.value = text),
       tolerance = list(.value = tolerance),
       tolerancetype = list(.value = tolerancetype),
       correctanswerformat = list(.value = correctanswerformat),
       correctanswerlength = list(.value = correctanswerlength))
   } else {
     self$prop[length(self$prop)][['answer']] <- list(
       .attrs = c(fraction = fraction, format = format),
       text = list(
         .value = text,
         .cdata = self$prop$questiontext$text$.cdata))
   }
   invisible(self)
  })

# -------------------------------------------

question$set("public", "addfile",
  function(drivePath, name=NULL, quizPath="/"){
   if (is.null(name)) name=basename(drivePath)
   # fp = "./fichero.csv"
   self$prop$questiontext[length(self$prop$questiontext)+1] <- NA
   names(self$prop$questiontext)[length(self$prop$questiontext)] <- "file"
   self$prop$questiontext[length(self$prop$questiontext)][['file']] <- list(
     .value = base64enc::base64encode(drivePath),
     .attrs = c(name=name, path="/", encoding = "base64"))
   invisible(self)
  })

# -------------------------------------------


question$set("public", "addDataset",
  function(df, name = NA, status="shared", type = "calculated"){

   if (is.null(self$prop$dataset_definitions)) self$prop$dataset_definitions <- list()

   len <- length(self$prop$dataset_definitions)

   it <- list()
   for (i in 1:nrow(df)){
     it[[i]] <- list(number = list(.value=i), value = list(.value = df[i,1]))
     names(it)[i] <- "dataset_item"
   }

   self$prop$dataset_definitions[[len+1]]<- list(
     status = list(text=list(.value=status)),
     name = list(text=list(.value= if(is.na(name)) names(df) else name)),
     type = list(.value=type),
     itemcount = list(.value = nrow(df)),
     number_of_items = list(.value = nrow(df)),
     dataset_items = it
   )

   names(self$prop$dataset_definitions)[len+1] <- "dataset_definition"
  })



# --------------------------------------------------------------------
# Ejemplos de uso
# --------------------------------------------------------------------
#
# q <- question$new(
#   type="multichoice",
#   'name' = "P001",
#   'question' = "Enunciado",
#   'answer' = list("Answer 1", 100),
#   'answer' = list("Answer 2", 50),
#   'answer' = list("Answer 3"))
#
#
#
# q
# q$xml()
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
# q$set(  'answer' = list("Answer 10", 100),
#         'answer' = list("Answer 20", 50),
#         'answer' = list("Answer 30"))
#
#
# q <- question$new(
#   type="multichoice",
#   'name' = "P001",
#   'questiontext$text' = "Enunciado")$
#   addanswer("Answer 1", 100) $
#   addanswer("Answer 2", 0)   $
#   addanswer("Answer 3", 0)
#
#
# q
#
#
# q$addanswer("Answer 1", 100)
# q$addanswer("Answer 2", 0)
# q$addanswer("Answer 3", 0)
#
# q$addanswer("Answer 1", 100, return = T) $
#   addanswer("Answer 2", 0, return = T)   $
#   addanswer("Answer 3", 0)
#
#
#
# q$removeanswer(2)
# q
#
#
# p <- list(a=2, prop = list(kk = 23, answer = list(text="Answer 1")))
#
# p
#
# p$prop[[length(p$prop)+1]] <- NA
# names(p$prop)[length(p$prop)] <- "answer"
# p$prop[length(p$prop)][['answer']] <- list(text = NA)
# p$prop[length(p$prop)][['answer']][['text']] <- "Answer 2"
#
# p
# str(p)
#
# w <- which(names(p$prop)=='answer')
# w
#
# p$prop[w] <- NULL
# str(p)


# l <- list(a=2, b = NA, c = list(d=2, e = NA, f = list(g=4, h=NA)))
# l
# !is.na(l)
# !is.na(q$prop)



#
# q <- question$new(type="multichoice",
#                   name = "P001")
# q
# q$set(questiontext ="Este es el enuncuado",
#       answer = list(
#         text = c("Respuesta 1",
#                  "Respuesta 2"),
#         punt = c(100, 0)
#       ))
#
# q
# q$prop$answer$text[1] <- "cambiada la Respuesta 1"
# q
# q$xml()
#
# saveXML(q$xml(), "kk.xml")
#
#

# # usando una configuracion del usuario
# miconf <- config$new(
#   type="multichoice"
# )
#
# miconf$add(kk = 23)
# q <- question$new(type="multichoice",
#                   confuser = miconf)
# q
# q$prop

# pruebas do.call
