module Pages.ScoreBoard exposing (..)

import Html exposing (..)
import Element exposing (..)
import Element.Font as Font
import Element.Border as Border
import Element.Events as Events
import Array exposing (..)

import Pages.Styles as Style exposing (..)
import SharedState exposing (SharedState, SharedStateUpdate(..))
import User exposing (..)

type alias Model = { 
        buttonHoverID : Int
        , currentScore : Array Score
    }

type Msg = 
    ButtonOver Int

initModel : SharedState -> Model
initModel state = 
    let
        difference = User.maxMapNumber - (Array.length state.player.levelScore)

        newScore = 
            if (difference > 0) then Array.append state.player.levelScore (Array.repeat difference User.emptyScore)
            else state.player.levelScore

    in
    {buttonHoverID = 0, currentScore = newScore}

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        ButtonOver id -> ({model | buttonHoverID = id}, Cmd.none)

------------------------------------------------
-- View
------------------------------------------------

hover_events : Int -> List (Element.Attribute Msg)
hover_events id = 
    [
        Events.onMouseEnter (ButtonOver id)
        , Events.onMouseLeave (ButtonOver 0)
    ]

icon_text : (Int, Int) -> String -> String -> Bool -> Element Msg
icon_text (w, h) label iconName last = 
    Element.row
    [
        width (px w)
        , height (px h)
        , alignLeft
        , if last then spacing 8
        else spacing 15
        , if last then Border.width 0
        else Border.widthEach {bottom = 0, left = 0, right = 2, top = 0}
    ]
    [
        Element.image 
        [
            height (px (h // 2))
            , alignLeft
            , centerY
            , centerX
        ]
        {src = "/assets/ui/icons/" ++ iconName ++ ".svg", description = "icon_" ++ iconName}
        , Element.el
        ( fonts.descriptionText ++ 
            [
                Font.size 22
                , Font.semiBold
                , Font.center
                , centerX
            ]
        )
        (Element.text label)
    ]

top_row : Element Msg
top_row = 
    Element.row 
    [
        width fill
        , height (px 80)  
        , alignTop  
        , moveDown 43
        , paddingXY 58 0
    ]
    [
        Element.el
        ( fonts.descriptionText ++ 
            [
                height fill
                , width (px 123)
                , Font.size 22
                , Font.semiBold
                , alignLeft
                , paddingXY 0 15
                , Border.widthEach {bottom = 0, left = 0, right = 2, top = 0}
            ]
        )
        (Element.text ("Level\nNumber"))
        , icon_text (177, 80) "Highest\nlives" "lives" False
        , icon_text (283, 80) "Best Finish\nTime" "clock" True
    ]

level_row : Score -> Int ->  Element Msg
level_row score rowNumber = 
    let
        isEven = (modBy 2 rowNumber) == 0

        imageSource = 
            if isEven then "/assets/ui/row_even.svg"
            else "/assets/ui/row.svg"

        livesGlow = Font.glow colors.white 2

        (lives, time) = get_score score
    in
    Element.row 
    [
        width fill
        , height (px 60)
        , Element.behindContent
        (
            Element.image
            [
                width fill
                , height fill
            ]
            {src = imageSource, description = "row-" ++ String.fromInt rowNumber}
        )
    ]
    [
        Element.el
        ( fonts.fancyTitle ++ 
            [
                height fill
                , width (px 120)
                , Font.size 30
                , Font.extraBold
                , Font.alignLeft
                , paddingXY 40 15
            ]
        )
        (Element.text (String.fromInt rowNumber ++ "."))
        ,  Element.el
        ( fonts.numberText ++ 
            [
                height fill
                , width (px 180)
                , Font.size 25
                , Font.bold
                , Font.center
                , livesGlow
                , paddingXY 0 17
            ]
        )
        (Element.text lives)
        ,  Element.el
        ( fonts.numberText ++ 
            [
                height fill
                , width fill
                , Font.size 25
                , Font.bold
                , Font.center
                , livesGlow
                , paddingXY 0 17
            ]
        )
        (Element.text time)
    ]

view: Model -> Html Msg
view model = 
    let
        -- create list of rows
        (rows, rowNumber) = Array.foldr
            (\o (listR, num) -> 
                let
                    newNum = num - 1
                    newRow = level_row o num
                in
                ((newRow :: listR), newNum)
            ) 
            ([], User.maxMapNumber) model.currentScore
    in
    Element.layout (Style.screen_background "/assets/ui/background-menu.svg" 0.5)
    (
        Style.menu_panel 
        (
            Element.column
            [
                width fill
                , height fill
                , paddingXY 42 44
            ]
            [
                -- top panel
                Element.row
                [
                    width fill
                    , height (px 72)
                    , paddingXY 5 0
                ]
                [
                    Style.panel_button_home (75, 60) (model.buttonHoverID == 1) (hover_events 1)
                    , Style.panel_button (150, 60, 5) "Levels" (model.buttonHoverID == 2) (hover_events 2)
                    , Style.panel_button_inactive (150, 60, 10) "Score"
                    , Style.panel_button (150, 60, 15) "Guide" (model.buttonHoverID == 3) (hover_events 3) 
                    , Style.panel_button (150, 60, 20) "Settings" (model.buttonHoverID == 4) (hover_events 4) 
                ]
                -- score rows
                , top_row
                , Element.column
                [
                    width (px 600)
                    , height (px 295)
                    , centerX
                    , alignTop
                    , scrollbarY
                    , spacing -1
                ]
                (rows)
            ]
        )
    )
