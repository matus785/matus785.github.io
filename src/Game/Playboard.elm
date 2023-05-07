module Game.Playboard exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Dict exposing (..)
import Array exposing (..) 
import Game.TwoD as GameTD
import Game.TwoD.Camera as Camera exposing (Camera, viewportToGameCoordinates)
import Game.TwoD.Render exposing (..)
import Game.Resources exposing (Resources)

import Game.Calculations exposing (..)
import Game.Tiles exposing (..)
import Game.Towers as Towers exposing (..)
import Game.Enemies exposing (..)
import Game.Projectiles as Projectiles exposing (..)
-- Game Maps
import Game.Maps.Map1 as Map1 exposing (..)
import Game.Maps.Map2 as Map2 exposing (..)
import Game.Maps.Map3 as Map3 exposing (..)
import Game.Maps.Map4 as Map4 exposing (..)
import Game.Maps.Map5 as Map5 exposing (..)
import Game.Maps.Map6 as Map6 exposing (..)
import Game.Maps.Map7 as Map7 exposing (..)
import Game.Maps.Map8 as Map8 exposing (..)
import Game.Maps.Map9 as Map9 exposing (..)

-- enemy layer
-- maximum 949 enemies on map at the same time
enemyLayerInitial : Float
enemyLayerInitial = 0

enemyLayerMinimal : Float 
enemyLayerMinimal = -0.95

enemyLayerDifference : Float
enemyLayerDifference = 0.001

-- projectile layer
-- maximum 999 projectiles on map at the same time
projectileLayerInitial : Float
projectileLayerInitial = 1

projectileLayerMinimal : Float 
projectileLayerMinimal = 0

projectileLayerDifference : Float
projectileLayerDifference = 0.001


type alias Board = {
    camera : Camera
    , tileSize : Int
    , rowCol : (Int, Int)
    , grid : Dict (Float, Float) Tile   
    , path : Array Point                -- points creating the road for Ground enemies
    , airport : Maybe Point             -- spawn point for Flying enemies
    , allTowers : List Tower            
    , allEnemies : List Enemy           
    , enemyLayer : Float
    , allProjectiles : List Projectile
    , projectileLayer : Float 
    , flagPos : (Float, Float)          -- flag position (for rendering)
    }

create_board : Int -> Int -> Int -> Float -> Board
create_board lvl width height mult =
    let 
        newGrid = 
            let
                tileList = 
                    case lvl of
                        1 -> Map1.tileList
                        2 -> Map2.tileList
                        3 -> Map3.tileList
                        4 -> Map4.tileList
                        5 -> Map5.tileList
                        6 -> Map6.tileList
                        7 -> Map7.tileList
                        8 -> Map8.tileList
                        9 -> Map9.tileList
                        _ -> []
            in
            Dict.fromList <| List.map 
                (\o -> 
                    let
                        pos = Tuple.first o
                        newTile = place_obstacle (Tuple.second o) mult
                    in
                    (pos, newTile)
                ) 
                tileList

        newRowCol = 
            case lvl of
                1 -> (Map1.mapHeight, Map1.mapWidth)
                2 -> (Map2.mapHeight, Map2.mapWidth)
                3 -> (Map3.mapHeight, Map3.mapWidth)
                4 -> (Map4.mapHeight, Map4.mapWidth)
                5 -> (Map5.mapHeight, Map5.mapWidth)
                6 -> (Map6.mapHeight, Map6.mapWidth)
                7 -> (Map7.mapHeight, Map7.mapWidth)
                8 -> (Map8.mapHeight, Map8.mapWidth)
                9 -> (Map9.mapHeight, Map9.mapWidth)
                _ -> (0, 0)

        newPath = 
            let
                pathList = 
                    case lvl of 
                        1 -> Map1.path
                        2 -> Map2.path
                        3 -> Map3.path
                        4 -> Map4.path
                        5 -> Map5.path
                        6 -> Map6.path
                        7 -> Map7.path
                        8 -> Map8.path
                        9 -> Map9.path
                        _ -> []
            in
            Array.fromList pathList

        newAirport = 
            case lvl of
                1 -> Map1.airport
                2 -> Map2.airport
                3 -> Map3.airport
                4 -> Map4.airport
                5 -> Map5.airport
                6 -> Map6.airport
                7 -> Map7.airport
                8 -> Map8.airport
                9 -> Map9.airport
                _ -> Nothing

        newSize = 
            if (width // (Tuple.first newRowCol) < height // (Tuple.second newRowCol)) then width // (Tuple.first newRowCol)
            else height // (Tuple.second newRowCol)
    in 
    { 
        camera = Camera.fixedArea (toFloat (Tuple.second newRowCol) * toFloat (Tuple.first newRowCol)) (toFloat (Tuple.second newRowCol) / 2, toFloat (Tuple.first newRowCol) / 2)
        , tileSize = newSize
        , rowCol = newRowCol
        , grid = newGrid
        , path = newPath
        , airport = newAirport
        , allTowers = []
        , allEnemies = []
        , allProjectiles = []
        , enemyLayer = enemyLayerInitial
        , projectileLayer = projectileLayerInitial
        , flagPos = get_previous_point (Array.get ((Array.length newPath) - 1) newPath) 
    }

get_row : Board -> Int
get_row b =
   Tuple.first b.rowCol

get_col : Board -> Int
get_col b =
    Tuple.second b.rowCol

-- map_coordinates => transforms XY on screen to XY coordinates on map
map_coordinates : Board -> (Float, Float) -> (Float, Float)
map_coordinates b x_y = 
    let 
        pos = Tuple.mapBoth floor floor x_y 
        index = viewportToGameCoordinates b.camera (get_col b * b.tileSize, get_row b * b.tileSize) pos
        newpos = Tuple.mapBoth floor floor index
    in
    Tuple.mapBoth toFloat toFloat newpos

clear_board : Board -> Board
clear_board board = 
    let
        newTowers = List.map (\o -> set_cooldown {o | rotation = 0, lastShot = 0} 0) board.allTowers
    in
    {board | allTowers = newTowers, allProjectiles = []}

draw_board : Board -> Resources ->  Bool -> Html msg
draw_board b res showHPbar = 
    let
        allEntities = 
            (render_all_tiles (Dict.values b.grid) b.flagPos res) 
            ++ (render_all_towers b.allTowers res) 
            ++ (render_all_enemies b.allEnemies showHPbar res)
            ++ (render_all_projectiles b.allProjectiles res)
    in
    div [Html.Attributes.id "playboard"] 
    [
        GameTD.renderWithOptions [] 
        {time = 0, camera = b.camera, size =  (b.tileSize * get_col b , b.tileSize * get_row b)} 
        allEntities
    ] 

-- move_entities => moves every enemy, tower, projectile on map
-- this function is called every tick and handles all interactions between every moving entity currently on map
move_entities : Board -> Float -> (Int, Int, Board)
move_entities board dt =
    let
        -- collide enemies and projectiles
        (newEnemies, newProjectiles) = collide_objects board.allEnemies board.allProjectiles

        -- filter dead enemies
        (deadEnemies, aliveEnemies) = List.partition (\o -> o.health <= 0) newEnemies

        -- move enemies on map and filter enemies out of map
        (escapedEnemies, movedEnemies) = List.partition (\o-> out_of_map o.posXY board.rowCol) (List.map (\o-> move_enemy o board.path dt) aliveEnemies)

        -- move and filter projectiles on map
        movedProjectiles = List.filterMap identity (List.map (\o-> move_projectile o board.rowCol dt) newProjectiles)

        -- get number of lost lives and earned money
        livesLost = List.foldl (\o sum -> sum + o.lives) 0 escapedEnemies
        moneyEarned = List.foldl (\o sum -> sum + o.reward) 0 deadEnemies
        
        -- rotate towers and shoot projectiles
        (movedTowers, spawnedProjectiles) = List.unzip (List.map (\o -> aim_tower o movedEnemies dt) board.allTowers)

        -- assign each new projectile unique index and filter non-existing projectiles
        newBoard = place_projectiles board spawnedProjectiles 
    in
    (livesLost, moneyEarned, 
    {newBoard 
        | allEnemies = movedEnemies
        , allTowers = movedTowers
        , allProjectiles = movedProjectiles ++ newBoard.allProjectiles
    })

------------------------------------------------
-- Tiles
------------------------------------------------

-- tile_is_clear => returns TRUE if tile does NOT have an obstacle or a tower, otherwise FALSE
tile_is_clear : Board -> (Float, Float) -> Bool
tile_is_clear board pos = 
    let
        tower = get_tower board pos
        tile = Dict.get pos board.grid
    in
    case tile of 
        -- tile found
        Just t -> 
            case t.class of
                Lot _ ->
                    if (has_obstacle t) then False 
                    else 
                        case tower of
                            Nothing -> True
                            _ -> False
                _ -> False
        -- ERROR
        Nothing -> False

------------------------------------------------
-- Towers
------------------------------------------------

tower_is_placed : Board -> Tower -> Bool
tower_is_placed board tower = 
    if (tower.level == 0) then False
    else 
        case get_tower board tower.posXY of
            Nothing -> False
            _ -> True

get_tower : Board -> (Float, Float) -> Maybe Tower
get_tower board pos =
    List.head (List.filter (\o -> o.posXY == pos) board.allTowers)

update_tower : Board -> Tower -> Board
update_tower board tower =
    let
        foundTowers = List.filter (\o -> o.posXY /= tower.posXY) board.allTowers
    in
    {board | allTowers = tower :: foundTowers}

-- aim_tower => rotates tower towards valid enemy target and spawns projectile
aim_tower : Tower -> List Enemy -> Float -> (Tower, Maybe Projectile)
aim_tower tower enemies dt = 
    let
        (centerX, centerY) = (Tuple.first tower.posXY + 0.5, Tuple.second tower.posXY + 0.5)

        -- filter enemies in range
        enemyList = List.filter (\o -> enemy_in_range o (centerX, centerY) tower.range) enemies

        -- sort enemies by tower targeting
        newTarget = 
            case tower.targeting of
                First -> first_enemy False enemyList 
                Strong -> first_enemy False <| strongest_enemies enemyList
                Weak -> first_enemy False <| weakest_enemies enemyList
                Close -> first_enemy False <| closest_enemies enemyList (centerX, centerY)
                Towers.Flying -> first_enemy True enemyList

        newTower = set_cooldown tower dt
    in
    case newTarget of 
        Nothing -> (newTower, Nothing)
        Just e -> 
            let
                newRotation = 
                    if (can_rotate tower) then rotation_of_2points (centerX, centerY) e.posXY
                    else tower.rotation
            in
            shoot_projectile {newTower | rotation = newRotation} e.layer

------------------------------------------------
-- Projectiles
------------------------------------------------

-- tower_to_projectile => creates projectile from tower
tower_to_projectile : Tower -> Float -> Projectile
tower_to_projectile tower enemyIndex = 
    let
        (centerX, centerY) = get_tower_center tower
        towerUpgrade = get_upgrade_type tower

        class = 
            case tower.class of
                Minigun -> Bullet enemyIndex

                Cannon -> Cannonball

                RocketLauncher size -> 
                    case get_upgrade_type tower of
                        NoPath -> Missile Projectiles.Regular size

                        Top -> Missile Projectiles.Explosive size
                        
                        Bottom -> Missile Projectiles.Impactful size

        distance = get_projectile_distance tower towerUpgrade
        spawnX = centerX + (sin tower.rotation) * distance 
        spawnY = centerY + (cos tower.rotation) * distance

        hitbox = get_projectile_hitbox tower towerUpgrade

        texture = get_projectile_texture tower towerUpgrade

        rotation = tower.rotation
        speed = tower.projectileSpeed
        lifespan = tower.projectileLifetime
        damage = tower.projectileDamage
        armorIgnore = tower.projectileArmorIgnore
        pierce = tower.projectilePierce
    in
    Projectile class texture 0 (spawnX, spawnY) rotation hitbox speed lifespan damage armorIgnore pierce

-- place_projectiles => assigns index to all new projectiles and filters out non-existing projectiles
place_projectiles : Board -> List (Maybe Projectile) -> Board
place_projectiles board newProjectiles = 
    let
        (newLayer, placedProjectiles) = 
            List.foldl
                (\o (layer, plist) -> 
                    case o of
                        Nothing -> (layer, plist)
                        Just p -> 
                            let
                                currentLayer = 
                                    if (layer - enemyLayerDifference < enemyLayerMinimal) then enemyLayerInitial - enemyLayerDifference
                                    else layer - enemyLayerDifference

                                newProjectile = {p | layer = currentLayer}
                            in
                            (currentLayer, newProjectile :: plist)
                ) 
                (board.projectileLayer, []) newProjectiles
    in
    {board | allProjectiles = placedProjectiles, projectileLayer = newLayer}

shoot_projectile : Tower -> Float -> (Tower, Maybe Projectile)
shoot_projectile tower enemyIndex = 
    -- create projectile
    if (tower.lastShot <= 0) then 
        let
            newProjectile = tower_to_projectile tower enemyIndex

            newTower = change_offset tower
        in 
        ({newTower | lastShot = tower.fireRate}, Just newProjectile)

    -- tower cannot shoot 
    else (tower, Nothing)

------------------------------------------------
-- Enemies
------------------------------------------------

-- spawn_enemies => assigns index to all spawned enemies and applies difficulty multiplier
spawn_enemies : Board -> List (Float, Enemy) -> Float -> Board  
spawn_enemies board wave enemyMultipllier = 
    let
        newEnemies = List.map Tuple.second wave

        (newLayer, placedEnemies) = 
            List.foldl
                (\o (layer, elist) -> 
                    let
                        currentLayer = 
                            if (layer - enemyLayerDifference < enemyLayerMinimal) then enemyLayerInitial - enemyLayerDifference
                            else layer - enemyLayerDifference

                        newEnemy = place_enemy o board.path board.airport currentLayer enemyMultipllier
                    in
                    (currentLayer, newEnemy :: elist)
                ) 
                (board.enemyLayer, []) newEnemies
        
    in
    {board | allEnemies = board.allEnemies ++ placedEnemies, enemyLayer = newLayer}

-- hit_enemy => reduces enemy health and projectile pierce (only if pierce > 0)
-- for Missile projectiles it also spawns Explosion
hit_enemy : (List Enemy, Maybe Projectile) -> Enemy -> (List Enemy, Maybe Projectile)
hit_enemy (enemyList, projectile) enemy = 
    case projectile of
        -- projectile ran out of pierce
        Nothing -> (enemy :: enemyList, Nothing)

        -- projectile can hit enemy
        Just p ->
            let
                newProjectile = 
                    case p.class of  
                        -- spawn Explosion
                        Missile _ _ -> create_explosion p
                        -- reduce pierce of projectile
                        _ -> reduce_pierce p

                newHealth = 
                    case p.class of  
                        Missile t _ -> 
                            case t of 
                                Projectiles.Impactful -> reduce_health enemy.health enemy.armor p
                                _ -> enemy.health

                        _ -> reduce_health enemy.health enemy.armor p

                newIndexList = 
                    case p.class of 
                        Bullet _ -> enemy.hitIndex 
                        Missile _  _ -> enemy.hitIndex
                        _ -> p.layer :: enemy.hitIndex 
            in
            ({enemy | health = newHealth, hitIndex = newIndexList} :: enemyList, newProjectile)

-- detect_collision => test collision between all enemies and one projectile
-- list of colliding enemies is passed into hit_enemy function, along with colliding projectile
detect_collision : (List Enemy, List Projectile) -> Projectile -> (List Enemy, List Projectile)
detect_collision (allEnemies, allProjectiles) projectile =    
    let
        -- collision test depending on projectile type
        (collidingEnemies, otherEnemies) = 
            case projectile.class of
                Bullet index -> 
                    List.partition (\o -> (o.health > 0) && (o.layer == index)) allEnemies

                Explosion _ _ -> 
                    List.partition 
                        (\o -> 
                            (o.health > 0) 
                            && (enemy_can_be_hit o projectile.layer) 
                            && (collision_2rectangles o.posXY o.hitbox o.rotation projectile.posXY projectile.hitbox projectile.rotation)
                        ) 
                        allEnemies

                Missile _ _ -> 
                    List.partition 
                        (\o -> 
                            (o.health > 0) 
                            && (collision_2rectangles o.posXY o.hitbox o.rotation projectile.posXY projectile.hitbox projectile.rotation)
                        ) 
                        allEnemies

                Cannonball -> 
                    List.partition 
                        (\o -> 
                            (o.health > 0) 
                            && (enemy_can_be_hit o projectile.layer) 
                            && (collision_circle_rectangle projectile.posXY (Tuple.first projectile.hitbox) o.posXY o.hitbox o.rotation)
                        ) 
                        allEnemies

        -- hit enemies
        (newEnemies, collidedProjectile) = List.foldl (\o (elist, pr) -> hit_enemy (elist, pr) o) ([], Just projectile) collidingEnemies

        newProjectiles = 
            -- remove bullet from projectile list
            case projectile.class of
                Bullet _ -> allProjectiles

                _ -> 
                    case collidedProjectile of
                        Nothing -> allProjectiles
                        Just p -> p :: allProjectiles
    in
    (otherEnemies ++ newEnemies, newProjectiles)

-- collide_objects => calls detect_collision on every projectile capable of hitting an enemy
collide_objects : List Enemy -> List Projectile -> (List Enemy, List Projectile)
collide_objects allEnemies allProjectiles = 
    let
        (activeProjectiles, nonActiveProjectiles) = List.partition can_collide allProjectiles

        (newEnemies, newProjectiles) = 
            List.foldl (\o (elist, plist) -> detect_collision (elist, plist) o) (allEnemies, []) activeProjectiles

    in
    (newEnemies, newProjectiles ++ nonActiveProjectiles)
