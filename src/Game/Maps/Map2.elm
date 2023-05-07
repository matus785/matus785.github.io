module Game.Maps.Map2 exposing (..)

import Game.Calculations exposing (..)
import Game.Tiles exposing (..)
import Game.Enemies exposing (..)

mapWidth : Int
mapWidth = 15

mapHeight : Int
mapHeight = 15

startingCash : Int
startingCash = 300

waveList : List Wave
waveList = 
    [
        create_wave 1 160
        [
            create_enemy Scout 0 0
            , create_enemy Scout 0 1
            , create_enemy Scout 0 2
            , create_enemy Scout 0 3

            , create_enemy Soldier 0 6
            , create_enemy Soldier 0 9
        ]  
        , create_wave 2 200
        [
            create_enemy Scout -1 0
            , create_enemy Scout -1 1
            , create_enemy Scout -1 2

            , create_enemy Soldier 0 4

            , create_enemy Scout 1 6
            , create_enemy Scout 1 7
            , create_enemy Scout 1 8

            , create_enemy Soldier 0 10
            , create_enemy Soldier 0 10.5
        ]  
        , create_wave 3 240
        [
            create_enemy Soldier 0.2 0
            , create_enemy Soldier 0.2 0.1
            , create_enemy Soldier 0.2 0.2

            , create_enemy Scout -0.2 5
            , create_enemy Scout -0.1 5
            , create_enemy Scout 0 5
            , create_enemy Scout 0.1 5
            , create_enemy Scout 0.2 5

            , create_enemy Soldier -0.2 10
            , create_enemy Soldier -0.2 10.1
            , create_enemy Soldier -0.2 10.2

            , create_enemy Warrior 0 12
            , create_enemy Warrior 0 16
        ]  
        , create_wave 4 260
        [
            create_enemy Soldier -0.2 0
            , create_enemy Soldier 0.2 0
            , create_enemy Soldier -1 0.1
            , create_enemy Soldier 0 0.1
            , create_enemy Soldier 1 0.1

            , create_enemy Warrior 0 4

            , create_enemy Soldier -1 8
            , create_enemy Soldier 0 8
            , create_enemy Soldier 1 8
            , create_enemy Soldier -0.2 8.1
            , create_enemy Soldier 0.2 8.1

            , create_enemy Warrior 0.2 12
            , create_enemy Warrior 0.2 14
        ]  
        , create_wave 5 200
        [
            create_enemy Warrior 0 0

            , create_enemy Scout 1 0.2
            , create_enemy Scout 1 0.4
            , create_enemy Scout 1 0.6
            , create_enemy Scout 1 0.8
            , create_enemy Scout 1 1
            , create_enemy Scout 1 1.2
            , create_enemy Scout 1 1.4
            , create_enemy Scout 1 1.6
            , create_enemy Scout 1 1.8

            , create_enemy Warrior 0 2

            , create_enemy Scout 1 2.2
            , create_enemy Scout 1 2.4
            , create_enemy Scout 1 2.6
            , create_enemy Scout 1 2.8
            , create_enemy Scout 1 3
            , create_enemy Scout 1 3.2
            , create_enemy Scout 1 3.4
            , create_enemy Scout 1 3.6
            , create_enemy Scout 1 3.8

            , create_enemy Warrior 0 4

            , create_enemy Scout 1 4.2
            , create_enemy Scout 1 4.4
            , create_enemy Scout 1 4.6
            , create_enemy Scout 1 4.8
            , create_enemy Scout 1 5
            , create_enemy Scout 1 5.2
            , create_enemy Scout 1 5.4
            , create_enemy Scout 1 5.6
            , create_enemy Scout 1 5.8

            , create_enemy Warrior 0 6
        ]  
        , create_wave 6 320
        [
            create_enemy Warrior -1 0
            , create_enemy Warrior 1 1
            , create_enemy Warrior 0 2
            , create_enemy Warrior 1 3
            , create_enemy Warrior -1 4

            , create_enemy Veteran 0 8
            , create_enemy Veteran 0 10
        ]    
        , create_wave 7 0
        [
            create_enemy Warrior -0.2 0
            , create_enemy Warrior -0.1 0
            , create_enemy Warrior 0.1 0
            , create_enemy Warrior 0.2 0

            , create_enemy Veteran 0 2
            
            , create_enemy Warrior -0.2 4
            , create_enemy Warrior -0.1 4
            , create_enemy Warrior 0.1 4
            , create_enemy Warrior 0.2 4

            , create_enemy Veteran 0 6

            , create_enemy Warrior -0.2 8
            , create_enemy Warrior -0.1 8
            , create_enemy Warrior 0.1 8
            , create_enemy Warrior 0.2 8

            , create_enemy Veteran -1 12
            , create_enemy Veteran 1 12
        ]    

    ]

airport : Maybe Point 
airport = Nothing

path : List Point
path = 
    [
        Point (6, 15) Down
        , Point (6, 6) Down
        , Point (10, 6) Right
        , Point (10, 9) Up
        , Point (9, 9) Left
        , Point (9, 12) Up
        , Point (13, 12) Right
        , Point (13, 2) Down
        , Point (10, 2) Left
        , Point (10, 3) Up
        , Point (5, 3) Left
        , Point (5, 2) Down
        , Point (2, 2) Left
        , Point (2, 6) Up
        , Point (3, 6) Right
        , Point (3, 12) Up
        , Point (2, 12) Left
        , Point (2, 15) Up
    ]

tileList : List ((Float, Float), Tile)
tileList = 
    [
        create_tile (0,0) (Lot (create_obstacle "rock-5" 0.7 45 (-0.1, 1))) 0
        , create_tile (1,0) (Lot (create_obstacle "tree-star" 0.9 140 (0, 0))) 0
        , create_tile (2,0) (Lot (create_obstacle "bush-many" 0.75 45 (-1, 1))) 0
        , create_tile (3,0) (Lot Nothing) 0
        , create_tile (4,0) (Lot Nothing) 0
        , create_tile (5,0) (Lot Nothing) 0
        , create_tile (6,0) (Lot Nothing) 0
        , create_tile (7,0) (Lot Nothing) 0
        , create_tile (8,0) (Lot (create_obstacle "rock-3" 0.85 0 (0, 1))) 0
        , create_tile (9,0) (Lot Nothing) 0
        , create_tile (10,0) (Lot Nothing) 0
        , create_tile (11,0) (Lot Nothing) 0
        , create_tile (12,0) (Lot Nothing) 0
        , create_tile (13,0) (Lot Nothing) 0
        , create_tile (14,0) (Lot Nothing) 0
        , create_tile (0,1) (Lot (create_obstacle "tree-round" 0.8 60 (1, -1))) 0
        , create_tile (1,1) Road 12
        , create_tile (2,1) Road 2
        , create_tile (3,1) Road 2
        , create_tile (4,1) Road 2
        , create_tile (5,1) Road 13
        , create_tile (6,1) (Lot (create_obstacle "tree" 0.75 120 (-1, 0))) 0
        , create_tile (7,1) (Lot Nothing) 0
        , create_tile (8,1) (Lot Nothing) 0
        , create_tile (9,1) Road 12
        , create_tile (10,1) Road 2
        , create_tile (11,1) Road 2
        , create_tile (12,1) Road 2
        , create_tile (13,1) Road 13
        , create_tile (14,1) (Lot (create_obstacle "bush" 0.85 160 (-1, -1))) 0
        , create_tile (0,2) (Lot Nothing) 0
        , create_tile (1,2) Road 3
        , create_tile (2,2) Road 6
        , create_tile (3,2) Road 4
        , create_tile (4,2) Road 7
        , create_tile (5,2) Road 9
        , create_tile (6,2) Road 2
        , create_tile (7,2) Road 2
        , create_tile (8,2) Road 2
        , create_tile (9,2) Road 8
        , create_tile (10,2) Road 6
        , create_tile (11,2) Road 4
        , create_tile (12,2) Road 7
        , create_tile (13,2) Road 5
        , create_tile (14,2) (Lot Nothing) 0
        , create_tile (0,3) (Lot Nothing) 0
        , create_tile (1,3) Road 3
        , create_tile (2,3) Road 5
        , create_tile (3,3) (Lot Nothing) 0
        , create_tile (4,3) Road 10
        , create_tile (5,3) Road 4
        , create_tile (6,3) Road 4
        , create_tile (7,3) Road 4
        , create_tile (8,3) Road 4
        , create_tile (9,3) Road 4
        , create_tile (10,3) Road 11
        , create_tile (11,3) (Lot (create_obstacle "rock-1" 0.9 90 (1, 0))) 0
        , create_tile (12,3) Road 3
        , create_tile (13,3) Road 5
        , create_tile (14,3) (Lot Nothing) 0
        , create_tile (0,4) (Lot Nothing) 0
        , create_tile (1,4) Road 3
        , create_tile (2,4) Road 5
        , create_tile (3,4) (Lot Nothing) 0
        , create_tile (4,4) (Lot (create_obstacle "bush" 0.5 10 (1, -1))) 0
        , create_tile (5,4) (Lot (create_obstacle "tree-round" 0.8 70 (0, -1))) 0
        , create_tile (6,4) (Lot Nothing) 0
        , create_tile (7,4) (Lot Nothing) 0
        , create_tile (8,4) (Lot Nothing) 0
        , create_tile (9,4) (Lot Nothing) 0
        , create_tile (10,4) (Lot (create_obstacle "rock-5" 0.6 90 (1, -1))) 0
        , create_tile (11,4) (Lot (create_obstacle "bush-many" 0.9 50 (-1, -1))) 0
        , create_tile (12,4) Road 3
        , create_tile (13,4) Road 5
        , create_tile (14,4) (Lot Nothing) 0
        , create_tile (0,5) (Lot Nothing) 0
        , create_tile (1,5) Road 3
        , create_tile (2,5) Road 9
        , create_tile (3,5) Road 13
        , create_tile (4,5) (Lot Nothing) 0
        , create_tile (5,5) Road 12
        , create_tile (6,5) Road 2
        , create_tile (7,5) Road 2
        , create_tile (8,5) Road 2
        , create_tile (9,5) Road 2
        , create_tile (10,5) Road 13
        , create_tile (11,5) (Lot (create_obstacle "tree" 0.8 40 (0, 0.1))) 0
        , create_tile (12,5) Road 3
        , create_tile (13,5) Road 5
        , create_tile (14,5) (Lot (create_obstacle "rock-2" 0.9 150 (0, 1))) 0
        , create_tile (0,6) (Lot Nothing) 0
        , create_tile (1,6) Road 10
        , create_tile (2,6) Road 7
        , create_tile (3,6) Road 5
        , create_tile (4,6) (Lot Nothing) 0
        , create_tile (5,6) Road 3
        , create_tile (6,6) Road 6
        , create_tile (7,6) Road 4
        , create_tile (8,6) Road 4
        , create_tile (9,6) Road 7
        , create_tile (10,6) Road 5
        , create_tile (11,6) (Lot Nothing) 0
        , create_tile (12,6) Road 3
        , create_tile (13,6) Road 5
        , create_tile (14,6) (Lot (create_obstacle "tree-star" 0.7 0 (0, -1))) 0
        , create_tile (0,7) (Lot Nothing) 0
        , create_tile (1,7) (Lot Nothing) 0
        , create_tile (2,7) Road 3
        , create_tile (3,7) Road 5
        , create_tile (4,7) (Lot Nothing) 0
        , create_tile (5,7) Road 3
        , create_tile (6,7) Road 5
        , create_tile (7,7) (Lot (create_obstacle "bush-many" 0.55 100 (-1, -1))) 0
        , create_tile (8,7) (Lot Nothing) 0
        , create_tile (9,7) Road 3
        , create_tile (10,7) Road 5
        , create_tile (11,7) (Lot (create_obstacle "tree-round" 0.9 200 (-1, 0))) 0
        , create_tile (12,7) Road 3
        , create_tile (13,7) Road 5
        , create_tile (14,7) (Lot Nothing) 0
        , create_tile (0,8) (Lot Nothing) 0
        , create_tile (1,8) (Lot Nothing) 0
        , create_tile (2,8) Road 3
        , create_tile (3,8) Road 5
        , create_tile (4,8) (Lot Nothing) 0
        , create_tile (5,8) Road 3
        , create_tile (6,8) Road 5
        , create_tile (7,8) (Lot (create_obstacle "tree" 0.7 60 (0, -1))) 0
        , create_tile (8,8) Road 12
        , create_tile (9,8) Road 8
        , create_tile (10,8) Road 5
        , create_tile (11,8) (Lot Nothing) 0
        , create_tile (12,8) Road 3
        , create_tile (13,8) Road 5
        , create_tile (14,8) (Lot Nothing) 0
        , create_tile (0,9) (Lot Nothing) 0
        , create_tile (1,9) (Lot (create_obstacle "rock-4" 0.8 0 (1, 0))) 0
        , create_tile (2,9) Road 3
        , create_tile (3,9) Road 5
        , create_tile (4,9) (Lot Nothing) 0
        , create_tile (5,9) Road 3
        , create_tile (6,9) Road 5
        , create_tile (7,9) (Lot Nothing) 0
        , create_tile (8,9) Road 3
        , create_tile (9,9) Road 6
        , create_tile (10,9) Road 11
        , create_tile (11,9) (Lot Nothing) 0
        , create_tile (12,9) Road 3
        , create_tile (13,9) Road 5
        , create_tile (14,9) (Lot Nothing) 0
        , create_tile (0,10) (Lot Nothing) 0
        , create_tile (1,10) (Lot Nothing) 0
        , create_tile (2,10) Road 3
        , create_tile (3,10) Road 5
        , create_tile (4,10) (Lot Nothing) 0
        , create_tile (5,10) Road 3
        , create_tile (6,10) Road 5
        , create_tile (7,10) (Lot Nothing) 0
        , create_tile (8,10) Road 3
        , create_tile (9,10) Road 5
        , create_tile (10,10) (Lot (create_obstacle "bush" 0.85 0 (-1, 0))) 0
        , create_tile (11,10) (Lot Nothing) 0
        , create_tile (12,10) Road 3
        , create_tile (13,10) Road 5
        , create_tile (14,10) (Lot (create_obstacle "tree" 0.6 120 (-1, 0))) 0
        , create_tile (0,11) (Lot Nothing) 0
        , create_tile (1,11) Road 12
        , create_tile (2,11) Road 8
        , create_tile (3,11) Road 5
        , create_tile (4,11) (Lot (create_obstacle "tree-star" 0.8 45 (1, 1))) 0
        , create_tile (5,11) Road 3
        , create_tile (6,11) Road 5
        , create_tile (7,11) (Lot Nothing) 0
        , create_tile (8,11) Road 3
        , create_tile (9,11) Road 9
        , create_tile (10,11) Road 2
        , create_tile (11,11) Road 2
        , create_tile (12,11) Road 8
        , create_tile (13,11) Road 5
        , create_tile (14,11) (Lot (create_obstacle "rock-6" 0.5 30 (-1, -1))) 0
        , create_tile (0,12) (Lot (create_obstacle "tree" 0.9 90 (1, 1))) 0
        , create_tile (1,12) Road 3
        , create_tile (2,12) Road 6
        , create_tile (3,12) Road 11
        , create_tile (4,12) (Lot (create_obstacle "rock-1" 0.75 160 (0, 0))) 0
        , create_tile (5,12) Road 3
        , create_tile (6,12) Road 5
        , create_tile (7,12) (Lot Nothing) 0
        , create_tile (8,12) Road 10
        , create_tile (9,12) Road 4
        , create_tile (10,12) Road 4
        , create_tile (11,12) Road 4
        , create_tile (12,12) Road 4
        , create_tile (13,12) Road 11
        , create_tile (14,12) (Lot Nothing) 0
        , create_tile (0,13) (Lot Nothing) 0
        , create_tile (1,13) Road 3
        , create_tile (2,13) Road 5
        , create_tile (3,13) (Lot Nothing) 0
        , create_tile (4,13) (Lot (create_obstacle "bush-many" 0.9 30 (1, 0))) 0
        , create_tile (5,13) Road 3
        , create_tile (6,13) Road 5
        , create_tile (7,13) (Lot Nothing) 0
        , create_tile (8,13) (Lot Nothing) 0
        , create_tile (9,13) (Lot Nothing) 0
        , create_tile (10,13) (Lot (create_obstacle "bush-many" 0.6 180 (1, 1))) 0
        , create_tile (11,13) (Lot (create_obstacle "tree-star" 0.7 170 (1, 0))) 0
        , create_tile (12,13) (Lot (create_obstacle "tree-round" 0.5 60 (-1, 1))) 0
        , create_tile (13,13) (Lot (create_obstacle "rock-5" 0.8 20 (1, -1))) 0
        , create_tile (14,13) (Lot Nothing) 0
        , create_tile (0,14) (Lot Nothing) 0
        , create_tile (1,14) Road 3
        , create_tile (2,14) Road 5
        , create_tile (3,14) (Lot (create_obstacle "tree-round" 0.75 0 (1, 0))) 0
        , create_tile (4,14) (Lot (create_obstacle "rock-3" 0.65 45 (1, -1))) 0
        , create_tile (5,14) Road 3
        , create_tile (6,14) Road 5
        , create_tile (7,14) (Lot (create_obstacle "rock-4" 0.9 90 (-1, -1))) 0
        , create_tile (8,14) (Lot Nothing) 0
        , create_tile (9,14) (Lot (create_obstacle "bush" 0.65 240 (1, -1))) 0
        , create_tile (10,14) (Lot (create_obstacle "tree" 0.9 45 (0, 0))) 0
        , create_tile (11,14) (Lot (create_obstacle "tree" 0.7 0 (0, -1))) 0
        , create_tile (12,14) (Lot (create_obstacle "tree-star" 0.9 140 (0, 1))) 0
        , create_tile (13,14) (Lot Nothing) 0
        , create_tile (14,14) (Lot (create_obstacle "bush-many" 0.85 0 (1, 1))) 0
    ]
