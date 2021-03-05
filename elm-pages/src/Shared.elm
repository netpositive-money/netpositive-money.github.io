module Shared exposing (..)

import Time exposing (Posix)
import Pages
import Pages.PagePath exposing (PagePath)
import Metadata exposing (Metadata)
import Element exposing (Element)
import Markdown.Renderer exposing (defaultHtmlRenderer)
import Markdown.Block as Block exposing (Block, Inline, HeadingLevel)
import Html exposing (Html)
import Html.Attributes as Attr exposing (id)
import Pages.ImagePath exposing (dimensions)
import Html exposing (Attribute)
import Json.Encode


type alias Model =
    { hovered : Maybe Datum
    , selection : Selection
    , dragging : Bool
    , hinted : Maybe Datum
    , startString : String
    , endString : String
    , btcS : String
    , width : Int
    , height : Int
    , showMobileMenu: Bool
    }

type Msg
    = SetScreenSize Int Int
    | Hold Data
    | Move Data
    | Drop Data
    | LeaveChart Data
    | LeaveContainer Data
      -- Chart 2
    | Hint (Maybe Datum)
    | ChangeStart Data String
    | ChangeEnd Data String
    | ChangeBtc String
    | ToggleMobileMenu
    | OnPageChange
      { path : PagePath Pages.PathKey
      , query : Maybe String
      , fragment : Maybe String
      , metadata : Metadata
      }


type alias ActiveElement = Data-> Data -> Model -> Element Msg

type alias Selection =
    { start : Maybe Datum
    , end : Maybe Datum
    }



---beware, start might be later than end!


type alias Data =
    List Datum


type alias Datum =
    { time : Posix
    , amount : Float
    }


headingRenderer : Markdown.Renderer.Renderer (Html Msg)
headingRenderer = {
    defaultHtmlRenderer |
        heading =
            \{ level, children, rawText } ->
            (case level of
                Block.H1 ->
                    Html.h1

                Block.H2 ->

                    Html.h2

                Block.H3 ->
                    Html.h3

                Block.H4 ->
                    Html.h4

                Block.H5 ->
                    Html.h5

                Block.H6 ->
                    Html.h6)
            [id <| rawTextToId rawText] children
    , image =
        \imageInfo ->
            Html.img (
             [ Attr.src imageInfo.src
             , Attr.alt imageInfo.alt
             , Attr.style "width" "100%"
             , Attr.style "height" "auto"
             , srcset (srcsetstring imageInfo.src)
             ]
                 ++
                 (case imageInfo.title of
                      Just title -> [Attr.title title]
                      Nothing -> [])
                 ++ (imageDimensions imageInfo.src)
            ) []
    }

rawTextToId rawText =
    rawText
        |> String.toLower
        |> String.filter Char.isAlphaNum

-- builds a srcset from images that agree in filename until "_"


srcsetstring = findImages >>
               List.map (\img -> Pages.ImagePath.toString img ++ " " ++
                   case dimensions img of
                       Just d -> (String.fromInt d.width)++"w"
                       Nothing -> ""
                   ) >>
               String.join ","

findImages : String -> List (Pages.ImagePath.ImagePath Pages.PathKey)
findImages src = List.filterMap
                    ( \imagepath ->
                        let path = Pages.ImagePath.toString imagepath in
                          if String.contains (Maybe.withDefault src <| List.head <| String.split "_" src) path
                          then Just imagepath else Nothing
                    )
                 Pages.allImages

srcset : String -> Attribute msg
srcset set =
  Attr.property "srcset" (Json.Encode.string set)



imageDimensions = findImages >>
                  List.head >>
                  Maybe.andThen dimensions >>
                  Maybe.map (\d ->
                        [ Attr.width d.width
                        , Attr.height d.height]
                            ) >>
                  Maybe.withDefault
                        []
