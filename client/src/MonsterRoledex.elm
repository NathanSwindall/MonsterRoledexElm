module MonsterRoledex exposing (..)
import Dict exposing (update)
import Browser

--import Browser
import Html exposing (Html,div,h1, img, text, h2, p)
import Html.Attributes exposing (type_,placeholder,class)
import Html exposing (input)
import Http exposing (..)
import Json.Decode as JD
import Json.Decode.Pipeline exposing (optional, required)




type alias Card = 
    { name : String 
    , email : String
    , img : String 
    }

type alias Card2 = 
    { name : String 
    , email : String}

type alias Model2 = 
    { cards : List Card2}

type alias Model = {cards : List Card
                   ,people: List Person
                   ,error: String
                   }


type Msg = GetCardInfo (Result Http.Error Model)
           | GetPeople (Result Http.Error People)

type alias Person = 
    { id: Int
    , name: String
    , email: String
    }

type alias People  = List Person

--https://jsonplaceholder.typicode.com/users
-- {
--     "id": 1,
--     "name": "Leanne Graham",
--     "username": "Bret",
--     "email": "Sincere@april.biz",
--     "address": {
--       "street": "Kulas Light",
--       "suite": "Apt. 556",
--       "city": "Gwenborough",
--       "zipcode": "92998-3874",
--       "geo": {
--         "lat": "-37.3159",
--         "lng": "81.1496"
--       }
--     },
--     "phone": "1-770-736-8031 x56442",
--     "website": "hildegard.org",
--     "company": {
--       "name": "Romaguera-Crona",
--       "catchPhrase": "Multi-layered client-server neural-net",
--       "bs": "harness real-time e-markets"
--     }
--   }

-- Http.get
--         { url = "http://elm-in-action.com/folders/list"
--         , expect = Http.expectJson GotInitialModel modelDecoder}

view : Model -> Html Msg
view model = 
    div [ class "App"] 
        [ h1 [] [ text "Monster Rolodex"]
        , div [ type_ "search", class "searchBox"] 
            [ input  [placeholder "search monsters"] []
            ]
        , div [class "card-list"]
            [ div [ class "card-container"] 
                [ img [] []
                , h2 [] [ text "Leanne Graham"]
                , p [] [text "Sincere@april.biz"]
                , div [] (List.map viewPerson model.people)
                ]
            ]
        ]

viewPerson : Person -> Html Msg
viewPerson person = 
    div []
        [ h1 [] [text person.name]
        , p [] [text person.email]
        , p [] [text (String.fromInt person.id)]
        ]



initialModel : Model
initialModel = 
    { cards= []
    , people = [] 
    , error = ""
    }

-- init : () -> (Model, Cmd Msg)
-- init _= 
--     ( initialModel
--     , Http.get
--          { url = "https://jsonplaceholder.typicode.com/users"
--          , expect = Http.expectJson GetCardInfo modelDecoder})

init : () -> (Model, Cmd Msg)
init _ = 
    (initialModel
    , Http.get
          { url = "https://jsonplaceholder.typicode.com/users"
         , expect = Http.expectJson GetPeople personsDecoder})
-- modelDecoder : JD.Decoder Model
-- modelDecoder = 
--     JD.succeed
--         {cards = [{ name= "Nathan Swindall"
--                 , email= "Nathan.Swindall@gamil.com"
--                 , img = "My image" }
--                 ,{ name = "Thomas Swindall"
--                 , email= "Thomas.Swindall@gmail.com"
--                 , img = "Baby picture of Thomas"}
--                 ]
--         }

personDecoder : JD.Decoder Person
personDecoder = 
    JD.succeed Person
        |> required "id" JD.int
        |> required "name" JD.string
        |> required "email" JD.string

personsDecoder : JD.Decoder (List Person)
personsDecoder = (JD.list personDecoder)

cardDecoder : JD.Decoder Card 
cardDecoder = 
    JD.succeed Card
        |> required "name" JD.string 
        |> required "email" JD.string 
        |> required "img" JD.string

cardDecoder2 : JD.Decoder Card2
cardDecoder2 = 
    JD.map2 Card2 
        (JD.field "name" JD.string)
        (JD.field "email" JD.string)

-- modelDecoder_: JD.Decoder Model 
-- modelDecoder_ = 
--     JD.succeed Model 
--         |> required "cards" (JD.list cardDecoder)

-- modelDecoder2 : JD.Decoder Model2
-- modelDecoder2 = 
--     JD.succeed Model2 
--         |> required "cards" (JD.list cardDecoder2)

-- exampleJson : String 
-- exampleJson = """{"cards": [{ "name": "Nathan Swindall"
--                 , "email": "Nathan.Swindall@gamil.com"
--                 , "img" : "My image" }
--                 ,{ "name": "Thomas Swindall"
--                 , "email": "Thomas.Swindall@gmail.com"
--                 , "img": "Baby picture of Thomas"}
--                 ]
--                 }"""

-- ds MR.modelDecoder_ MR.exampleJson
-- ds = JD.decodeString


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        GetCardInfo _ -> 
            (model, Cmd.none)
        GetPeople (Ok people) -> 
            ({model | people = people}, Cmd.none)
        GetPeople (Err message)-> 
            (model, Cmd.none)


main : Program () Model Msg
main = --This returns ( Model, Cmd Msg)
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none}