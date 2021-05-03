module HelloWorld exposing (main)
import Dict exposing (update)
import Browser

--import Browser
import Html exposing (div,h1, img, text)
import Html.Attributes exposing (..)

view model = 
    div [] 
        [ h1 [] [ text "Hello World"]]

main =
    view "no model yet"


-- main =  --This returns a model
--     Browswer.sandbox 
--     {init = initialModel
--     , view = view 
--     , update = update
--     }

-- main = --This returns ( Model, Cmd Msg)
--     Browser.element
--         { init = \flags -> ( initialModel, Cmd.none)
--         , view = view
--         , update = update
--         , subscriptions = \model -> Sub.none}