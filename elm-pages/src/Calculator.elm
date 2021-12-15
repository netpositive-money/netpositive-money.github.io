module Calculator exposing (emptySelection, init, request1, request2, subscriptions, update, calculatorRenderer)
import Element exposing (alignRight)
import Element exposing (alignLeft)
import Element exposing (fill)
import Element.Font as Font exposing (size)

import Browser.Dom exposing (getViewport)
import Browser.Events exposing (onResize)
import Csv
import Html
import Iso8601 exposing (fromTime, toTime)
import LineChart
import LineChart.Area as Area
import LineChart.Axis as Axis
import LineChart.Axis.Intersection as Intersection
import LineChart.Axis.Line as AxisLine
import LineChart.Axis.Range as Range
import LineChart.Axis.Ticks as Ticks
import LineChart.Axis.Title as Title
import LineChart.Colors as Colors
import LineChart.Container as Container
import LineChart.Coordinate as Coordinate
import LineChart.Dots as Dots
import LineChart.Events as Events
import LineChart.Grid as Grid
import LineChart.Interpolation as Interpolation
import LineChart.Junk as Junk
import LineChart.Legends as Legends
import LineChart.Line as Line
import List.Extra exposing (dropWhile, find)
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp
import String exposing (left)
import Maybe.Extra exposing (orLazy)
import Svg
import Svg.Attributes
import Task
import Time exposing (Posix, millisToPosix, posixToMillis, utc)
import OptimizedDecoder exposing (field,list,map,map2,int,string,float,andThen,fail,succeed)
import List.Extra exposing (last)
import List exposing (head)
import Element.Lazy exposing (lazy)
import List exposing (filter)
import Time exposing (toDay)
import List.Extra exposing (groupWhile)
import Time exposing (toMonth)
import List exposing (length)
import List exposing (filterMap)
import List exposing (sum)
import Layout exposing (maxWidth)
import Element exposing (width)
import Shared exposing (..)
import Element.Font exposing (color)
import Palette
import Html.Attributes exposing (value, placeholder)
import Html.Events exposing (onInput)
import Markdown.Renderer exposing (defaultHtmlRenderer)
import Markdown.Html
import Html.Attributes exposing (id)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ onResize SetScreenSize ]



factor : Float
factor =
    1.34



--ktCO2/day/Twh/year
--


offset : Float
offset =
    0.054


-- MtCO2
--



-- INIT


init : ( Model, Cmd Msg )
init =
    ( { hovered = Nothing
      , selection = emptySelection
      , dragging = False
      , hinted = Nothing
      , startString = "YYYY-MM"
      , endString = "YYYY-MM"
      , btcS = ""
      , width = 1280
      , height = 720
      , showMobileMenu=False
      }
    , Task.perform
        (\vp ->
            let
                get =
                    \s -> s vp.viewport |> round
            in
            SetScreenSize (get .width) (get .height)
        )
        getViewport
    )



request1: StaticHttp.Request Data
request1 = StaticHttp.map
        (groupWhile (\a b -> (toMonth utc a.time) == (toMonth utc b.time))
           >> filterMap
            (\(s,l) -> if length l < 27 then Nothing
                                  else Just
                                        { amount = (s.amount + (sum <| (List.map .amount l)))/1000 ,
                                            time = s.time
                                        }
            )
        )
        (StaticHttp.unoptimizedRequest
         (Secrets.succeed
              { url = "https://cbeci.org/api/csv"
              , method = "GET"
              , headers = []
              , body = StaticHttp.emptyBody
              }
         )
         (StaticHttp.expectString
              (\content -> parseData content (parsePowRecord factor))
         ))

request2: StaticHttp.Request Data
request2 = StaticHttp.map
    (filter (\d -> (toDay utc d.time) == 1))
    (StaticHttp.get
        (Secrets.succeed
             "https://api.blockchain.info/charts/total-bitcoins?timespan=13years&format=json&cors=true"
        )
    (field "values" <| list <| map2 Datum (field "x" <| map (\i -> millisToPosix (1000 * i)) int) (field "y" float))
    )



-- API


emptySelection : Selection
emptySelection =
    { start = Nothing, end = Nothing }


setSelection : Selection -> Model -> Model
setSelection selection model =
    { model | selection = selection }


setDragging : Bool -> Model -> Model
setDragging dragging model =
    { model | dragging = dragging }


setHovered : Maybe Datum -> Model -> Model
setHovered hovered model =
    { model | hovered = hovered }


setHint : Maybe Datum -> Model -> Model
setHint hinted model =
    { model | hinted = hinted }


getSelectionStart : Datum -> Model -> Datum
getSelectionStart hovered model =
    case model.selection.start of
        Just s ->
            s

        Nothing ->
            hovered


setSelectionString : Datum -> Datum -> Model -> Model
setSelectionString start end model =
    { model
        | startString = start |> datumToTimeString
        , endString = end |> datumToTimeString
    }



-- UPDATE




update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange page ->
            ( { model | showMobileMenu = False }, Cmd.none )

        ToggleMobileMenu ->
            {model | showMobileMenu = not model.showMobileMenu}
                |> addCmd Cmd.none

        SetScreenSize w h ->
            { model
                | height = h
                , width = w
            }
                |> addCmd Cmd.none

        Hold point ->
            model
                |> setSelection emptySelection
                |> setDragging True
                |> addCmd Cmd.none

        Move (point :: xs) ->
            if model.dragging then
                let
                    start =
                        getSelectionStart point model

                    newSelection =
                        Selection (Just start) (Just point)
                in
                model
                    |> setSelection newSelection
                    |> setSelectionString start point
                    |> setHovered (Just point)
                    |> addCmd Cmd.none

            else
                model
                    |> setHovered (Just point)
                    |> addCmd Cmd.none

        Drop (point :: xs) ->
            if point == getSelectionStart point model then
                model
                    |> setSelection emptySelection
                    |> setDragging False
                    |> addCmd Cmd.none

            else
                model
                    |> setDragging False
                    |> addCmd Cmd.none

        LeaveChart point ->
            model
                |> setHovered Nothing
                |> addCmd Cmd.none

        LeaveContainer point ->
            model
                |> setDragging False
                |> setHovered Nothing
                |> addCmd Cmd.none

        Hint point ->
            model
                |> setHint point
                |> addCmd Cmd.none

        ChangeStart compound timeString ->
            addCmd Cmd.none <|
                let
                    selection =
                        model.selection
                in
                { model
                    | startString = timeString
                    , selection =
                        case toTime <| timeString++"-01" of
                            Ok ts ->
                                { selection | start = find (\d -> d.time == ts) compound }

                            Err _ ->
                                selection
                }

        ChangeEnd compound timeString ->
            addCmd Cmd.none <|
                let
                    selection =
                        model.selection
                in
                { model
                    | endString = timeString
                    , selection =
                        case toTime <| timeString++"-01" of
                            Ok ts ->
                                { selection | end = find (\d -> d.time == ts) compound }

                            Err _ ->
                                selection
                }

        ChangeBtc bS ->
            addCmd Cmd.none <|
                { model | btcS = bS }

        _ ->
            model |> addCmd Cmd.none


mkcompound : Data -> Data
mkcompound nd =
    let
        ( sum, summedList ) =
            List.foldl f ( 0, [] ) nd

        f d ( s, l ) =
            let
                ns =
                    s + d.amount
            in
            ( ns, l ++ [ { d | amount = ns } ] )
    in
    summedList


mkPerBtcData : Data -> Data -> Data
mkPerBtcData nd amts =
    case nd of
        [] ->
            []

        x :: xs ->
            let
                rest =
                    dropWhile (\d -> fromTime d.time < fromTime x.time) amts
            in
            case rest of
                [] ->
                    { time = x.time, amount = x.amount / 21000 } :: mkPerBtcData xs []

                y :: ys ->
                    { time = x.time, amount = x.amount / (y.amount / 1000000) } :: mkPerBtcData xs rest


mkPerBtcComp : Data -> Data -> Data
mkPerBtcComp nd amts =
    mkcompound (mkPerBtcData nd amts)


addCmd : Cmd Msg -> Model -> ( Model, Cmd Msg )
addCmd cmd model =
    ( model, cmd )


parseData : String -> (List String -> Maybe Datum) -> Result String Data
parseData s f =
    case Csv.parse s of
        Ok c ->
            Ok (List.filterMap f c.records |> List.sortBy(\d->Time.posixToMillis(d.time)))

        Err _ ->
            Err "Parsing error"


parsePowRecord : Float -> List String -> Maybe Datum
parsePowRecord f l =
    case l of
        [ ts, dat, max, min, guess ] ->
            let
                time =
                    millisToPosix (1000 * Maybe.withDefault 0 (String.toInt ts))

                amount =
                    f * Maybe.withDefault 0 (String.toFloat guess)
            in
            -- if Time.toWeekday Time.utc time == Time.Mon then
            Just { time = time, amount = amount }

        -- else Nothing
        _ ->
            Nothing



-- VIEW

calculatorRenderer: Data -> Data -> Model -> Markdown.Renderer.Renderer (Html.Html Msg)
calculatorRenderer data tbtc model =
    let
        compound = mkcompound data
        perBtcComp = mkPerBtcComp data tbtc
        s = model.startString
        e = model.endString
        sD = orLazy model.selection.start (\() -> head compound)
        eD = orLazy model.selection.end (\() -> last compound)
    in case (sD,eD) of
           (Just startDatum, Just endDatum) ->
               let perBtcAmount = co2perBtcIn perBtcComp startDatum endDatum in
               { headingRenderer |
                       html = Markdown.Html.oneOf
                       [ Markdown.Html.tag "co2graph"
                           (\children -> Html.div[Html.Attributes.style "font-size" "12px"][chart1 data model])
                       , Markdown.Html.tag "co2totalgraph"
                           (\children -> Html.div[Html.Attributes.style "font-size" "12px"][chart2 compound model])
                       , Markdown.Html.tag "inputstart"
                           (\txt children -> Html.div[][ Html.label[Html.Attributes.for "start"][Html.text txt]
                                                       , Html.input [id "start", Html.Attributes.type_ "month", value (left 7 s), onInput (ChangeStart compound) ][]])
                       |> Markdown.Html.withAttribute "text"
                       , Markdown.Html.tag "inputend"
                           (\txt children -> Html.div[][ Html.label[Html.Attributes.for "end"][Html.text txt]
                                                       , Html.input [id "end", Html.Attributes.type_ "month", value (left 7 e), onInput (ChangeEnd compound) ][]])
                           |> Markdown.Html.withAttribute "text"
                       , Markdown.Html.tag "selectionstart"
                           (\children -> Html.text (left 7 <| datumToTimeString startDatum))
                       , Markdown.Html.tag "selectionend"
                           (\children -> Html.text (left 7 <| datumToTimeString endDatum))
                       , Markdown.Html.tag "totalco2"
                           (\children -> Html.text (String.fromFloat <| round100 <| abs (endDatum.amount - startDatum.amount)))
                       , Markdown.Html.tag "perbtc"
                           (\children -> Html.text (String.fromFloat <| round100 <| perBtcAmount))
                       , Markdown.Html.tag "inputbtc"
                           (\txt children -> Html.div[][ Html.label[Html.Attributes.for "btc"][Html.text txt]
                                                       , Html.input [id "btc", Html.Attributes.type_ "number", placeholder "0.00000001", value model.btcS, onInput ChangeBtc][]])
                       |> Markdown.Html.withAttribute "text"
                       , Markdown.Html.tag "outputtons"
                           (\txt children -> case String.toFloat model.btcS of
                                       Nothing ->
                                           Html.text ""

                                       Just btc ->
                                           Html.p[][Html.text
                                            (txt
                                            ++ (String.fromFloat <| round100 <| perBtcAmount * btc)
                                            ++ " t CO2.")]
                           )
                       |> Markdown.Html.withAttribute "text"
                       , Markdown.Html.tag "outputoffset"
                           (\children -> Html.text (String.fromFloat offset))
                       , Markdown.Html.tag "offsetdate"
                           (\children -> Html.text (findOffsetDate compound))
                ]
               }

           (_,_)  -> Markdown.Renderer.defaultHtmlRenderer








-- MAIN CHARTS

localWidth model = min model.width maxWidth

chart1 : Data -> Model -> Html.Html Msg
chart1 data model =
    LineChart.viewCustom
        (chartConfig
            { y = yAxis1 (localWidth model)
            , area = Area.normal 0.5
            , range = Range.default
            , junk =
                Junk.hoverOne model.hinted
                    [ ( "date", datumToTimeString )
                    , ( "Mt/month", String.fromFloat << round100 << .amount )
                    ]
            , events = Events.hoverOne Hint
            , legends = Legends.default
            , dots = Dots.custom (Dots.full 0)
            , id = "line-chart"
            , width = localWidth model
            }
        )
        [ LineChart.line Colors.pink Dots.circle "CO2" data ]


chart2 : Data -> Model -> Html.Html Msg
chart2 compound model =
    LineChart.viewCustom
        (chartConfig
            { y = yAxis2 (localWidth model)
            , area = Area.default
            , range = Range.default
            , junk = junkConfig model
            , legends = Legends.default
            , events =
                Events.custom
                    [ Events.onWithOptions "mousedown" (Events.Options True True False) Hold Events.getNearestX
                    , Events.onWithOptions "mousemove" (Events.Options True True False) Move Events.getNearestX
                    , Events.onWithOptions "mouseup" (Events.Options True True True) Drop Events.getNearestX
                    , Events.onWithOptions "mouseleave" (Events.Options True True False) LeaveChart Events.getNearestX
                    , Events.onWithOptions "mouseleave" (Events.Options True True True) LeaveContainer Events.getNearestX
                    ]
            , dots = Dots.custom (Dots.full 0)
            , id = "line-chart"
            , width = localWidth model
            }
        )
        [ LineChart.line Colors.blue Dots.circle "CO2" compound ]


junkConfig : Model -> Junk.Config Datum msg
junkConfig model =
    Junk.custom <|
        \system ->
            { below = below system model.selection
            , above = above system model.hovered offset
            , html = []
            }


below : Coordinate.System -> Selection -> List (Svg.Svg msg)
below system selection =
    case ( selection.start, selection.end ) of
        ( Just startDatum, Just endDatum ) ->
            [ Junk.rectangle system
                [ Svg.Attributes.fill "#b6b6b61a" ]
                (datumToFloat startDatum)
                (datumToFloat endDatum)
                system.y.min
                system.y.max
            ]

        _ ->
            []


above : Coordinate.System -> Maybe Datum -> Float -> List (Svg.Svg msg)
above system maybeHovered o =
    Junk.horizontal system [] o
        :: (case maybeHovered of
                Just hovered ->
                    [ Junk.vertical system [] (datumToFloat hovered) ]

                Nothing ->
                    []
           )



-- VIEW CHART


type alias Config =
    { y : Axis.Config Datum Msg
    , range : Range.Config
    , junk : Junk.Config Datum Msg
    , events : Events.Config Datum Msg
    , legends : Legends.Config Datum Msg
    , dots : Dots.Config Datum
    , id : String
    , area : Area.Config
    , width : Int
    }


chartConfig : Config -> LineChart.Config Datum Msg
chartConfig { y, range, junk, events, legends, dots, id, area, width } =
    { y = y
    , x = xAxis range width
    , container = Container.responsive id
    , interpolation = Interpolation.monotone
    , intersection = Intersection.default
    , legends = legends
    , events = events
    , junk = junk
    , grid = Grid.default
    , area = area
    , line = Line.default
    , dots = dots
    }


yAxis1 : Int -> Axis.Config Datum Msg
yAxis1 h =
    Axis.full (h // 2) "Mt/month" .amount


yAxis2 : Int -> Axis.Config Datum Msg
yAxis2 h =
    Axis.full (h // 2) "Mt" .amount


xAxis : Range.Config -> Int -> Axis.Config Datum Msg
xAxis range w =
    Axis.custom
        { title = Title.default "date"
        , variable = Just << datumToFloat
        , pixels = w
        , range = range
        , axisLine = AxisLine.full Colors.gray
        , ticks = Ticks.time utc 7
        }



-- UTILS


datumToFloat : Datum -> Float
datumToFloat =
    toFloat << posixToMillis << .time


datumToTimeString : Datum -> String
datumToTimeString =
    String.left 10 << fromTime << .time


round100 : Float -> Float
round100 float =
    toFloat (round (float * 100)) / 100


findOffsetDate : Data -> String
findOffsetDate compound = Maybe.withDefault "2009-03-01"
    <| Maybe.map datumToTimeString
        <| find (\d -> d.amount >= offset) compound


co2perBtcIn : Data -> Datum -> Datum -> Float
co2perBtcIn l startDatum endDatum =
    let
        findAmount x =
            case find (\d -> fromTime d.time >= fromTime x.time) l of
                Nothing ->
                    0

                Just d ->
                    d.amount
    in
    abs (findAmount endDatum - findAmount startDatum)
