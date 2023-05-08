module Game.Level exposing (..)

import Array exposing (..)
import Dict exposing (..) 

import User exposing (Difficulty, difficulty_enemy_multiplier, difficulty_cost_multiplier)
import Game.Playboard exposing (..)
import Game.Tiles exposing (..)
import Game.Towers as Towers exposing (..)
import Game.Enemies exposing (..)
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


type Object =
    CurrentTile Tile 
    | CurrentTower Tower Bool
    | NoObject

type Action = 
    Buy
    | Sell  
    | Upgrade Towers.Upgrade_type 
    | Clear 
    | ChangeTargeting Towers.Target
    | NoAction

type LevelState = 
    NotComplete
    | Paused
    | Won
    | Lost

type alias Level = {
    lvlNumber : Int
    , lvlState : LevelState
    , lvlMap : Board
    , enemyMultiplier : Float   -- enemy health multiplier (from difficulty)
    , costMultiplier : Float    -- cost multiplier for Buying, Upgrading and Clearing obstacles (from difficulty)
    , money : Int
    , lives : Int
    , speed : Int               -- level speed, 0 => entities do NOT move
    , waves : Array Wave
    , currentWave : Maybe Wave
    , currentTime : Float       -- time spent on completing the level in miliseconds
    }

create_level : Difficulty -> Int -> Int -> Int -> Level
create_level diff lvl width height =
    let
        cash = 
            case lvl of 
                1 -> Map1.startingCash
                2 -> Map2.startingCash
                3 -> Map3.startingCash
                4 -> Map4.startingCash
                5 -> Map5.startingCash
                6 -> Map6.startingCash
                7 -> Map7.startingCash
                8 -> Map8.startingCash
                9 -> Map9.startingCash
                _ -> 0

        enemyWaves = 
            case lvl of
                1 -> Array.fromList Map1.waveList
                2 -> Array.fromList Map2.waveList
                3 -> Array.fromList Map3.waveList
                4 -> Array.fromList Map4.waveList
                5 -> Array.fromList Map5.waveList
                6 -> Array.fromList Map6.waveList
                7 -> Array.fromList Map7.waveList
                8 -> Array.fromList Map8.waveList
                9 -> Array.fromList Map9.waveList
                _ -> Array.empty

        newCostMult = difficulty_cost_multiplier diff
    in
    {
        lvlNumber = 
            if (cash == 0) then 0
            else lvl

        , lvlState = NotComplete
        , lvlMap = create_board lvl width height newCostMult
        , enemyMultiplier = difficulty_enemy_multiplier diff
        , costMultiplier = newCostMult
        , money = cash
        , lives = 20 
        , speed = 0
        , waves = enemyWaves
        , currentWave = Array.get 0 enemyWaves
        , currentTime = 0
    }

change_speed : Level -> Int -> Level 
change_speed level newspeed = 
    {level | speed = newspeed}

pause_level : Level -> Level
pause_level level = 
    case level.lvlState of
            NotComplete -> {level | lvlState = Paused}
            _ -> level

unpause_level : Level -> Level
unpause_level level = 
    case level.lvlState of
            Paused -> {level | lvlState = NotComplete}
            _ -> level

-- get_object => returns object (Tower or Tile) on XY position
get_object : Board -> (Float,Float) -> Object
get_object board pos = 
    let
        tower = get_tower board pos
        tile = Dict.get pos board.grid
    in
    case (tower, tile) of
        (Nothing , Nothing) -> NoObject
        (Nothing , Just ti) -> CurrentTile ti
        (Just to, _ ) -> CurrentTower to False

get_unbeaten_enemy_count : Level -> Int
get_unbeaten_enemy_count level = 
    let
        enemiesOnMap = List.length level.lvlMap.allEnemies

        enemiesInWave = 
            case level.currentWave of 
                Nothing -> 0
                Just w -> List.length w.enemies 
    in
    enemiesOnMap + enemiesInWave

get_wave_number : Level -> Int
get_wave_number level = 
    case level.currentWave of
        Nothing -> 0
        Just w -> w.waveNumber

-- increase_wave => increases wave number and rewards player with money
increase_wave : Level -> Level
increase_wave level =
    let
        newWave = case level.currentWave of   
            Just w -> Array.get w.waveNumber level.waves
            _ -> Nothing

        reward = 
            case level.currentWave of   
                Just w -> w.reward
                Nothing -> 0

        -- last wave => level won
        lvlState = 
            case newWave of 
                Nothing -> Won
                _ -> level.lvlState
    in
    {level | speed = 0, currentWave = newWave, lvlState = lvlState, lvlMap = clear_board level.lvlMap, money = level.money + reward}

-- spawn_wave => spawns enemies onto map from current wave
spawn_wave : Float -> Level -> Level
spawn_wave dt level = 
    case level.currentWave of 
        Nothing -> level
        Just w -> 
            let
                newTime = w.currentTime + dt
                (spawnedEnemies, waveEnemies) = List.partition (\o -> enemy_can_spawn o newTime) w.enemies

                newWave = {w | enemies = waveEnemies, currentTime = newTime}
            in
            { level 
                | currentWave = Just newWave
                , lvlMap = spawn_enemies level.lvlMap spawnedEnemies level.enemyMultiplier
            }

-- perform_action => performs action and returns changed level and object
-- also returns response String (if the action was succesfull than returns Nothing, otherwise Just String)
perform_action : Action -> Level -> Object -> (Level, Object, Maybe String)
perform_action act level obj =
    let
        oldMap = level.lvlMap
    in
    case act of
        -- buy new tower
        Buy ->
            case obj of 
                CurrentTower t _ ->
                    let
                        towerPrice = get_tower_price t NoPath
                    in
                    if (towerPrice > level.money) then (level, obj, Just "Not enought money!")
                    else if not (tile_is_clear level.lvlMap t.posXY) then (level, obj, Just "Wrong space!")
                    else 
                        let
                            newTower = increase_level t NoPath level.costMultiplier
                            updateMap = {oldMap | allTowers = newTower :: oldMap.allTowers}
                            updateObj = CurrentTower newTower False
                        in                
                        ({level | lvlMap = updateMap , money = level.money - towerPrice}, updateObj, Nothing)

                -- ERROR 
                _ ->  (level, obj, Just "Error: Wrong object selected!")

        -- sell existing tower
        Sell ->
            case obj of 
                CurrentTower t _ ->
                    if not (tower_is_placed level.lvlMap t) then (level, obj, Just "Error: Tower NOT found!") 
                    else 
                        let
                            updateMap = {oldMap | allTowers = List.filter (\o -> o.posXY /= t.posXY) oldMap.allTowers}
                            updateObj = NoObject
                        in                
                        ({level | lvlMap = updateMap , money = level.money + t.sellValue}, updateObj, Nothing)

                -- ERROR 
                _ ->  (level, obj, Just "Error: Wrong object selected!")

        -- clear obstacle on map
        Clear ->
            case obj of 
                CurrentTile t ->
                    let
                        clearCost = get_tile_clear_cost t
                    in
                    if (clearCost > level.money) then (level, obj, Just "Not enought money!")
                    else if not (has_obstacle t) then (level, obj, Just "Error: Tile is clear!") 
                    else 
                        let
                            newTile = {t | class = Lot Nothing}
                            updateMap = {oldMap | grid = Dict.update t.posXY (\_ -> Just newTile) oldMap.grid} 
                            updateObj = CurrentTile newTile
                        in                
                        ({level | lvlMap = updateMap , money = level.money - clearCost}, updateObj, Nothing)

                -- ERROR 
                _ ->  (level, obj, Just "Error: Wrong object selected!")

        -- upgrade existing tower
        Upgrade path ->
            case obj of 
                CurrentTower t show ->
                    let
                        towerPrice = get_tower_price t path
                    in
                    if (towerPrice > level.money) then (level, obj, Just "Not enought money!")
                    else if not (tower_is_placed level.lvlMap t) then (level, obj, Just "Error: Tower NOT found!") 
                    else 
                        let
                            updateMap = update_tower oldMap t 
                            updateObj = CurrentTower t show
                        in                
                        ({level | lvlMap = updateMap , money = level.money - towerPrice}, updateObj, Nothing)

                -- ERROR 
                _ ->  (level, obj, Just "Error: Wrong object selected!")

        -- change selected tower targeting
        ChangeTargeting target -> 
            case obj of 
                CurrentTower t _ -> 
                    if not (tower_is_placed level.lvlMap t) then (level, obj, Just "Error: Tower NOT found!") 
                    else 
                        let
                            oldTower = Maybe.withDefault t (get_tower oldMap t.posXY)
                            newTower = {oldTower | targeting = target}
                            updateMap = update_tower oldMap newTower 
                            updateObj = CurrentTower newTower False
                        in
                        ({level | lvlMap = updateMap}, updateObj, Nothing)

                -- ERROR 
                _ ->  (level, obj, Just "Error: Wrong object selected!")

        
        _ -> (level, obj, Just "Error: Action NOT selected!")

-- tick_time => changes level attributes depending on elapsed time
tick_time : Level -> Float -> Level
tick_time oldLevel dt =    
    case oldLevel.lvlState of
        NotComplete -> 
            let
                seconds = (dt * toFloat (level.speed)) / 1000
                level = {oldLevel | currentTime = oldLevel.currentTime + dt}
            in
            -- level is paused
            if (seconds == 0) then level

            -- level is running
            else 
                let
                    -- move enemies, towers, projectiles
                    (livesLost, moneyEarned, newBoard) = move_entities level.lvlMap seconds

                    -- set level lives
                    newLives = max 0 (level.lives - livesLost)

                    -- increase money
                    newLevel = {level | lvlMap = newBoard, lives = newLives, money = level.money + moneyEarned}

                in
                -- level is lost (lives == 0)
                if (newLevel.lives <= 0) then {newLevel | lvlState = Lost}

                -- increase enemy wave
                else if (get_unbeaten_enemy_count newLevel == 0) then newLevel |> increase_wave

                -- keep current wave and spawn enemies
                else newLevel |> spawn_wave seconds 

        _ -> oldLevel
