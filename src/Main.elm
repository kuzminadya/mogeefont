module MogeeFont exposing (main)

import Task exposing (Task)
import Window exposing (Size)
import WebGL.Texture exposing (Error, Texture)
import Html
import View.Font as Font
import Html exposing (Html, div, textarea)
import Html.Events exposing (onInput)
import Html.Attributes exposing (value, autofocus, height, src, style, width, attribute)
import WebGL exposing (Entity)
import View.Font as Font exposing (Text)
import Navigation
import Http


type alias Model =
    { size : Int
    , font : Maybe Texture
    , text : String
    }


type Msg
    = Resize Size
    | FontLoaded (Result Error Texture)
    | TextChange String
    | UrlUpdate String


main : Program Never Model Msg
main =
    Navigation.program
        (.hash >> UrlUpdate)
        { init =
            \{ hash } ->
                ( { size = 0
                  , font = Nothing
                  , text =
                        if hash == "" then
                            "\nThe quick brown\nfox jumps over\nthe lazy dog"
                        else
                            hashToText hash
                  }
                , Cmd.batch
                    [ Font.load FontLoaded
                    , Task.perform Resize Window.size
                    ]
                )
        , subscriptions = always (Window.resizes Resize)
        , update = update
        , view = view
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Resize { width, height } ->
            ( { model | size = min ((width - 10) // 2) (height - 10) // 64 * 64 }
            , Cmd.none
            )

        FontLoaded font ->
            ( { model | font = Result.toMaybe font }
            , Cmd.none
            )

        TextChange text ->
            ( model
            , Navigation.newUrl ("#" ++ Http.encodeUri text)
            )

        UrlUpdate hash ->
            ( { model | text = hashToText hash }
            , Cmd.none
            )


hashToText : String -> String
hashToText hash =
    hash
        |> String.dropLeft 1
        |> Http.decodeUri
        |> Maybe.withDefault ""


view : Model -> Html Msg
view { text, font, size } =
    div
        [ style
            [ ( "position", "absolute" )
            , ( "left", "0" )
            , ( "top", "0" )
            , ( "width", "100%" )
            , ( "height", "100%" )
            , ( "background", "#000" )
            ]
        ]
        [ textarea
            [ value text
            , autofocus True
            , style
                [ ( "right", "50%" )
                , ( "width", toString size ++ "px" )
                , ( "height", toString size ++ "px" )
                , ( "margin-top", toString (-size // 2) ++ "px" )
                , ( "top", "50%" )
                , ( "position", "absolute" )
                , ( "box-sizing", "border-box" )
                , ( "padding", "0 " ++ toString (size // 64) ++ "px" )
                , ( "border", "0" )
                , ( "background", "#222" )
                , ( "resize", "none" )
                , ( "white-space", "nowrap" )
                , ( "font-size", toString (toFloat size / 8) ++ "px" )
                , ( "line-height", toString (toFloat size / 5.8) ++ "px" )
                , ( "overflow-y", "hidden" )
                , ( "outline", "none" )
                , ( "color", "#aaa" )
                , ( "font-family", "sans-serif" )
                ]
            , attribute "autocomplete" "off"
            , attribute "autocorrect" "off"
            , attribute "autocapitalize" "off"
            , attribute "spellcheck" "false"
            , onInput TextChange
            ]
            []
        , WebGL.toHtmlWith
            [ WebGL.depth 1
            , WebGL.clearColor (22 / 255) (17 / 255) (22 / 255) 0
            ]
            [ width size
            , height size
            , style
                [ ( "display", "block" )
                , ( "position", "absolute" )
                , ( "top", "50%" )
                , ( "left", "50%" )
                , ( "margin-top", toString (-size // 2) ++ "px" )
                , ( "image-rendering", "optimizeSpeed" )
                , ( "image-rendering", "-moz-crisp-edges" )
                , ( "image-rendering", "-webkit-optimize-contrast" )
                , ( "image-rendering", "crisp-edges" )
                , ( "image-rendering", "pixelated" )
                , ( "-ms-interpolation-mode", "nearest-neighbor" )
                ]
            ]
            (font
                |> Maybe.map (\texture -> [ Font.render ( 1, 1, 1 ) (Font.text text) texture ( 2, 1, 0 ) ])
                |> Maybe.withDefault []
            )
        ]
