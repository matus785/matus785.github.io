module Pages.Info exposing (..)

import Html exposing (..)
import Element exposing (..)
import Element.Font as Font
import Element.Events as Events
import Element.Background as Background
import Element.Cursor as Cursor
import Element.Border as Border

import Pages.Styles as Style exposing (..)


type alias Model = { 
        buttonHoverID : Int
    }

type Msg = 
    ButtonOver Int

initModel : Model
initModel = {buttonHoverID = 0}

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

back_button : Int -> Model -> Element Msg
back_button id model = 
    let
        buttonSource = ("/assets/ui/button_level.png", "/assets/ui/button_levelH.png")

        buttonIcon = 
            Element.inFront
            (
                Element.image 
                [
                    width (px 40)
                    , height (px 40)
                    , centerX
                    , centerY
                ]
                {src= "/assets/ui/icons/back_arrow.svg", description = "button-arrow"}
            )
    in
    Style.link_button (60, 60) "home" buttonSource (model.buttonHoverID == id) [] (buttonIcon :: (hover_events id))

label_text : String -> String -> Element Msg
label_text label labelText = 
    Element.row
    [
        width fill
        , paddingXY 20 0
        , spacing 15
    ]
    [
        Element.el
        ( fonts.fancyTitle ++
            [
                Font.size 20
                , Font.alignLeft
            ]   
        )
        (Element.text label)
        , Element.el
        ( fonts.regularText ++
            [
                Font.size 18
                , Font.alignLeft
                , Font.color colors.dimYellow
            ]   
        )
        (Element.text labelText)
    ]

link_text : String -> String -> Element msg
link_text link linkText =
    Element.link [alignLeft]
    {
        url = link
        , label = 
            Element.el  
            ( fonts.regularText ++ 
                [
                    Font.color colors.blue
                    , Font.underline
                    , Font.size 16
                    , Cursor.pointer
                ]
            )
            (Element.text linkText)
    }

view : Model -> Html Msg
view model = 
    Element.layout (Style.screen_background "/assets/ui/background-home.svg" 0.45)
    (
        Element.image 
        [
            width (px 650)
            , centerX
            , centerY
            -- screen panel
            , Element.inFront
            (
                Element.column
                [
                    width fill
                    , height fill
                    , padding 15
                    , spacing 10
                ]
                [
                    Element.row
                    [
                        width fill
                        , height (px 90)
                        , spacing 50
                        , paddingXY 20 10
                    ]
                    [
                        back_button 1 model
                        -- elm text and icon
                        , Element.paragraph 
                        ( fonts.regularTitle ++
                            [
                                width (px 200)
                                , centerX
                                , Font.size 24
                                , Font.alignLeft
                                , Element.onRight
                                (
                                    Element.link
                                    [
                                        width (px 45)
                                        , moveRight 15
                                        , centerY
                                    ]
                                    {
                                        url =" https://elm-lang.org/"
                                        , label = 
                                            Element.image
                                            [
                                                width fill
                                                , height fill
                                            ]
                                            {src = "/assets/ui/elm_logo.svg", description = "elm_logo"}
                                    }
                                )
                            ]
                        )
                        [Element.text "This project was created using Elm"]             
                    ]
                    -- labels and names 
                    , Element.column
                    [
                        width fill
                        , paddingEach {top = 20, right = 15, bottom = 10, left = 15}
                        , spacing 10
                    ]
                    [
                        label_text "GAME MADE BY:" "Matúš Srnec"
                        , label_text "PROJECT SUPERVISOR:" "Ing. Ivan Kapustík"
                        , Element.paragraph
                        ( fonts.fancyText ++ 
                            [
                                width fill
                                , Font.size 14
                                , paddingXY 30 5
                            ]
                        )
                        [Element.text "This game was created to showcase implementation of a single page application in Elm programming language. It is a part of Bachelor’s thesis written while studying at Slovak University of Technology in Bratislava."]
                    ]
                    -- game assets links
                    , Element.column
                    [
                        width fill
                        , height fill
                        , paddingXY 20 10
                        , spacing 5
                    ]
                    [
                        Element.el 
                        ( fonts.fancyTitle ++
                            [
                                Font.size 24
                                , Font.alignLeft
                                , Font.extraBold
                                , paddingXY 5 2
                            ]   
                        )
                        (Element.text "Assets:")
                        , Element.column
                        [
                            width fill
                            , height (px 165)
                            , paddingXY 10 5
                            , spacing 10
                            , Element.behindContent
                            (
                                Element.el
                                [
                                    width fill
                                    , height fill
                                    , Background.color colors.white
                                    , Border.width 2
                                    , Border.rounded 10
                                    , alpha 0.7
                                ]
                                (Element.none)
                            )
                        ]
                        [
                            link_text "https://www.kenney.nl/" "Textures for tiles, towers, enemies and projectiles - By Kenny"
                            , link_text "https://www.freepik.com/free-vector/complete-set-level-button-game-pop-up-icon-window-elements-creating-medieval-rpg-video-games_13744748.htm" "UI elements used for buttons and windows"
                            , link_text "https://www.vecteezy.com/vector-art/120525-vectors-of-screw-nut-and-bolt" "Additional decorative UI elements"
                            , link_text "https://www.vecteezy.com/vector-art/552420-cartoon-army-tank-machine-with-big-cannon-ready-to-fire-vector-illustration" "Tank icon"
                            , link_text "https://www.freepik.com/free-vector/military-transport-concept_9585760.htm" "Menu background"
                            , link_text " https://www.vecteezy.com/vector-art/7581694-art-of-jungle-camouflage-stripes-pattern-military-background-ready-for-your-desig" "Game background"
                        ]
                        -- code contributions links
                        , Element.el 
                        ( fonts.fancyTitle ++
                            [
                                Font.size 24
                                , Font.alignLeft
                                , Font.extraBold
                                , paddingXY 5 2
                            ]   
                        )
                        (Element.text "Code contributions: ")
                        , Element.column
                        [
                            width fill
                            , height (px 30)
                            , paddingXY 10 5
                            , spacing 10
                            , Element.behindContent
                            (
                                Element.el
                                [
                                    width fill
                                    , height fill
                                    , Background.color colors.white
                                    , Border.width 2
                                    , Border.rounded 10
                                    , alpha 0.7
                                ]
                                (Element.none)
                            )
                        ]
                        [
                            link_text "https://github.com/ArthurGerbelot/rect-collide" "Rotated rectangles collision"
                        ]

                    ]
                ]
            )
        ]
        {src = "/assets/ui/panel_info.svg", description = "panel_info"}
    )
