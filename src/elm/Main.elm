port module Main exposing (..)

import Browser
import Browser.Events
--
import Html exposing (..)
import Html.Attributes
import Html.Events
--
import Json.Decode as Decode
import Json.Encode as Encode
--
import WebAudio exposing (..)
import WebAudio.Context exposing (AudioContext)
import WebAudio.Property as Prop

-- Send the JSON encoded audio graph to javascript
port updateAudio : Encode.Value -> Cmd msg

-- MAIN ------------------------------------------------------------------------
main : Program Decode.Value Model Msg
main =
  Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

-- MODEL -----------------------------------------------------------------------
--
type alias Model =
  { context : AudioContext
  , freq : Float
  }

--
init : Decode.Value -> (Model, Cmd Msg)
init context =
  let
    model = Model context 0 
  in
  ( model, audio model )

-- UPDATE ----------------------------------------------------------------------
--
type Msg
  = NoOp
  | MouseMove Float

--
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      ( model, Cmd.none )

    MouseMove freq ->
      { model | freq = freq }
        |> (\m -> ( m, audio m ))

-- AUDIO -----------------------------------------------------------------------
-- This audio function combines the steps of creating an audio graph, and then
-- encoding it and sending it through a port. You might want to split those
-- two steps up.
audio : Model -> Cmd Msg
audio model =
  updateAudio <| WebAudio.encodeGraph
    [ osc [ Prop.frequency model.freq ]
      [ gain [ Prop.gain 0.1 ] 
        [ dac ]
      ]
    ]

-- VIEW ------------------------------------------------------------------------
--
view : Model -> Html Msg
view model =
  main_ []
    [ text ""
    ]

-- SUBSCRIPTIONS ---------------------------------------------------------------
--
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Browser.Events.onMouseMove <|
        Decode.map MouseMove (Decode.field "clientX" Decode.float)
    ]