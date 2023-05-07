module Pages.Styles exposing (..)

import Element exposing (..)
import Element.Font as Font
import Element.Cursor as Cursor


colors : 
    { 
        black : Color
        , white : Color
        , grey : Color
        , darkGrey : Color
        , lightGrey : Color
        , blue : Color
        , darkBlue : Color
        , orange : Color
        , dimOrange : Color
        , yellow : Color
        , dimYellow : Color
        , red : Color
        , darkRed : Color
        , green : Color
        , darkGreen : Color
        , dimGreen : Color
        , lightGreen : Color
        , greenYellow : Color
        , brown : Color
        , dimBrown : Color
    }
colors = 
    { 
        black = rgb 0 0 0
        , white = rgb 1 1 1
        , grey = rgb255 193 193 193
        , darkGrey = rgb255 120 120 120
        , lightGrey = rgb255 225 225 225
        , blue = rgb255 51 153 255
        , darkBlue = rgb255 0 15 191
        , orange = rgb255 250 125 0
        , dimOrange = rgb255 255 163 70
        , yellow =  rgb255 255 255 0   
        , dimYellow = rgb255 250 250 90
        , red = rgb255 255 0 0
        , darkRed = rgb255 193 28 28
        , green = rgb255 120 255 30
        , darkGreen = rgb255 46 139 87
        , dimGreen = rgb255 158 183 147 
        , lightGreen = rgb255 152 251 152 
        , greenYellow = rgb255 173 255 47
        , brown = rgb255 102 60 28 
        , dimBrown = rgb255 210 191 172 
    }

fonts :
    {
        regularTitle : List (Element.Attribute msg)
        , fancyTitle : List (Element.Attribute msg)
        , buttonText : List (Element.Attribute msg)
        , numberText : List (Element.Attribute msg)
        , regularText : List (Element.Attribute msg)
        , fancyText : List (Element.Attribute msg)
        , descriptionText : List (Element.Attribute msg)
    }
fonts = 
    {
        regularTitle =  
        [
            Font.family [Font.typeface "Times New Roman"]
            , Font.semiBold
            , Font.center
            , Cursor.default
        ]
        , fancyTitle =  
        [
            Font.family [Font.typeface "Garamond"]
            , Font.bold
            , Font.center
            , Cursor.default
        ]
        , buttonText =  
        [
            Font.family [Font.typeface "Lucida Console"]
            , Font.medium
            , Font.center
            , Cursor.pointer
        ]
        , numberText =  
        [
            Font.family [Font.typeface "Trebuchet MS", Font.monospace]
            , Font.alignLeft
            , Font.medium
            , Cursor.default
        ] 
        , regularText =  
        [
            Font.family [ Font.typeface "Arial"]
            , Cursor.default
        ]
        , fancyText =  
        [
            Font.family [Font.typeface "Verdana"]
            , Font.medium
            , Cursor.default
        ]
        , descriptionText =  
        [
            Font.family [Font.typeface "Arial", Font.monospace]
            , Font.center
            , Font.light
            , Cursor.default
        ] 
    }

screen_background : String -> Float -> List (Element.Attribute msg)
screen_background source a = 
    [
        width (fill)
        , height (fill)
        , Element.behindContent
        (
            Element.image
            [
                width (fill)
                , height (px 745)
                , centerY
                , alpha a
            ]
            {src = source, description = "background-menu"}   
        )
    ]

menu_panel : Element msg -> Element msg
menu_panel screen = 
    Element.image
    [
        width (px 800) 
        , height (px 620) 
        , alignTop
        , centerX
        , moveDown 50
        , Element.inFront (screen)
    ] 
    {src = "/assets/ui/panel-menu.svg", description = "panel_menu"}   

hover_button : (Int, Int) -> (String, String) -> Bool -> List (Element.Attribute msg) -> Element msg
hover_button (w, h) (source, sourceHover) hover buttonAttr =
    let
        newSource = 
            if (hover) then sourceHover
            else source
    in
    Element.image 
    ( buttonAttr ++
        [
            width (px w)
            , height (px h)
            , pointer
        ]
    )
    {src = newSource, description = "hover_button-" ++ source}

link_button : (Int, Int) -> String -> (String, String) -> Bool -> List (Element.Attribute msg) -> List (Element.Attribute msg) -> Element msg
link_button (w, h) link (source, sourceHover) hover linkAttr buttonAttr =
    let
        newSource = 
            if (hover) then sourceHover
            else source
    in
    Element.link
    ( linkAttr ++ 
        [
            width (px w)
            , height (px h)
            , Cursor.pointer
        ]
    )
    {
        url = link
        , label = 
            Element.image 
            ( buttonAttr ++
            [
                width (px w)
                , height (px h)                
            ])
            {src = newSource, description = "link_button-" ++ link}
    }
   
panel_button : (Int, Int , Float) -> String -> Bool -> List (Element.Attribute msg) -> Element msg
panel_button (w, h, offset) buttonLabel hover hoverEvents = 
    let
        panelSource = ("/assets/ui/button_panel.png", "/assets/ui/button_panelH.png")
        link = String.toLower buttonLabel

        buttonAttr =          
            Element.inFront
            (
                Element.el 
                (fonts.regularTitle ++ 
                    [
                        Font.size 25
                        , centerX
                        , centerY
                        , Cursor.pointer
                    ]
                )
                (Element.text buttonLabel)
            )
            
    in
    link_button (w, h) link panelSource hover [centerY, moveLeft offset] (buttonAttr :: hoverEvents)

panel_button_home : (Int, Int) -> Bool -> List (Element.Attribute msg) -> Element msg
panel_button_home (w, h) hover hoverEvents = 
    let
        panelSource = ("/assets/ui/button_panelhome.png", "/assets/ui/button_panelhomeH.png")

        elementIcon =
            Element.inFront
            (
                Element.image
                [
                    width (px 40)
                    , height (px 40)
                    , centerY
                    , moveRight 8
                ]
                {src = "/assets/ui/icons/home.svg", description = "img_home"}
            ) 
    in
    link_button (w, h) "home" panelSource hover [centerY] (elementIcon :: hoverEvents)

panel_button_inactive : (Int, Int , Float) -> String -> Element msg
panel_button_inactive (w, h, offset) buttonLabel = 
    Element.image 
    [
        width (px w)
        , height (px h)
        , centerY
        , moveLeft offset
        , Element.inFront 
        (
            Element.el 
            ( fonts.regularTitle ++ 
                [
                    centerX
                    , centerY
                    , Font.semiBold
                    , Font.size 25
                    , Font.color colors.dimYellow
                ]
            )
            (Element.text buttonLabel)
        )
    ]
    {src = "/assets/ui/button_panelS.png", description = "button_selected"}
