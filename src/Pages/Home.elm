module Pages.Home exposing (..)

import Html exposing (..)
import Element exposing (..)
import Element.Font as Font
import Element.Events as Events

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

menu_button : (Int, Int) -> String -> String -> Model -> Int -> Element Msg
menu_button (w, h) link label model id = 
    let
        buttonSource = ("/assets/ui/button_blue.png", "/assets/ui/button_blueH.png")

        buttonText = 
            Element.inFront
            (
                Element.el 
                ( fonts.buttonText ++ 
                    [
                        Font.size 20
                        , centerX
                        , centerY
                    ]
                )
                (Element.text label)
            )
    in
    Style.link_button (w, h) link buttonSource (model.buttonHoverID == id) [] (buttonText :: (hover_events id))

view : Model -> Html Msg
view model = 
    Element.layout (Style.screen_background "/assets/ui/background-home.svg" 0.8)
    (
        -- screen panel
        Element.image
        [
            height (px 300) 
            , width (px 500)
            , alignTop
            , alignLeft
            , moveDown 400
            , moveRight 50
            , Element.inFront
            (
                Element.column
                [
                    height fill
                    , width (px 350)
                    , centerX
                    , paddingXY 15 10
                    , moveDown 15
                    , spacing 20
                ] 
                [
                    Element.row 
                    [
                       width fill
                        , centerX
                        , paddingXY 10 15
                        , moveDown 10 
                        , spacing 25
                    ]
                    [
                        -- game name
                        Element.column []
                        [
                            Element.el 
                            ( fonts.regularTitle ++
                                [
                                    Font.size 34
                                    , Font.color colors.darkBlue
                                ] 
                            ) 
                            (Element.text "Brutal Bulkwar")

                            , Element.el (fonts.regularTitle ++ [Font.size 20]) (Element.text "Tower Defense game")
                        ] 
                        -- tank icon
                        , Element.image 
                        [
                            alignRight
                            , Element.height (Element.px 75) 
                        ] 
                        {src = "/assets/ui/image-tank.svg", description = "tank"}
                    ]
                    -- panel buttons
                    , Element.row 
                    [
                        width fill
                        , centerX
                        , paddingXY 10 0
                        , spaceEvenly
                    ]
                    [   
                        menu_button (160, 60) "levels" "PLAY GAME" model 1
                        , menu_button (100, 60) "info" "INFO" model 2
                    ]    
                ]            
            )
        ]
        {src = "/assets/ui/panel-home.svg", description = "panel"}  
    )
