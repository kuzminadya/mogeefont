module Specimen exposing (main)

import Task exposing (Task)
import Window exposing (Size)
import Html
import Html exposing (Html, div, textarea)
import Html.Events exposing (onInput)
import Html.Attributes exposing (value, autofocus, height, src, style, width, attribute)
import Math.Vector2 as Vec2 exposing (Vec2, vec2)
import Math.Vector3 as Vec3 exposing (Vec3, vec3)
import WebGL exposing (Texture, Shader, Mesh, Entity)
import WebGL.Texture as Texture exposing (Error, defaultOptions)
import WebGL exposing (Entity)
import MogeeFont exposing (Letter)
import Navigation
import Http


type alias Model =
    { size : Int
    , font : Maybe Texture
    , text : String
    }


type Msg
    = Resize Size
    | TextureLoaded (Result Error Texture)
    | TextChange String
    | UrlUpdate String


main : Program Never Model Msg
main =
    Navigation.program (.hash >> UrlUpdate)
        { init = init
        , update = update
        , view = view
        , subscriptions = always (Window.resizes Resize)
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init { hash } =
    ( { size = 0
      , font = Nothing
      , text =
            if hash == "" then
                "\nThe quick brown\nfox jumps over\nthe lazy dog"
            else
                hashToText hash
      }
    , Cmd.batch
        [ loadTexture TextureLoaded
        , Task.perform Resize Window.size
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Resize { width, height } ->
            ( { model | size = min ((width - 10) // 2) (height - 10) // 64 * 64 }
            , Cmd.none
            )

        TextureLoaded font ->
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
hashToText =
    String.dropLeft 1
        >> Http.decodeUri
        >> Maybe.withDefault ""


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
                |> Maybe.map (render text)
                |> Maybe.withDefault []
            )
        ]



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


addLetter : MogeeFont.Letter -> List ( Vertex, Vertex, Vertex ) -> List ( Vertex, Vertex, Vertex )
addLetter { x, y, width, height, textureX, textureY } =
    (::)
        ( Vertex (vec2 x y) (vec2 textureX textureY)
        , Vertex (vec2 (x + width) (y + height)) (vec2 (textureX + width) (textureY + height))
        , Vertex (vec2 (x + width) y) (vec2 (textureX + width) textureY)
        )
        >> (::)
            ( Vertex (vec2 x y) (vec2 textureX textureY)
            , Vertex (vec2 x (y + height)) (vec2 textureX (textureY + height))
            , Vertex (vec2 (x + width) (y + height)) (vec2 (textureX + width) (textureY + height))
            )



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
        MogeeFont.fontSrc
        |> Task.attempt msg
