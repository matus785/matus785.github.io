module Pages.LevelPreview exposing (..)

import Html exposing (..)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Border as Border
import Element.Events as Events
import Element.Cursor as Cursor
import Array exposing (..)

import Pages.Styles as Style exposing (..)
import SharedState exposing (SharedState)
import Game.Playboard exposing (create_board, draw_board)
import User exposing (Score, get_unlocked_level, get_medal)

-- width, height of map preview
previewWH : Int
previewWH = 280

type alias Model = { 
        currentLevel : Maybe Int
        , maxLevel : Int
        , levelScore : Array Score
        , buttonHoverID : Int
    }

initModel : SharedState -> Model
initModel state = {
    currentLevel = Nothing
    , maxLevel = get_unlocked_level state.player
    , levelScore = state.player.levelScore
    , buttonHoverID = 0
    }

type Msg = 
    ButtonOver Int
    | NewLevel (Maybe Int)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of 
        ButtonOver id -> ({model | buttonHoverID = id}, Cmd.none)

        NewLevel lvl -> 
            ({model | currentLevel = lvl}, Cmd.none)

------------------------------------------------
-- View
------------------------------------------------

hover_events : Int -> List (Element.Attribute Msg)
hover_events id = 
    [
        Events.onMouseEnter (ButtonOver id)
        , Events.onMouseLeave (ButtonOver 0)
    ]
    
level_button : (Int, Int) -> Int -> Int -> Model -> Int -> Element Msg
level_button (w, h) lvl currentLevel model id = 
    let
        levelText = 
            Element.inFront
            (
                Element.el 
                ( 
                    fonts.buttonText ++ 
                    [
                        centerX
                        , centerY
                        , Font.size 25
                        , if (model.maxLevel < lvl) then Cursor.default
                        else Cursor.pointer
                    ]
                )
                (Element.text (String.fromInt lvl))
            )
            
    in
    -- level locked
    if (model.maxLevel < lvl) then
        Element.image 
        [
                width (px w)
                , height (px h)
                , levelText
        ]
        {src = "/assets/ui/button_levelL.png", description = "button" ++ String.fromInt id}

    -- level selected
    else if (currentLevel == lvl) then
        Element.image 
        [
            width (px w)
            , height (px h)
            , pointer 
            , Events.onClick (NewLevel Nothing)
            , levelText
        ]
        
        {src = "/assets/ui/button_levelS.png", description = "button" ++  String.fromInt id}

    -- level unlocked
    else 
        let
            buttonSource = ("/assets/ui/button_level.png", "/assets/ui/button_levelH.png")
            buttonAttr = [levelText, Events.onClick (NewLevel (Just lvl))] ++ (hover_events id)
        in
        Style.hover_button (w, h) buttonSource (model.buttonHoverID == id) buttonAttr
    
preview_level : (Int, Int) -> SharedState -> Model -> Int -> Element Msg
preview_level (w, h) state model id = 
    case model.currentLevel  of
        -- NO level selected
        Nothing ->
            Element.el
            (   
                [
                    width (Element.px (w + 4))
                    , height (Element.px (h + 4)) 
                    , centerX
                    , centerY
                    , Background.color colors.grey
                    , Border.dashed
                    , Border.width 2
                ] 
            )
            (
                Element.column
                [
                    width fill
                    , height fill
                    , alpha 0.6
                ]
                [
                    -- image and text for NO level
                    Element.image
                    [
                        width (px (w - 50))
                        , height (px (h - 50))
                        , centerX 
                        , alignTop
                    ]
                    {src = "/assets/ui/background_unknown.svg", description = "level_placeholder"} 

                    , Element.el
                    (
                        fonts.fancyText ++ 
                        [ 
                            centerX
                            , alignBottom
                            , moveUp 30                         
                            , Font.size 20
                        ]
                    )
                    (Element.text ("No level selected")) 
                ]
            )
        -- level selected
        Just lvl -> 
            let
                newBoard = (create_board lvl w h 0)
                newH = (Tuple.first newBoard.rowCol) * newBoard.tileSize
                newW = (Tuple.second newBoard.rowCol) * newBoard.tileSize

                buttonSource = ("/assets/ui/button_brown.png", "/assets/ui/button_brownH.png")

                buttonAttr = 
                    ( 
                        Element.inFront
                        (
                            Element.el 
                            ( fonts.buttonText ++ 
                                [
                                    centerX
                                    , centerY
                                    , Font.size 18
                                    , Font.bold
                                ]
                            )
                            (Element.text "START")
                        ) :: (hover_events id)
                    )

                link = "game#" ++ String.fromInt lvl

                medalImage = 
                    case (get_medal model.levelScore lvl) of
                        Nothing -> Element.none
                        Just m ->
                            Element.image
                            [
                                width (px 30)
                                , height (px 60)
                                , alignTop
                                , alignLeft
                                , moveDown 10
                                , moveRight 5
                            ]
                            {src = m, description = "medal_image"}
            in
            Element.column
            [
                width fill
                , height fill
                , spacing 20
                , centerX
                , centerY
            ]
            [
                -- level map preview
                Element.el
                (   
                    [
                        width (Element.px (newW + 4))
                        , height (Element.px (newH + 4)) 
                        , centerX
                        , centerY
                        , Background.color colors.dimGreen
                        , Border.dashed
                        , Border.width 2
                        , pointer
                    ] 
                )
                (
                    Element.link
                    [
                        width fill
                        , height fill
                        , alpha 0.8
                        , Element.inFront medalImage

                    ]
                    {
                        url = link
                        , label = 
                            Element.el
                            [
                                width fill
                                , height fill
                                -- level number
                                , Element.inFront
                                (
                                    Element.el
                                    (
                                        fonts.fancyText ++ 
                                        [ 
                                            centerX
                                            , alignBottom
                                            , moveUp 30                         
                                            , Font.size 20
                                        ]
                                    )
                                    (Element.text ("Level " ++ String.fromInt lvl)) 
                                )
                            ]
                            (Element.html (draw_board newBoard state.resources False))
                    }
                )
                -- start button
                , Style.link_button (100, 40) link buttonSource (model.buttonHoverID == id) [centerX, centerY] buttonAttr   
            ]
           
view : SharedState -> Model -> Html Msg
view state model = 
    let
        selectedlevel = Maybe.withDefault 0 model.currentLevel
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
                    Style.panel_button_home (75, 60)  (model.buttonHoverID == 1) (hover_events 1) 
                    , Style.panel_button_inactive (150, 60, 5) "Levels"
                    , Style.panel_button (150, 60, 10) "Score"  (model.buttonHoverID == 2) (hover_events 2)
                    , Style.panel_button (150, 60, 15) "Guide" (model.buttonHoverID == 3) (hover_events 3)
                    , Style.panel_button (150, 60, 20) "Settings" (model.buttonHoverID == 4) (hover_events 4)
                ]
                -- level selector
                , Element.row
                [
                    width fill
                    , height (px 460)
                    , paddingXY 30 40
                ]
                [
                    preview_level (previewWH, previewWH) state model 5
                    , Element.column
                    [
                        width (Element.px 300)
                        , height (Element.px 400) 
                        , centerY
                        , paddingXY 20 20
                        , spacing 30
                    ]
                    [
                        -- choose level text
                        Element.el
                        ( fonts.fancyTitle ++
                            [ 
                                width fill
                                , paddingXY 0 8
                                , Font.size 30
                                , Font.color colors.black
                                , Border.solid
                                , Border.widthEach {bottom = 1, left = 0, right = 0, top = 0}
                            ]
                        )
                        (Element.text ("Choose a level"))
                        -- level buttons
                        , Element.row 
                        [
                            width fill
                            , moveDown 20
                            , paddingXY 10 0
                            , spaceEvenly
                        ]
                        [
                            level_button (50, 50) 1 selectedlevel model 6
                            , level_button (50, 50) 2 selectedlevel model 7
                            , level_button (50, 50) 3 selectedlevel model 8
                        ]
                        , Element.row 
                        [
                            width fill
                            , moveDown 20
                            , paddingXY 10 0
                            , spaceEvenly
                        ]
                        [
                            level_button (50, 50) 4 selectedlevel model 9
                            , level_button (50, 50) 5 selectedlevel model 10
                            , level_button (50, 50) 6 selectedlevel model 11
                        ]
                        , Element.row 
                        [
                            width fill
                            , moveDown 20
                            , paddingXY 10 0
                            , spaceEvenly
                        ]
                        [
                            level_button (50, 50) 7 selectedlevel model 12
                            , level_button (50, 50) 8 selectedlevel model 13
                            , level_button (50, 50) 9 selectedlevel model 14
                        ]
                    ]
                ]
            ]
        )     
    )
    