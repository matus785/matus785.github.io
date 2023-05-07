module Game.Maps.Map3 exposing (..)

import Game.Calculations exposing (..)
import Game.Tiles exposing (..)
import Game.Enemies exposing (..)

mapWidth : Int
mapWidth = 15

mapHeight : Int
mapHeight = 15

startingCash : Int
startingCash = 450

waveList : List Wave
waveList =
    [ 
        create_wave 1 250
        [
            create_enemy Warrior 1 0
        ]  
        , create_wave 2 300
        [
            create_enemy Soldier 0 0
            , create_enemy Soldier 0.2 2
            , create_enemy Soldier 0 4
            , create_enemy Soldier 0.2 6
            , create_enemy Soldier 0 8
            , create_enemy Soldier 0.2 10
        ]
        , create_wave 3 200
        [
            create_enemy Warrior 0.2 0
            , create_enemy Scout -1 0.5
            , create_enemy Scout -1 1

            , create_enemy Warrior 0.2 2
            , create_enemy Scout -1 2.5
            , create_enemy Scout -1 3

            , create_enemy Warrior 0.2 4
            , create_enemy Scout -1 4.5
            , create_enemy Scout -1 5

            , create_enemy Warrior 0.2 6

            , create_enemy Soldier -1 12
            , create_enemy Soldier 0 12
            , create_enemy Soldier 1 12
        ]
        , create_wave 4 100
        [
            create_enemy Soldier 1 0
            , create_enemy Soldier 0.2 0
            , create_enemy Soldier 0.1 0

            , create_enemy Soldier 1 1
            , create_enemy Soldier 0.2 1
            , create_enemy Soldier 0.1 1

            , create_enemy Soldier 1 2
            , create_enemy Soldier 0.2 2
            , create_enemy Soldier 0.1 2

            , create_enemy Soldier 1 3
            , create_enemy Soldier 0.2 3
            , create_enemy Soldier 0.1 3

            , create_enemy Soldier 1 4
            , create_enemy Soldier 0.2 4
            , create_enemy Soldier 0.1 4

            , create_enemy Soldier 1 5
            , create_enemy Soldier 0.2 5
            , create_enemy Soldier 0.1 5
        ]
        , create_wave 5 300
        [
            create_enemy Veteran -1 0
            , create_enemy Veteran -1 3
            , create_enemy Veteran -1 6

            , create_enemy Warrior -1 16
            , create_enemy Warrior -1 16.2
            , create_enemy Warrior -1 16.4
            , create_enemy Warrior 0 16
            , create_enemy Warrior 0 16.2
            , create_enemy Warrior 0 16.4
            , create_enemy Warrior 1 16
            , create_enemy Warrior 1 16.2
            , create_enemy Warrior 1 16.4
        ]
        , create_wave 6 150
        [
            create_enemy Veteran 0 0

            , create_enemy Scout -0.2 0.33
            , create_enemy Scout 0.2 0.33
            , create_enemy Scout -0.2 0.66
            , create_enemy Scout 0.2 0.66
            , create_enemy Scout -0.2 1
            , create_enemy Scout 0.2 1

            , create_enemy Veteran 0.2 4

            , create_enemy Scout 0.2 4.33
            , create_enemy Scout 1 4.33
            , create_enemy Scout 0.2 4.66
            , create_enemy Scout 1 4.66
            , create_enemy Scout 0.2 5
            , create_enemy Scout 1 5

            , create_enemy Veteran -0.2 8

            , create_enemy Scout -1 8.33
            , create_enemy Scout -0.2 8.33
            , create_enemy Scout -1 8.66
            , create_enemy Scout -0.2 8.66
            , create_enemy Scout -1 9
            , create_enemy Scout -0.2 9

            , create_enemy Veteran 1 14
            , create_enemy Veteran -1 14

            , create_enemy Scout -1 14.33
            , create_enemy Scout 0 14.33
            , create_enemy Scout 1 14.33
            , create_enemy Scout -1 14.66
            , create_enemy Scout 0 14.66
            , create_enemy Scout 1 14.66
            , create_enemy Scout -1 15
            , create_enemy Scout 0 15
            , create_enemy Scout 1 15
        ]
        , create_wave 7 400
        [
            create_enemy Tank 0 0
            , create_enemy Tank 0 8
            , create_enemy Tank 0 16
        ]
        , create_wave 8 0
        [
            create_enemy Warrior 1 0
            , create_enemy Warrior 1 0
            , create_enemy Tank 0 0.5
            , create_enemy Warrior -1 1
            , create_enemy Warrior -1 1

            , create_enemy Scout -1 2
            , create_enemy Scout -0.2 2
            , create_enemy Scout 0.2 2
            , create_enemy Scout 1 2
            , create_enemy Scout -0.3 2.1
            , create_enemy Scout 0.3 2.1

            , create_enemy Warrior 1 6
            , create_enemy Warrior 1 6
            , create_enemy Tank 0 6.5
            , create_enemy Warrior -1 7
            , create_enemy Warrior -1 7

            , create_enemy Scout -1 8
            , create_enemy Scout -0.2 8
            , create_enemy Scout 0.2 8
            , create_enemy Scout 1 8
            , create_enemy Scout -0.3 8.1
            , create_enemy Scout 0.3 8.1

            , create_enemy Warrior 1 12
            , create_enemy Warrior 1 12
            , create_enemy Tank 0 12.5
            , create_enemy Warrior -1 13
            , create_enemy Warrior -1 13

            , create_enemy Veteran -1 14
            , create_enemy Veteran -0.2 14
            , create_enemy Veteran -0.1 14
            , create_enemy Veteran 0.1 16
            , create_enemy Veteran 0.2 16
            , create_enemy Veteran 1 16
        ]
    ]

path : List Point
path = 
    [
        Point (3, 0) Up
        , Point (3, 3) Up
        , Point (12, 3) Right
        , Point (12, 7) Up
        , Point (3, 7) Left
        , Point (3, 13) Up
        , Point (7, 13) Right
        , Point (7, 10) Down
        , Point (12, 10) Right
        , Point (12, 13) Up
        , Point (15, 13) Right
    ]

airport : Maybe Point 
airport = Nothing

tileList : List ((Float, Float), Tile)
tileList =
    [
        create_tile (0,0) (Lot (create_obstacle "bush" 0.5 90 (1, 1))) 0
        , create_tile (1,0) (Lot (create_obstacle "rock-5" 0.8 60 (0, 1))) 0
        , create_tile (2,0) Road 3
        , create_tile (3,0) Road 5
        , create_tile (4,0) (Lot Nothing) 0
        , create_tile (5,0) (Lot Nothing) 0
        , create_tile (6,0) (Lot Nothing) 0
        , create_tile (7,0) (Lot Nothing) 0
        , create_tile (8,0) (Lot Nothing) 0 
        , create_tile (9,0) (Lot (create_obstacle "tree" 0.75 160 (1, 0))) 0
        , create_tile (10,0) (Lot (create_obstacle "tree-star" 0.8 60 (-1, -1))) 0
        , create_tile (11,0) (Lot (create_obstacle "rock-1" 0.5 90 (0, -1))) 0
        , create_tile (12,0) (Lot (create_obstacle "tree-round" 0.65 50 (0.1, 0))) 0
        , create_tile (13,0) (Lot (create_obstacle "tree-round" 0.8 70 (-1, 1))) 0
        , create_tile (14,0) (Lot (create_obstacle "bush" 0.7 140 (-1, 0))) 0
        , create_tile (0,1) (Lot (create_obstacle "tree-star" 0.65 45 (1, 1))) 0
        , create_tile (1,1) (Lot Nothing) 0 
        , create_tile (2,1) Road 3
        , create_tile (3,1) Road 5
        , create_tile (4,1) (Lot Nothing) 0
        , create_tile (5,1) (Lot (create_obstacle "bush-many" 0.9 30 (0, 0))) 0
        , create_tile (6,1) (Lot Nothing) 0
        , create_tile (7,1) (Lot Nothing) 0
        , create_tile (8,1) (Lot Nothing) 0
        , create_tile (9,1) (Lot Nothing) 0
        , create_tile (10,1) (Lot Nothing) 0
        , create_tile (11,1) (Lot (create_obstacle "tree" 0.75 170 (1, -1))) 0
        , create_tile (12,1) (Lot (create_obstacle "rock-6" 0.9 0 (0, 0))) 0
        , create_tile (13,1) (Lot (create_obstacle "tree-star" 0.6 100 (-1, 1))) 0
        , create_tile (14,1) (Lot Nothing) 0
        , create_tile (0,2) (Lot (create_obstacle "tree-round" 0.9 10 (0, 0))) 0
        , create_tile (1,2) (Lot Nothing) 0
        , create_tile (2,2) Road 3
        , create_tile (3,2) Road 9
        , create_tile (4,2) Road 2
        , create_tile (5,2) Road 2
        , create_tile (6,2) Road 2
        , create_tile (7,2) Road 2
        , create_tile (8,2) Road 2
        , create_tile (9,2) Road 2
        , create_tile (10,2) Road 2
        , create_tile (11,2) Road 2
        , create_tile (12,2) Road 13
        , create_tile (13,2) (Lot (create_obstacle "bush-many" 0.8 90 (0, 1))) 0
        , create_tile (14,2) (Lot (create_obstacle "tree-round" 0.9 30 (0, 0))) 0
        , create_tile (0,3) (Lot Nothing) 0
        , create_tile (1,3) (Lot Nothing) 0 
        , create_tile (2,3) Road 10
        , create_tile (3,3) Road 4
        , create_tile (4,3) Road 4
        , create_tile (5,3) Road 4
        , create_tile (6,3) Road 4
        , create_tile (7,3) Road 4
        , create_tile (8,3) Road 4
        , create_tile (9,3) Road 4
        , create_tile (10,3) Road 4
        , create_tile (11,3) Road 7
        , create_tile (12,3) Road 5
        , create_tile (13,3) (Lot Nothing) 0
        , create_tile (14,3) (Lot (create_obstacle "bush" 0.65 240 (1, -1))) 0
        , create_tile (0,4) (Lot Nothing) 0
        , create_tile (1,4) (Lot Nothing) 0
        , create_tile (2,4) (Lot (create_obstacle "rock-1" 0.7 150 (0, 0))) 0
        , create_tile (3,4) (Lot Nothing) 0
        , create_tile (4,4) (Lot Nothing) 0
        , create_tile (5,4) (Lot (create_obstacle "tree" 0.8 10 (1, 1))) 0
        , create_tile (6,4) (Lot (create_obstacle "tree" 0.5 160 (1, -1))) 0
        , create_tile (7,4) (Lot (create_obstacle "tree-round" 0.9 130 (0, 0))) 0
        , create_tile (8,4) (Lot (create_obstacle "rock-4" 0.6 50 (0, -1))) 0
        , create_tile (9,4) (Lot Nothing) 0
        , create_tile (10,4) (Lot Nothing) 0
        , create_tile (11,4) Road 3
        , create_tile (12,4) Road 5
        , create_tile (13,4) (Lot (create_obstacle "rock-2" 0.65 30 (-1, 0))) 0
        , create_tile (14,4) (Lot (create_obstacle "tree" 0.55 70 (1, -1))) 0
        , create_tile (0,5) (Lot Nothing) 0
        , create_tile (1,5) (Lot Nothing) 0
        , create_tile (2,5) (Lot Nothing) 0
        , create_tile (3,5) (Lot Nothing) 0
        , create_tile (4,5) (Lot (create_obstacle "bush" 0.9 20 (0, 0))) 0
        , create_tile (5,5) (Lot Nothing) 0
        , create_tile (6,5) (Lot (create_obstacle "rock-3" 0.65 80 (-1, -1))) 0
        , create_tile (7,5) (Lot (create_obstacle "tree" 0.75 0 (-1, 0))) 0
        , create_tile (8,5) (Lot Nothing) 0
        , create_tile (9,5) (Lot (create_obstacle "tree-star" 0.8 0 (0, 1))) 0
        , create_tile (10,5) (Lot (create_obstacle "bush" 0.5 170 (-1, -1))) 0
        , create_tile (11,5) Road 3
        , create_tile (12,5) Road 5
        , create_tile (13,5) (Lot Nothing) 0
        , create_tile (14,5) (Lot (create_obstacle "tree-round" 0.7 90 (-1, -1))) 0
        , create_tile (0,6) (Lot Nothing) 0
        , create_tile (1,6) (Lot Nothing) 0
        , create_tile (2,6) Road 12
        , create_tile (3,6) Road 2
        , create_tile (4,6) Road 2
        , create_tile (5,6) Road 2
        , create_tile (6,6) Road 2
        , create_tile (7,6) Road 2
        , create_tile (8,6) Road 2
        , create_tile (9,6) Road 2
        , create_tile (10,6) Road 2
        , create_tile (11,6) Road 8
        , create_tile (12,6) Road 5
        , create_tile (13,6) (Lot Nothing) 0
        , create_tile (14,6) (Lot Nothing) 0
        , create_tile (0,7) (Lot Nothing) 0
        , create_tile (1,7) (Lot (create_obstacle "tree" 0.8 140 (1, -1))) 0
        , create_tile (2,7) Road 3
        , create_tile (3,7) Road 6
        , create_tile (4,7) Road 4
        , create_tile (5,7) Road 4
        , create_tile (6,7) Road 4
        , create_tile (7,7) Road 4
        , create_tile (8,7) Road 4
        , create_tile (9,7) Road 4
        , create_tile (10,7) Road 4
        , create_tile (11,7) Road 4
        , create_tile (12,7) Road 11
        , create_tile (13,7) (Lot Nothing) 0
        , create_tile (14,7) (Lot Nothing) 0
        , create_tile (0,8) (Lot Nothing) 0
        , create_tile (1,8) (Lot (create_obstacle "tree-star" 0.65 120 (-1, -1))) 0
        , create_tile (2,8) Road 3
        , create_tile (3,8) Road 5
        , create_tile (4,8) (Lot Nothing) 0
        , create_tile (5,8) (Lot Nothing) 0
        , create_tile (6,8) (Lot Nothing) 0
        , create_tile (7,8) (Lot Nothing) 0
        , create_tile (8,8) (Lot (create_obstacle "bush-many" 0.55 60 (0, 1))) 0
        , create_tile (9,8) (Lot Nothing) 0
        , create_tile (10,8) (Lot Nothing) 0
        , create_tile (11,8) (Lot Nothing) 0
        , create_tile (12,8) (Lot Nothing) 0
        , create_tile (13,8) (Lot Nothing) 0
        , create_tile (14,8) (Lot Nothing) 0
        , create_tile (0,9) (Lot (create_obstacle "rock-6" 0.9 210 (0, 0))) 0
        , create_tile (1,9) (Lot (create_obstacle "bush" 0.85 70 (-1, 0))) 0
        , create_tile (2,9) Road 3
        , create_tile (3,9) Road 5 
        , create_tile (4,9) (Lot Nothing) 0
        , create_tile (5,9) (Lot Nothing) 0
        , create_tile (6,9) Road 12
        , create_tile (7,9) Road 2
        , create_tile (8,9) Road 2
        , create_tile (9,9) Road 2
        , create_tile (10,9) Road 2
        , create_tile (11,9) Road 2
        , create_tile (12,9) Road 13
        , create_tile (13,9) (Lot Nothing) 0
        , create_tile (14,9) (Lot (create_obstacle "tree-star" 0.7 200 (-1, 1))) 0
        , create_tile (0,10) (Lot Nothing) 0
        , create_tile (1,10) (Lot (create_obstacle "tree-round" 0.8 40 (-1, 1))) 0
        , create_tile (2,10) Road 3
        , create_tile (3,10) Road 5
        , create_tile (4,10) (Lot Nothing) 0
        , create_tile (5,10) (Lot Nothing) 0
        , create_tile (6,10) Road 3
        , create_tile (7,10) Road 6
        , create_tile (8,10) Road 4
        , create_tile (9,10) Road 4
        , create_tile (10,10) Road 4
        , create_tile (11,10) Road 7
        , create_tile (12,10) Road 5
        , create_tile (13,10) (Lot (create_obstacle "tree" 0.9 45 (0, 0))) 0
        , create_tile (14,10) (Lot Nothing) 0
        , create_tile (0,11) (Lot Nothing) 0
        , create_tile (1,11) (Lot Nothing) 0
        , create_tile (2,11) Road 3
        , create_tile (3,11) Road 5
        , create_tile (4,11) (Lot (create_obstacle "rock-5" 0.6 260 (1, 1))) 0
        , create_tile (5,11) (Lot Nothing) 0
        , create_tile (6,11) Road 3
        , create_tile (7,11) Road 5
        , create_tile (8,11) (Lot Nothing) 0
        , create_tile (9,11) (Lot (create_obstacle "tree-round" 0.85 0 (1, 1))) 0
        , create_tile (10,11) (Lot (create_obstacle "rock-4" 0.7 70 (0, -1))) 0
        , create_tile (11,11) Road 3
        , create_tile (12,11) Road 5
        , create_tile (13,11) (Lot Nothing) 0
        , create_tile (14,11) (Lot Nothing) 0
        , create_tile (0,12) (Lot Nothing) 0
        , create_tile (1,12) (Lot Nothing) 0
        , create_tile (2,12) Road 3
        , create_tile (3,12) Road 9
        , create_tile (4,12) Road 2
        , create_tile (5,12) Road 2
        , create_tile (6,12) Road 8
        , create_tile (7,12) Road 5 
        , create_tile (8,12) (Lot Nothing) 0
        , create_tile (9,12) (Lot Nothing) 0
        , create_tile (10,12) (Lot (create_obstacle "tree-star" 0.5 45 (-1, -1))) 0
        , create_tile (11,12) Road 3
        , create_tile (12,12) Road 9
        , create_tile (13,12) Road 2
        , create_tile (14,12) Road 2
        , create_tile (0,13) (Lot (create_obstacle "bush-many" 0.9 90 (0, 0))) 0
        , create_tile (1,13) (Lot Nothing) 0
        , create_tile (2,13) Road 10
        , create_tile (3,13) Road 4
        , create_tile (4,13) Road 4
        , create_tile (5,13) Road 4
        , create_tile (6,13) Road 4
        , create_tile (7,13) Road 11
        , create_tile (8,13) (Lot Nothing) 0
        , create_tile (9,13) (Lot Nothing) 0
        , create_tile (10,13) (Lot Nothing) 0 
        , create_tile (11,13) Road 10
        , create_tile (12,13) Road 4
        , create_tile (13,13) Road 4
        , create_tile (14,13) Road 4
        , create_tile (0,14) (Lot Nothing) 0
        , create_tile (1,14) (Lot Nothing) 0
        , create_tile (2,14) (Lot Nothing) 0
        , create_tile (3,14) (Lot Nothing) 0
        , create_tile (4,14) (Lot Nothing) 0
        , create_tile (5,14) (Lot Nothing) 0
        , create_tile (6,14) (Lot (create_obstacle "bush-many" 0.75 130 (1, -1))) 0
        , create_tile (7,14) (Lot (create_obstacle "bush" 0.6 10 (-1, 0))) 0
        , create_tile (8,14) (Lot Nothing) 0
        , create_tile (9,14) (Lot Nothing) 0
        , create_tile (10,14) (Lot Nothing) 0
        , create_tile (11,14) (Lot Nothing) 0
        , create_tile (12,14) (Lot (create_obstacle "tree" 0.65 0 (-1, -1))) 0
        , create_tile (13,14) (Lot Nothing) 0
        , create_tile (14,14) (Lot Nothing) 0
    ]
