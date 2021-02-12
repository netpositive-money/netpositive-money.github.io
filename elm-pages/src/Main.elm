module Main exposing (main)

import Color
import Element exposing (Element)
import Element.Font as Font
import Head
import Head.Seo as Seo
import Html exposing (Html)
import Json.Decode
import Layout
import Markdown.Parser
import Markdown.Renderer
import Metadata exposing (Metadata)
import MySitemap
import Pages exposing (images, pages)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.PagePath exposing (PagePath)
import Pages.Platform
import Pages.StaticHttp as StaticHttp
import Shared exposing (Model,Msg,Data)
import Calculator exposing (request1,request2)
import Markdown.Block as Block exposing (Block, Inline, HeadingLevel)
import Markdown.Block exposing (extractInlineText)
import Markdown.Block exposing (headingLevelToInt)
import Html.Attributes exposing (id)
import Markdown.Renderer exposing (defaultHtmlRenderer)
import Pages.PagePath exposing (toString)
import Shared exposing (Msg(..))



manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.education ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = "netpositive.money - Bitcoiners contributing to climate change solutions "
    , iarcRatingId = Nothing
    , name = "netpositive.money"
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Just "netpositive.money"
    , sourceIcon = images.iconPng
    , icons = []
    }


type alias Rendered =
    (TableOfContents, Element Msg)



-- the intellij-elm plugin doesn't support type aliases for Programs so we need to use this line
-- main : Platform.Program Pages.Platform.Flags (Pages.Platform.Model Model Msg Metadata Rendered) (Pages.Platform.Msg Msg Metadata Rendered)


main : Pages.Platform.Program Model Msg Metadata Rendered Pages.PathKey
main =
    Pages.Platform.init
        { init = \_ -> Calculator.init
        , view = view
        , update = Calculator.update
        , subscriptions = subscriptions
        , documents = [ markdownDocument ]
        , manifest = manifest
        , canonicalSiteUrl = canonicalSiteUrl
        , onPageChange = Just OnPageChange
        , internals = Pages.internals
        }
        |> Pages.Platform.withFileGenerator generateFiles
        |> Pages.Platform.toProgram


generateFiles :
    List
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        , body : String
        }
    ->
        StaticHttp.Request
            (List
                (Result String
                    { path : List String
                    , content : String
                    }
                )
            )
generateFiles siteMetadata =
    StaticHttp.succeed
        [ MySitemap.build { siteUrl = canonicalSiteUrl } siteMetadata |> Ok
        ]


markdownDocument : { extension : String, metadata : Json.Decode.Decoder Metadata, body : String -> Result error (TableOfContents, (Element Msg)) }
markdownDocument =
    { extension = "md"
    , metadata = Metadata.decoder
    , body =
        \markdownBody ->
            -- Html.div [] [ Markdown.toHtml [] markdownBody ]
            let b = Markdown.Parser.parse markdownBody
                    |> Result.withDefault []
            in b |> Markdown.Renderer.render headingRenderer
                |> Result.withDefault [ Html.text "" ]
                |> Html.div []
                |> Element.html
                |> List.singleton
                |> Element.paragraph [ Element.width Element.fill ]
                |> \c -> Ok (buildToc b,c)
    }


subscriptions _ _ = Calculator.subscriptions


view :
    List ( PagePath Pages.PathKey, Metadata )
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        }
    ->
        StaticHttp.Request
            { view : Model -> Rendered -> { title : String, body : Html Msg }
            , head : List (Head.Tag Pages.PathKey)
            }
view siteMetadata page =
    StaticHttp.map2 (\data tbtc ->
        { view =
            \model viewForPage ->
              Layout.view model (pageView data tbtc model siteMetadata page viewForPage) page
        , head = head page.frontmatter
        } )
        request1
        request2


pageView :
    Data -> Data
    -> Model
    -> List ( PagePath Pages.PathKey, Metadata )
    -> { path : PagePath Pages.PathKey, frontmatter : Metadata }
    -> Rendered
    -> { title : String, body : List (Element Msg) }
pageView data tbtc model siteMetadata page viewForPage =
    case page.frontmatter of
        Metadata.Page metadata ->
            { title = metadata.title
            , body = case viewForPage of
                         (t,b) ->
                             [b]
            }

        Metadata.Calculator metadata ->
            { title = metadata.title
            , body =
                Calculator.view data tbtc model
            }

        Metadata.TocPage metadata ->
            { title = metadata.title
            , body = case viewForPage of
                         (t,b) ->
                             [tocView t <| toString page.path, b]

            }



commonHeadTags : List (Head.Tag Pages.PathKey)
commonHeadTags =
    [ Head.rssLink "/blog/feed.xml"
    , Head.sitemapLink "/sitemap.xml"
    ]



{- Read more about the metadata specs:

   <https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/abouts-cards>
   <https://htmlhead.dev>
   <https://html.spec.whatwg.org/multipage/semantics.html#standard-metadata-names>
   <https://ogp.me/>
-}


head : Metadata -> List (Head.Tag Pages.PathKey)
head metadata =
    commonHeadTags
        ++ (case metadata of
                Metadata.Page meta ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = "netpositive.money"
                        , image =
                            { url = images.iconPng
                            , alt = "elm-pages logo"
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = siteTagline
                        , locale = Nothing
                        , title = meta.title
                        }
                        |> Seo.website

                Metadata.TocPage meta ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = "netpositive.money"
                        , image =
                            { url = images.iconPng
                            , alt = "elm-pages logo"
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = siteTagline
                        , locale = Nothing
                        , title = meta.title
                        }
                        |> Seo.website

                Metadata.Calculator meta ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = "netpositive.money"
                        , image =
                            { url = images.iconPng
                            , alt = "elm-pages logo"
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = siteTagline
                        , locale = Nothing
                        , title = meta.title
                        }
                        |> Seo.website

                )

canonicalSiteUrl : String

canonicalSiteUrl =
    "https://netpositive.money"


siteTagline : String
siteTagline =
    "Bitcoiners contributing to climate change solutions"


type alias TableOfContents =
    List { anchorId : String, name : String, level : Int }

tocView : TableOfContents -> String -> Element Msg
tocView toc url =
    Element.column [ Element.alignTop, Element.spacing 20 ]
        [ Element.el [ Font.bold, Font.size 22 ] (Element.text "Table of Contents")
        , Element.column [ Element.spacing 10 ]
            (toc
                |> List.map
                    (\headingBlock ->
                        Element.paragraph [] [Element.link [ Font.color (Element.rgb255 100 100 100) ]
                            { url = url++ "#" ++ headingBlock.anchorId
                            , label = Element.text headingBlock.name
                            }]
                    )
            )
        ]


buildToc : List Block -> TableOfContents
buildToc blocks =
    let
        headings =
            gatherHeadings blocks
    in
    headings
        |> List.map Tuple.second
        |> List.map
            (\styledList ->
                { anchorId = styledToString styledList |> rawTextToId
                , name = styledToString styledList
                , level = 1
                }
            )

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
                    }

styledToString : List Inline -> String
styledToString list =
    extractInlineText list



gatherHeadings : List Block -> List ( Int, List Inline )
gatherHeadings blocks =
    List.filterMap
        (\block ->
            case block of
                Markdown.Block.Heading level content ->
                    Just ( headingLevelToInt level, content )

                _ ->
                    Nothing
        )
        blocks

rawTextToId rawText =
    rawText
        |> String.toLower
        |> String.replace " " ""
