module MogeeFont exposing (Letter, text, spriteSrc)

{-| This module exports a font that may be rendered with [WebGL](http://package.elm-lang.org/packages/elm-community/webgl/latest).
Check [the example](https://github.com/kuzminadya/mogeefont/blob/master/specimen/Main.elm).

@docs Letter, text, spriteSrc

-}

import Dict exposing (Dict)
import FontData exposing (CharInfo, font)
import String


{-| A function to print the text, that takes:

  - addLetter - function to print a letter
  - string - text to be printed

`addLetter` can for example return two triangles for each letter,
to construct a [WebGL](http://package.elm-lang.org/packages/elm-community/webgl/latest) mesh

-}
text : (Letter -> List a) -> String -> List a
text addLetter string =
    let
        chars =
            List.reverse (replaceLigatures string [])
    in
    textMeshHelper addLetter Nothing chars 0 0 []


{-| Specifies information about the letter:

  - width, height - dimensions on the texture
  - textureX, textureY - offset on the texture
  - x, y - coordinates in the printed text

-}
type alias Letter =
    { width : Float
    , height : Float
    , textureX : Float
    , textureY : Float
    , x : Float
    , y : Float
    }


{-| A black and white sprite containing all glyphs in the base64 data uri format.
Can be loaded just as any remote url with [Texture.load](http://package.elm-lang.org/packages/elm-community/webgl/latest/WebGL-Texture#load).
-}
spriteSrc : String
spriteSrc =
    FontData.spriteSrc


emHeight : Float
emHeight =
    11


spaceWidth : Float
spaceWidth =
    3


tracking : Float
tracking =
    1


invertDict : List ( Int, List String ) -> Dict String Int
invertDict =
    List.foldl
        (\( n, chars ) dict -> List.foldl (\char -> Dict.insert char n) dict chars)
        Dict.empty


{-| Defines the left kerning classes
-}
leftKerningClass : Dict String Int
leftKerningClass =
    invertDict
        [ ( 1, [ "A", "B", "C", "D", "E", "G", "H", "I", "J", "K", "M", "N", "O", "Q", "R", "S", "U", "V", "W", "X", "Z", "l" ] )
        , ( 2, [ "F", "P" ] )
        , ( 3, [ "L" ] )
        , ( 4, [ "T" ] )
        , ( 5, [ "b", "k", "p", "s", "t", "u", "v", "w", "x", "z", "e" ] )
        , ( 6, [ "f", "ff" ] )
        , ( 7, [ "g", "q", "y" ] )
        , ( 8, [ "i", "fi", "ffi" ] )
        , ( 9, [ "j", "fj", "jj" ] ) --?
        , ( 10, [ ".", "," ] )
        , ( 11, [ "'", "\"" ] )
        , ( 12, [ "!", "?" ] )
        , ( 13, [ "/" ] )
        , ( 14, [ "Y", "7" ] )
        , ( 15, [ "(", "[" ] )
        , ( 16, [ "a", "c", "h", "m", "n", "o", "r" ] ) --5
        , ( 17, [ "1", "2", "3", "4", "5", "6", "8", "9" ] ) --5
        ]


{-| Defines the right kerning classes
-}
rightKerningClass : Dict String Int
rightKerningClass =
    invertDict
        [ ( 1, [ "A", "B", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "U", "V", "W", "X", "Z" ] )
        , ( 2, [ "J" ] )
        , ( 3, [ "T", "Y" ] )
        , ( 4, [ "a", "c", "m", "n", "o", "q", "r", "t", "u", "v", "w", "x", "y", "z" ] )
        , ( 5, [ "b", "h", "i", "k", "l" ] )
        , ( 6, [ "e", "d", "g", "p", "s", "ss" ] )
        , ( 7, [ "f", "ff", "fi", "ffi", "fj" ] )
        , ( 8, [ "j", "jj" ] )
        , ( 9, [ "7" ] )
        , ( 10, [ "." ] )
        , ( 11, [ "'", "\"" ] )
        , ( 12, [ "!", "?", ":" ] )
        , ( 13, [ "/" ] )
        , ( 14, [ ",", ";" ] )
        , ( 15, [ "$" ] )
        ]


{-| Defines the kerning between the left and right kerning classes
-}
kerningDict : Dict ( Int, Int ) Float
kerningDict =
    Dict.fromList
        [ ( ( 1, 14 ), -1 )
        , ( ( 2, 2 ), -1 )
        , ( ( 2, 6 ), 0 )
        , ( ( 2, 14 ), -1 )
        , ( ( 14, 2 ), -1 )
        , ( ( 14, 6 ), -1 )
        , ( ( 2, 10 ), -1 )
        , ( ( 2, 13 ), -1 )
        , ( ( 3, 3 ), -1 )
        , ( ( 3, 7 ), -1 )
        , ( ( 3, 14 ), -1 )
        , ( ( 4, 2 ), -2 )
        , ( ( 4, 4 ), -1 )
        , ( ( 4, 6 ), -1 )
        , ( ( 4, 7 ), -1 )
        , ( ( 4, 10 ), -1 )
        , ( ( 4, 13 ), -2 )
        , ( ( 4, 14 ), -2 )
        , ( ( 5, 3 ), -1 )
        , ( ( 5, 14 ), -1 )
        , ( ( 16, 3 ), -1 )
        , ( ( 16, 7 ), -1 )
        , ( ( 16, 9 ), -1 )
        , ( ( 16, 14 ), -1 )
        , ( ( 6, 2 ), -2 )
        , ( ( 6, 3 ), -1 )
        , ( ( 6, 4 ), -1 )
        , ( ( 6, 5 ), -1 )
        , ( ( 6, 6 ), -1 )
        , ( ( 6, 7 ), -2 )
        , ( ( 6, 13 ), -2 )
        , ( ( 6, 14 ), -2 )
        , ( ( 7, 3 ), -1 )
        , ( ( 7, 7 ), 0 )
        , ( ( 8, 7 ), 0 )
        , ( ( 13, 2 ), -1 )
        , ( ( 13, 14 ), -1 )
        , ( ( 14, 10 ), -1 )
        , ( ( 14, 14 ), -1 )
        , ( ( 15, 2 ), -1 )
        , ( ( 15, 13 ), -1 )
        , ( ( 17, 14 ), -1 )
        ]


{-| Defines the custom kerning overrides
-}
kerningOverrides : Dict ( String, String ) Float
kerningOverrides =
    Dict.fromList
        [ ( ( "/", "/" ), -2 ) -- example
        , ( ( "\\", "\\" ), -2 )
        , ( ( "C", "f" ), -1 )
        , ( ( "I", "f" ), -1 )
        , ( ( "f", "T" ), -2 )
        , ( ( "q", "f" ), -1 )
        , ( ( "q", "fi" ), -1 )
        , ( ( "q", "ffi" ), -1 )
        , ( ( "q", "ff" ), -1 )
        , ( ( "л", "ч" ), 1 )
        , ( ( "у", "ч" ), 1 )
        ]


{-| Side bearings, left and right
-}
bearingsDict : Dict String ( Float, Float )
bearingsDict =
    Dict.fromList
        [ ( "j", ( -2, 1 ) )
        , ( "jj", ( -2, 1 ) )
        , ( ",", ( 0, 1 ) )
        , ( ";", ( 0, 1 ) )
        , ( " ", ( 0, 0 ) )
        , ( "г", ( 0, 0 ) )
        , ( "Г", ( 0, 0 ) )
        , ( "ч", ( -1, 1 ) )
        , ( "Ъ", ( -1, 1 ) )
        ]


defaultBearings : ( Float, Float )
defaultBearings =
    ( 0, 1 )


rightBearing : String -> Float
rightBearing char =
    Dict.get char bearingsDict
        |> Maybe.withDefault defaultBearings
        |> Tuple.second


leftBearing : String -> Float
leftBearing char =
    Dict.get char bearingsDict
        |> Maybe.withDefault defaultBearings
        |> Tuple.first


kerning : String -> String -> Float
kerning prevChar nextChar =
    List.filterMap identity
        [ Dict.get ( prevChar, nextChar ) kerningOverrides
        , Maybe.map2
            (\a b -> Dict.get ( a, b ) kerningDict)
            (Dict.get prevChar leftKerningClass)
            (Dict.get nextChar rightKerningClass)
            |> Maybe.andThen identity
        ]
        |> List.head
        |> Maybe.withDefault 0


replaceLigatures : String -> List String -> List String
replaceLigatures st result =
    [ takeLigature 3 st
    , takeLigature 2 st
    , Maybe.map (\( c, rest ) -> ( String.fromChar c, rest )) (String.uncons st)
    ]
        |> List.filterMap identity
        |> List.head
        |> Maybe.map (\( ch, rest ) -> replaceLigatures rest (ch :: result))
        |> Maybe.withDefault result


takeLigature : Int -> String -> Maybe ( String, String )
takeLigature n st =
    let
        ligature =
            String.left n st
    in
    if String.length ligature == n && Dict.member ligature font then
        Just ( ligature, String.dropLeft n st )

    else
        Nothing


textMeshHelper : (Letter -> List a) -> Maybe String -> List String -> Float -> Float -> List a -> List a
textMeshHelper addLetter prevChar text_ currentX currentY list =
    case text_ of
        " " :: rest ->
            textMeshHelper addLetter (Just " ") rest (currentX + spaceWidth) currentY list

        "\n" :: rest ->
            textMeshHelper addLetter (Just "\n") rest 0 (currentY + emHeight) list

        char :: rest ->
            case Dict.get char font of
                Just { x, y, w } ->
                    textMeshHelper addLetter
                        (Just char)
                        rest
                        (currentX + w + letterSpacing prevChar char)
                        currentY
                        (addLetter
                            { width = w
                            , height = emHeight
                            , textureX = x
                            , textureY = y
                            , x = currentX + letterSpacing prevChar char
                            , y = currentY
                            }
                            ++ list
                        )

                Nothing ->
                    textMeshHelper addLetter prevChar rest currentX currentY list

        [] ->
            list


{-| Returns a spacing between two letters as a sum of:

  - right bearing of the previous letter
  - custom kerning for the pair of letters
  - left bearing of the next letter

-}
letterSpacing : Maybe String -> String -> Float
letterSpacing prevChar nextChar =
    case prevChar of
        Nothing ->
            leftBearing nextChar

        Just " " ->
            leftBearing nextChar

        Just "\n" ->
            leftBearing nextChar

        Just char ->
            List.sum
                [ rightBearing char
                , kerning char nextChar
                , leftBearing nextChar
                ]
