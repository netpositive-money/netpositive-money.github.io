module Layout exposing (view, maxWidth)

import DocumentSvg
import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Font as Font
import Element.Region
import Element.Events
import Html exposing (Html)
import Html.Attributes as Attr
import Metadata exposing (Metadata)
import Pages exposing (pages)
import Pages.Directory as Directory exposing (Directory)
import Pages.ImagePath as ImagePath
import Pages.PagePath as PagePath exposing (PagePath)
import Palette
import FontAwesome
import Shared exposing (..)

maxWidth : number
maxWidth = 1000

view :
    Model
    ->
    { title : String, body : List (Element Msg) }
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        }
    -> { title : String, body : Html Msg }
view model document page =
    { title = document.title
    , body =
        (if model.showMobileMenu then
            Element.column
                [ Element.width Element.fill
                , Element.padding 20
                ]
                [ Element.row [ Element.width Element.fill, Element.spaceEvenly ]
                    [ logoLinkMobile
                    , FontAwesome.styledIcon "fas fa-bars" [ Element.Events.onClick ToggleMobileMenu ]
                    ]
                , Element.column [ Element.centerX, Element.spacing 20 ]
                    (navbarLinks page.path)
                ]
         else
            Element.column [ Element.width Element.fill ]
             [ header page.path document.title
             , Element.column
                   [ Element.padding 30
                   , Element.spacing 40
                   , Element.Region.mainContent
                   , Element.width (Element.fill |> Element.maximum maxWidth)
                   , Element.centerX
                   ]
                 document.body
             ]
        )
        |> Element.layout
                [ Element.width Element.fill
                , Font.size 20
                -- , Font.family [ Font.typeface "Roboto" ]
                , Font.color (Element.rgba255 0 0 0 0.8)
                ]
    }
        

header : PagePath Pages.PathKey -> String ->  Element Msg
header currentPath title =
    Element.column [ Element.width Element.fill ]
        [ responsiveHeader
        , Element.column
            [ Element.width Element.fill
            , Element.htmlAttribute (Attr.class "responsive-desktop")
            ]
            [ Element.el
                [ Element.height (Element.px 4)
                , Element.width Element.fill
                , Element.Background.gradient
                    { angle = 0.2
                    , steps =
                        [ Element.rgb255 0 242 96
                        , Element.rgb255 5 117 230
                        ]
                    }
                ]
                Element.none
            , Element.row
                [ Element.paddingXY 25 4
                , Element.spaceEvenly
                , Element.width Element.fill
                , Element.Region.navigation
                , Element.Border.widthEach { bottom = 1, left = 0, right = 0, top = 0 }
                , Element.Border.color (Element.rgba255 40 80 40 0.4)
                ]
                [ logoLink
                , Element.row [ Element.spacing 15 ] (navbarLinks currentPath)
                ]
            ]
        ]


logoLink =
    Element.link []
        { url = "/"
        , label =
            Element.row
                [ Font.size 30
                , Element.spacing 16
                , Element.htmlAttribute (Attr.class "navbar-title")
                ]
                [ -- DocumentSvg.view
                Element.text "netpositive.money"
                ]
        }


responsiveHeader =
    Element.row
        [ Element.width Element.fill
        , Element.spaceEvenly
        , Element.htmlAttribute (Attr.class "responsive-mobile")
        , Element.width Element.fill
        , Element.padding 20
        ]
        [ logoLinkMobile
        , FontAwesome.icon "fas fa-bars" |> Element.el [ Element.alignRight, Element.Events.onClick ToggleMobileMenu ]
        ]

highlightableLink :
    PagePath Pages.PathKey
    -> Directory Pages.PathKey Directory.WithIndex
    -> String
    -> Element Msg
highlightableLink currentPath linkDirectory displayName =
    let
        isHighlighted =
            currentPath |> Directory.includes linkDirectory
    in
    Element.link
        (if isHighlighted then
            [ Font.underline
            , Font.color Palette.color.primary
            ]

         else
            []
        )
        { url = linkDirectory |> Directory.indexPath |> PagePath.toString
        , label = Element.text displayName
        }


githubRepoLink : Element Msg
githubRepoLink =
    Element.newTabLink []
        { url = "https://github.com/netpositive-money/netpositive-money.github.io"
        , label =
            Element.image
                [ Element.width (Element.px 22)
                , Font.color Palette.color.primary
                ]
                { src = ImagePath.toString Pages.images.github, description = "Github repo" }
        }

logoLinkMobile : Element Msg
logoLinkMobile =
    Element.link []
        { url = "/"
        , label =
            Element.row
                [ Font.size 30
                , Element.spacing 16
                , Element.htmlAttribute (Attr.class "navbar-title")
                ]
                [ Element.text "netpositive.money"
                ]
        }


navbarLinks : PagePath Pages.PathKey -> List (Element Msg)
navbarLinks currentPath =
    [ highlightableLink currentPath Pages.pages.about.directory "about"
    , highlightableLink currentPath Pages.pages.faq.directory "FAQ"
    , highlightableLink currentPath Pages.pages.calculator.directory "calculator"
    , highlightableLink currentPath Pages.pages.sources.directory "sources"
    , githubRepoLink
    ]
