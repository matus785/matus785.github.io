module Game.Tiles exposing (..)

import Element exposing (..)
import Game.TwoD.Render as Render exposing (Renderable)
import Game.Resources as Resources exposing (Resources)

groundLayer : Float
groundLayer = -0.99

obstacleLayer : Float
obstacleLayer = -0.98


type alias Obstacle = {
    texture : String
    , posXY : (Float, Float)
    , rotation : Float
    , size : Float
    , clearCost : Int
    }
    
type Tile_type = 
    Road
    | Lot (Maybe Obstacle)

type alias Tile = {
    class : Tile_type
    , texture : String
    , posXY : (Float, Float)
    }

create_tile : (Int, Int) -> Tile_type -> Int -> ((Float, Float), Tile)
create_tile pos t index = 
    let
        newPos = Tuple.mapBoth toFloat toFloat pos
    in
    (newPos, 
    {
        class = t
        , texture = "/assets/tiles/tile-" ++ String.fromInt index ++ ".png"
        , posXY = newPos
    })

create_obstacle : String -> Float -> Float -> (Float, Float) -> Maybe Obstacle
create_obstacle obj newSize rot offset = 
    let
        maxOffset = (1 - newSize) * 0.4
    in
    Just 
    {
        texture = "/assets/objects/" ++ obj ++ ".png"
        , posXY = Tuple.mapBoth (clamp -maxOffset maxOffset) (clamp -maxOffset maxOffset) offset
        , size = clamp 0.5 0.9 newSize 
        , rotation = rot * (pi / 180)
        , clearCost = 0
    }

-- place_obstacle => set clear cost of obstacle and transforms posXY from offsetXY to position on map of obstacle
place_obstacle : Tile -> Float -> Tile
place_obstacle tile mult = 
    case tile.class of
        Lot obs -> 
            case obs of
                -- tile has obstacle
                Just o -> 
                    let
                        newX = (Tuple.first tile.posXY) + 0.5 + (Tuple.first o.posXY)
                        newY = (Tuple.second tile.posXY) + 0.5 + (Tuple.second o.posXY)

                        baseCost = 
                            case o.texture of
                                "/assets/objects/tree.png" -> 20
                                "/assets/objects/tree-round.png" -> 25
                                "/assets/objects/tree-star.png" -> 15
                                "/assets/objects/bush.png" -> 15
                                "/assets/objects/bush-many.png" -> 10
                                "/assets/objects/rock-1.png" -> 20
                                "/assets/objects/rock-2.png" -> 25
                                "/assets/objects/rock-3.png" -> 30
                                "/assets/objects/rock-4.png" -> 25
                                "/assets/objects/rock-5.png" -> 30
                                "/assets/objects/rock-6.png" -> 35
                                _ -> 0

                        newObstacle = 
                            { o | 
                                clearCost = round <| (baseCost + (baseCost * o.size)) * mult
                                , posXY = (newX, newY)
                            }
                    in
                    {tile | class = Lot (Just newObstacle)} 

                Nothing -> tile
        _ -> tile
     
get_tile_name : Tile -> String
get_tile_name tile = 
    case tile.class of
        Lot _ -> "Plot"
        Road -> "Road"

get_tile_clear_cost : Tile -> Int
get_tile_clear_cost tile = 
    case tile.class of
        Lot obs -> 
            case obs of
                Just o -> o.clearCost
                _ -> 0
        _ -> 0

has_obstacle : Tile -> Bool
has_obstacle tile =
    case tile.class of 
        Lot obs -> 
            case obs of
                Nothing -> False
                _ -> True
        _ -> False

------------------------------------------------
-- Rendering
------------------------------------------------

render_all_tiles : List Tile -> (Float, Float)-> Resources -> List Renderable
render_all_tiles tiles flagPos res =
    List.map (\o -> render_ground o res) tiles 
    ++ List.filterMap identity (List.map (\o -> render_obstacle o res) tiles) 
    ++ [render_flag flagPos res]

render_ground : Tile -> Resources -> Renderable
render_ground tile res =  
   Render.spriteWithOptions 
   {
        position = (Tuple.first tile.posXY, Tuple.second tile.posXY, groundLayer)
        , size = (1, 1)
        , texture = Resources.getTexture tile.texture res
        , rotation = 0
        , pivot = (0, 0)
        , tiling = (1, 1)
    }

render_obstacle : Tile -> Resources -> Maybe Renderable
render_obstacle tile res = 
    case tile.class of
        Lot obs ->
            case obs of 
                -- tile has obstacle
                Just o ->
                    Just (Render.spriteWithOptions 
                    {
                        position = (Tuple.first o.posXY, Tuple.second o.posXY, obstacleLayer)
                        , size = (o.size, o.size)
                        , texture = Resources.getTexture o.texture res
                        , rotation = negate (o.rotation)
                        , pivot = (0.5, 0.5)
                        , tiling = (1, 1)
                    })

                _ -> Nothing
        _ -> Nothing

render_flag : (Float, Float) -> Resources -> Renderable
render_flag (x, y) res = 
    Render.spriteWithOptions 
    {
        position = (x, y, obstacleLayer)
        , size = (0.8, 0.8)
        , texture = Resources.getTexture "/assets/ui/map/road-flag.png" res
        , rotation = 0
        , pivot = (0, 0)
        , tiling = (1, 1)
    }
    
preview_tile : Tile -> Int -> Element msg
preview_tile tile tileSize =
    Element.image 
    [
        Element.height (px tileSize)
        , Element.width (px tileSize)

        -- render obstacle
        , case tile.class of
            Lot obs ->
                case obs of 
                    Just o ->
                        let
                            -- get X,Y offset from obstacle position
                            offsetX = (Tuple.first o.posXY) - 0.5 - (Tuple.first tile.posXY)
                            offsetY = (Tuple.second o.posXY) - 0.5 - (Tuple.second tile.posXY)
                        in
                        Element.inFront
                        (
                            Element.image
                            [
                                Element.height (px tileSize) 
                                , Element.width (px tileSize)
                                , scale o.size
                                , rotate o.rotation
                                , moveUp (offsetY * toFloat tileSize)
                                , moveRight (offsetX * toFloat tileSize) 
                            ]
                            {src = o.texture, description = "tile"}
                        )
        
                    Nothing -> Element.inFront (Element.none)

            _ -> Element.inFront (Element.none)
    ] 
    {src = tile.texture, description = "tile"}
