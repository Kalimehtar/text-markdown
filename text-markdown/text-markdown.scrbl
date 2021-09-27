#lang scribble/manual

@title{Support for markdown in racket/gui text%}
@author[(author+email "Roman Klochkov" "kalimehtar@mail.ru")]

@(defmodule text-markdown)

@section{Main interface}

Основной интерфейс.

@defproc[(insert-markdown [text (is-a?/c text%)] [string string?]) void?]{
  Inserts markdown @racket[string] into given @racket[text%] widget.

  Вставляет текст в формате Markdown в экранный элемент text.          
}

@defproc[(insert-xexpr [text (is-a?/c text%)] [xexpr list?]) void?]{
  Inserts HTML xexpr into given @racket[text%] widget.

  Вставляет список в формате xexpr, полученный при разборе HTML, в экранный элемент text.            
}

@defproc[(text%->markdown [text (is-a?/c text%)]) string?]{
  Returns @racket[text] content as a Markdown string. Images become inline images, the rest treated as text.

  Возвращает содержимое элемента @racket[text] в виде строки в формате Markdown. Изображения преобразуются во встроенные изображения Markdown, из остальных элементов
сохраняется строковое представление.
}