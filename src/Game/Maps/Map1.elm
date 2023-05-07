module Game.Maps.Map1 exposing (..)

import Game.Calculations exposing (..)
import Game.Tiles exposing (..)
import Game.Enemies exposing (..)

mapWidth : Int
mapWidth = 16

mapHeight : Int
mapHeight = 16

startingCash : Int
startingCash = 120

waveList : List Wave
waveList = 
    [
        create_wave 1 80
        [
            create_enemy Scout 0 0
            , create_enemy Scout 0 3
        ]  
        , create_wave 2 100
        [
            create_enemy Scout -0.2 0
            , create_enemy Scout 0 2
            , create_enemy Scout 0.2 4
            , create_enemy Scout -0.2 6
            , create_enemy Scout 0 8
            , create_enemy Scout 0.2 10
        ]  
        , create_wave 3 115
        [
            create_enemy Scout -1 0
            , create_enemy Scout 0 1
            , create_enemy Scout 1 2

            , create_enemy Soldier 0 4
        ]  
        , create_wave 4 130
        [
            create_enemy Soldier -0.2 0
            , create_enemy Scout -1 1

            , create_enemy Soldier 0.2 4
            , create_enemy Scout 1 5

            , create_enemy Soldier 0 8
            , create_enemy Scout 0 9
        ]  
        , create_wave 5 150
        [
            create_enemy Soldier -1 0
            , create_enemy Soldier -0.2 0.2

            , create_enemy Scout 0 1
            , create_enemy Scout 0 1.4

            , create_enemy Soldier 0.2 2.2
            , create_enemy Soldier 1 2.4

            , create_enemy Scout 0 3
            , create_enemy Scout 0 3.4

            , create_enemy Soldier -0.2 7
            , create_enemy Soldier 0.2 7.2
        ]  
        , create_wave 6 0
        [
            create_enemy Soldier 1 0
            , create_enemy Soldier -1 0.2

            , create_enemy Soldier -1 2
            , create_enemy Soldier 1 2.2

            , create_enemy Soldier 1 4
            , create_enemy Soldier -1 4.2
            
            , create_enemy Warrior 0 8
        ]  
    ]

airport : Maybe Point 
airport = Nothing

path : List Point
path = 
    [
        Point (0, 1) Right
        , Point (14, 1) Right
        , Point (14, 14) Up
        , Point (11, 14) Left
        , Point (11, 4) Down
        , Point (8, 4) Left
        , Point (8, 14) Up
        , Point (2, 14) Left
        , Point (2, 9) Down
        , Point (5, 9) Right
        , Point (5, 4) Down
        , Point (0, 4) Left
    ]
    
tileList : List ((Float, Float), Tile)
tileList = 
    [
        create_tile (0,0) Road 2
        , create_tile (1,0) Road 2
        , create_tile (2,0) Road 2
        , create_tile (3,0) Road 2
        , create_tile (4,0) Road 2
        , create_tile (5,0) Road 2
        , create_tile (6,0) Road 2
        , create_tile (7,0) Road 2
        , create_tile (8,0) Road 2
        , create_tile (9,0) Road 2
        , create_tile (10,0) Road 2
        , create_tile (11,0) Road 2
        , create_tile (12,0) Road 2
        , create_tile (13,0) Road 2
        , create_tile (14,0) Road 13
        , create_tile (15,0) (Lot (create_obstacle "rock-1" 0.8 90 (0, 1))) 0
        , create_tile (0,1) Road 4
        , create_tile (1,1) Road 4
        , create_tile (2,1) Road 4
        , create_tile (3,1) Road 4
        , create_tile (4,1) Road 4
        , create_tile (5,1) Road 4
        , create_tile (6,1) Road 4
        , create_tile (7,1) Road 4
        , create_tile (8,1) Road 4
        , create_tile (9,1) Road 4
        , create_tile (10,1) Road 4
        , create_tile (11,1) Road 4
        , create_tile (12,1) Road 4
        , create_tile (13,1) Road 7
        , create_tile (14,1) Road 5
        , create_tile (15,1) (Lot Nothing) 0
        , create_tile (0,2) (Lot Nothing) 0
        , create_tile (1,2) (Lot Nothing) 0
        , create_tile (2,2) (Lot Nothing) 0
        , create_tile (3,2) (Lot Nothing) 0
        , create_tile (4,2) (Lot Nothing) 0
        , create_tile (5,2) (Lot (create_obstacle "bush" 0.7 80 (1, 0))) 0
        , create_tile (6,2) (Lot (create_obstacle "bush-many" 0.85 10 (-1, 1))) 0
        , create_tile (7,2) (Lot Nothing) 0
        , create_tile (8,2) (Lot Nothing) 0
        , create_tile (9,2) (Lot Nothing) 0
        , create_tile (10,2) (Lot Nothing) 0
        , create_tile (11,2) (Lot Nothing) 0
        , create_tile (12,2) (Lot Nothing) 0
        , create_tile (13,2) Road 3
        , create_tile (14,2) Road 5
        , create_tile (15,2) (Lot Nothing) 0
        , create_tile (0,3) Road 2
        , create_tile (1,3) Road 2
        , create_tile (2,3) Road 2
        , create_tile (3,3) Road 2
        , create_tile (4,3) Road 2
        , create_tile (5,3) Road 13
        , create_tile (6,3) (Lot Nothing) 0
        , create_tile (7,3) Road 12
        , create_tile (8,3) Road 2
        , create_tile (9,3) Road 2
        , create_tile (10,3) Road 2
        , create_tile (11,3) Road 13
        , create_tile (12,3) (Lot Nothing) 0
        , create_tile (13,3) Road 3
        , create_tile (14,3) Road 5
        , create_tile (15,3) (Lot Nothing) 0
        , create_tile (0,4) Road 4
        , create_tile (1,4) Road 4
        , create_tile (2,4) Road 4
        , create_tile (3,4) Road 4
        , create_tile (4,4) Road 7
        , create_tile (5,4) Road 5
        , create_tile (6,4) (Lot (create_obstacle "rock-4" 0.75 45 (-1, 0))) 0
        , create_tile (7,4) Road 3
        , create_tile (8,4) Road 6
        , create_tile (9,4) Road 4
        , create_tile (10,4) Road 7
        , create_tile (11,4) Road 5
        , create_tile (12,4) (Lot Nothing) 0
        , create_tile (13,4) Road 3
        , create_tile (14,4) Road 5
        , create_tile (15,4) (Lot Nothing) 0
        , create_tile (0,5) (Lot (create_obstacle "tree" 0.85 20 (1, 0))) 0
        , create_tile (1,5) (Lot (create_obstacle "tree-star" 0.9 60 (-1, 0))) 0
        , create_tile (2,5) (Lot (create_obstacle "bush" 0.55 0 (-1, 0))) 0
        , create_tile (3,5) (Lot Nothing) 0
        , create_tile (4,5) Road 3
        , create_tile (5,5) Road 5
        , create_tile (6,5) (Lot Nothing) 0
        , create_tile (7,5) Road 3
        , create_tile (8,5) Road 5
        , create_tile (9,5) (Lot Nothing) 0
        , create_tile (10,5) Road 3
        , create_tile (11,5) Road 5
        , create_tile (12,5) (Lot Nothing) 0
        , create_tile (13,5) Road 3
        , create_tile (14,5) Road 5
        , create_tile (15,5) (Lot Nothing) 0
        , create_tile (0,6) (Lot (create_obstacle "tree-round" 0.65 15 (-1, -1))) 0
        , create_tile (1,6) (Lot (create_obstacle "tree" 0.65 30 (-0.05, 1))) 0
        , create_tile (2,6) (Lot (create_obstacle "rock-2" 0.5 10 (-1, 0))) 0
        , create_tile (3,6) (Lot Nothing) 0
        , create_tile (4,6) Road 3
        , create_tile (5,6) Road 5
        , create_tile (6,6) (Lot Nothing) 0
        , create_tile (7,6) Road 3
        , create_tile (8,6) Road 5
        , create_tile (9,6) (Lot (create_obstacle "bush-many" 0.9 170 (0, 1))) 0
        , create_tile (10,6) Road 3
        , create_tile (11,6) Road 5
        , create_tile (12,6) (Lot Nothing) 0
        , create_tile (13,6) Road 3
        , create_tile (14,6) Road 5
        , create_tile (15,6) (Lot Nothing) 0
        , create_tile (0,7) (Lot (create_obstacle "bush" 0.9 165 (1, 1))) 0
        , create_tile (1,7) (Lot Nothing) 0
        , create_tile (2,7) (Lot Nothing) 0
        , create_tile (3,7) (Lot Nothing) 0
        , create_tile (4,7) Road 3
        , create_tile (5,7) Road 5
        , create_tile (6,7) (Lot Nothing) 0
        , create_tile (7,7) Road 3
        , create_tile (8,7) Road 5
        , create_tile (9,7) (Lot Nothing) 0
        , create_tile (10,7) Road 3
        , create_tile (11,7) Road 5
        , create_tile (12,7) (Lot (create_obstacle "rock-6" 0.65 120 (0, 0))) 0
        , create_tile (13,7) Road 3
        , create_tile (14,7) Road 5
        , create_tile (15,7) (Lot Nothing) 0
        , create_tile (0,8) (Lot (create_obstacle "tree-round" 0.85 120 (1, -1))) 0
        , create_tile (1,8) Road 12
        , create_tile (2,8) Road 2
        , create_tile (3,8) Road 2
        , create_tile (4,8) Road 8
        , create_tile (5,8) Road 5
        , create_tile (6,8) (Lot Nothing) 0
        , create_tile (7,8) Road 3
        , create_tile (8,8) Road 5
        , create_tile (9,8) (Lot Nothing) 0
        , create_tile (10,8) Road 3
        , create_tile (11,8) Road 5
        , create_tile (12,8) (Lot Nothing) 0
        , create_tile (13,8) Road 3
        , create_tile (14,8) Road 5
        , create_tile (15,8) (Lot Nothing) 0
        , create_tile (0,9) (Lot (create_obstacle "bush-many" 0.75 0 (0, -1))) 0
        , create_tile (1,9) Road 3
        , create_tile (2,9) Road 6
        , create_tile (3,9) Road 4
        , create_tile (4,9) Road 4
        , create_tile (5,9) Road 11
        , create_tile (6,9) (Lot (create_obstacle "tree" 0.5 45 (-1, 1))) 0
        , create_tile (7,9) Road 3
        , create_tile (8,9) Road 5
        , create_tile (9,9) (Lot Nothing) 0
        , create_tile (10,9) Road 3
        , create_tile (11,9) Road 5
        , create_tile (12,9) (Lot Nothing) 0
        , create_tile (13,9) Road 3
        , create_tile (14,9) Road 5
        , create_tile (15,9) (Lot Nothing) 0
        , create_tile (0,10) (Lot (create_obstacle "rock-5" 0.75 0 (0, 0))) 0
        , create_tile (1,10) Road 3
        , create_tile (2,10) Road 5
        , create_tile (3,10) (Lot (create_obstacle "tree-star" 0.9 50 (-1, -1))) 0
        , create_tile (4,10) (Lot Nothing) 0
        , create_tile (5,10) (Lot Nothing) 0
        , create_tile (6,10) (Lot (create_obstacle "bush" 0.65 20 (0, 0))) 0
        , create_tile (7,10) Road 3
        , create_tile (8,10) Road 5
        , create_tile (9,10) (Lot Nothing) 0
        , create_tile (10,10) Road 3
        , create_tile (11,10) Road 5
        , create_tile (12,10) (Lot Nothing) 0
        , create_tile (13,10) Road 3
        , create_tile (14,10) Road 5
        , create_tile (15,10) (Lot (create_obstacle "bush-many" 0.9 160 (-1, 0))) 0
        , create_tile (0,11) (Lot Nothing) 0
        , create_tile (1,11) Road 3
        , create_tile (2,11) Road 5
        , create_tile (3,11) (Lot Nothing) 0
        , create_tile (4,11) (Lot Nothing) 0
        , create_tile (5,11) (Lot (create_obstacle "tree-round" 0.7 60 (0, 0))) 0
        , create_tile (6,11) (Lot Nothing) 0
        , create_tile (7,11) Road 3
        , create_tile (8,11) Road 5
        , create_tile (9,11) (Lot Nothing) 0
        , create_tile (10,11) Road 3
        , create_tile (11,11) Road 5
        , create_tile (12,11) (Lot Nothing) 0
        , create_tile (13,11) Road 3
        , create_tile (14,11) Road 5
        , create_tile (15,11) (Lot (create_obstacle "tree-star" 0.8 45 (0, 0))) 0
        , create_tile (0,12) (Lot Nothing) 0
        , create_tile (1,12) Road 3
        , create_tile (2,12) Road 5
        , create_tile (3,12) (Lot Nothing) 0
        , create_tile (4,12) (Lot Nothing) 0
        , create_tile (5,12) (Lot Nothing) 0
        , create_tile (6,12) (Lot Nothing) 0
        , create_tile (7,12) Road 3
        , create_tile (8,12) Road 5
        , create_tile (9,12) (Lot Nothing) 0
        , create_tile (10,12) Road 3
        , create_tile (11,12) Road 5
        , create_tile (12,12) (Lot Nothing) 0
        , create_tile (13,12) Road 3
        , create_tile (14,12) Road 5
        , create_tile (15,12) (Lot (create_obstacle "rock-4" 0.75 90 (-1, 0))) 0
        , create_tile (0,13) (Lot Nothing) 0
        , create_tile (1,13) Road 3
        , create_tile (2,13) Road 9
        , create_tile (3,13) Road 2
        , create_tile (4,13) Road 2
        , create_tile (5,13) Road 2
        , create_tile (6,13) Road 2
        , create_tile (7,13) Road 8
        , create_tile (8,13) Road 5
        , create_tile (9,13) (Lot (create_obstacle "tree-star" 0.8 140 (1, 0))) 0
        , create_tile (10,13) Road 3
        , create_tile (11,13) Road 9
        , create_tile (12,13) Road 2
        , create_tile (13,13) Road 8
        , create_tile (14,13) Road 5
        , create_tile (15,13) (Lot (create_obstacle "tree" 0.9 0 (1, 0))) 0
        , create_tile (0,14) (Lot Nothing) 0
        , create_tile (1,14) Road 10
        , create_tile (2,14) Road 4
        , create_tile (3,14) Road 4
        , create_tile (4,14) Road 4
        , create_tile (5,14) Road 4
        , create_tile (6,14) Road 4
        , create_tile (7,14) Road 4
        , create_tile (8,14) Road 11
        , create_tile (9,14) (Lot Nothing) 0
        , create_tile (10,14) Road 10
        , create_tile (11,14) Road 4
        , create_tile (12,14) Road 4
        , create_tile (13,14) Road 4
        , create_tile (14,14) Road 11
        , create_tile (15,14) (Lot (create_obstacle "bush" 0.9 100 (0, 1))) 0
        , create_tile (0,15) (Lot Nothing) 0
        , create_tile (1,15) (Lot (create_obstacle "tree" 0.85 70 (1, -1))) 0
        , create_tile (2,15) (Lot Nothing) 0
        , create_tile (3,15) (Lot Nothing) 0
        , create_tile (4,15) (Lot (create_obstacle "rock-2" 0.6 160 (0, -1))) 0
        , create_tile (5,15) (Lot (create_obstacle "rock-6" 0.7 0 (1, 0))) 0
        , create_tile (6,15) (Lot Nothing) 0
        , create_tile (7,15) (Lot Nothing) 0
        , create_tile (8,15) (Lot Nothing) 0
        , create_tile (9,15) (Lot Nothing) 0
        , create_tile (10,15) (Lot Nothing) 0
        , create_tile (11,15) (Lot Nothing) 0
        , create_tile (12,15) (Lot Nothing) 0
        , create_tile (13,15) (Lot (create_obstacle "tree-star" 0.55 10 (0, -1))) 0
        , create_tile (14,15) (Lot (create_obstacle "bush-many" 0.6 190 (0, 0))) 0
        , create_tile (15,15) (Lot (create_obstacle "tree-round" 0.8 90 (-1, -1))) 0
    ]
