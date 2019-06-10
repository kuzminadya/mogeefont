module Specimen exposing (main)

import Browser exposing (Document)
import Browser.Dom exposing (Viewport, getViewport)
import Browser.Events exposing (onResize)
import Browser.Navigation as Navigation exposing (Key)
import Html exposing (Html, div, textarea)
import Html.Attributes exposing (attribute, height, src, style, value, width)
import Html.Events exposing (onInput)
import Http
import Json.Decode exposing (Value)
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import MogeeFont exposing (Letter)
import Task exposing (Task)
import Url exposing (Url)
import WebGL exposing (Entity, Mesh, Shader)
import WebGL.Texture as Texture exposing (Error, Texture, defaultOptions)


type alias Model =
    { key : Key
    , size : Int
    , texture : Maybe Texture
    , text : String
    }


type Msg
    = Resize Int Int
    | TextureLoaded (Result Error Texture)
    | TextChange String
    | Noop


main : Program Value Model Msg
main =
    Browser.application
        { onUrlChange = urlToText >> TextChange
        , onUrlRequest = always Noop
        , init = init
        , update = update
        , view = view
        , subscriptions = always (onResize Resize)
        }


init : Value -> Url -> Key -> ( Model, Cmd Msg )
init _ url key =
    ( { size = 0
      , key = key
      , texture = Nothing
      , text = urlToText url
      }
    , Cmd.batch
        [ loadTexture TextureLoaded
        , Task.perform
            (\{ viewport } ->
                Resize
                    (round viewport.width)
                    (round viewport.height)
            )
            getViewport
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Resize width height ->
            ( { model | size = min ((width - 10) // 2) (height - 10) // 64 * 64 }
            , Cmd.none
            )

        TextureLoaded texture ->
            ( { model | texture = Result.toMaybe texture }
            , Cmd.none
            )

        TextChange text ->
            ( { model | text = text }
            , if text /= model.text then
                Navigation.pushUrl model.key ("#" ++ Url.percentEncode text)

              else
                Cmd.none
            )

        Noop ->
            ( model, Cmd.none )


urlToText : Url -> String
urlToText { fragment } =
    fragment
        |> Maybe.andThen Url.percentDecode
        |> Maybe.withDefault "\nThe quick brown\nfox jumps over\nthe lazy dog"


view : Model -> Document Msg
view { text, texture, size } =
    { title = "MogeeFont"
    , body =
        [ div
            [ style "position" "absolute"
            , style "left" "0"
            , style "top" "0"
            , style "width" "100%"
            , style "height" "100%"
            , style "background" "#000"
            ]
            [ textarea
                [ value text
                , style "right" "50%"
                , style "width" (String.fromInt size ++ "px")
                , style "height" (String.fromInt size ++ "px")
                , style "margin-top" (String.fromInt (-size // 2) ++ "px")
                , style "top" "50%"
                , style "position" "absolute"
                , style "box-sizing" "border-box"
                , style "padding" ("0 " ++ String.fromInt (size // 64) ++ "px")
                , style "border" "0"
                , style "background" "#222"
                , style "resize" "none"
                , style "white-space" "nowrap"
                , style "font-size" (String.fromFloat (toFloat size / 8) ++ "px")
                , style "line-height" (String.fromFloat (toFloat size / 5.8) ++ "px")
                , style "overflow-y" "hidden"
                , style "outline" "none"
                , style "color" "#aaa"
                , style "font-family" "sans-serif"
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
                , style "display" "block"
                , style "position" "absolute"
                , style "top" "50%"
                , style "left" "50%"
                , style "margin-top" (String.fromInt (-size // 2) ++ "px")
                , style "image-rendering" "optimizeSpeed"
                , style "image-rendering" "-moz-crisp-edges"
                , style "image-rendering" "-webkit-optimize-contrast"
                , style "image-rendering" "crisp-edges"
                , style "image-rendering" "pixelated"
                , style "-ms-interpolation-mode" "nearest-neighbor"
                ]
                (texture
                    |> Maybe.map (render text)
                    |> Maybe.withDefault []
                )
            ]
        ]
    }



-- Render text


render : String -> Texture -> List Entity
render text texture =
    [ WebGL.entity
        texturedVertexShader
        texturedFragmentShader
        (mesh text)
        { offset = vec3 2 1 0
        , texture = texture
        , color = vec3 1 1 1
        , textureSize =
            vec2
                (toFloat (Tuple.first (Texture.size texture)))
                (toFloat (Tuple.second (Texture.size texture)))
        }
    ]


mesh : String -> Mesh Vertex
mesh =
    MogeeFont.text addLetter >> WebGL.triangles


addLetter : MogeeFont.Letter -> List ( Vertex, Vertex, Vertex )
addLetter { x, y, width, height, textureX, textureY } =
    [ ( Vertex (vec2 x y) (vec2 textureX textureY)
      , Vertex (vec2 (x + width) (y + height)) (vec2 (textureX + width) (textureY + height))
      , Vertex (vec2 (x + width) y) (vec2 (textureX + width) textureY)
      )
    , ( Vertex (vec2 x y) (vec2 textureX textureY)
      , Vertex (vec2 x (y + height)) (vec2 textureX (textureY + height))
      , Vertex (vec2 (x + width) (y + height)) (vec2 (textureX + width) (textureY + height))
      )
    ]



-- Shaders


type alias Vertex =
    { position : Vec2
    , texPosition : Vec2
    }


type alias Uniform =
    { offset : Vec3
    , color : Vec3
    , texture : Texture
    , textureSize : Vec2
    }


type alias Varying =
    { texturePos : Vec2 }


texturedVertexShader : Shader Vertex Uniform Varying
texturedVertexShader =
    [glsl|

        precision mediump float;
        attribute vec2 position;
        attribute vec2 texPosition;
        uniform vec2 textureSize;
        uniform vec3 offset;
        varying vec2 texturePos;

        void main () {
            vec2 clipSpace = position + offset.xy - 32.0;
            gl_Position = vec4(clipSpace.x, -clipSpace.y, offset.z, 32.0);
            texturePos = texPosition / textureSize;
        }

    |]


texturedFragmentShader : Shader {} Uniform Varying
texturedFragmentShader =
    [glsl|

        precision mediump float;
        uniform sampler2D texture;
        uniform vec3 color;
        varying vec2 texturePos;

        void main () {
            vec4 textureColor = texture2D(texture, texturePos);
            gl_FragColor = vec4(color, 1.0);
            if (dot(textureColor, textureColor) == 4.0) discard;
        }

    |]


loadTexture : (Result Error Texture -> msg) -> Cmd msg
loadTexture msg =
    Texture.loadWith
        { defaultOptions
            | magnify = Texture.nearest
            , minify = Texture.nearest
            , flipY = False
        }
        MogeeFont.spriteSrc
        |> Task.attempt msg
