module Game.Maps.Map4 exposing (..)

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
        create_wave 1 250
        [
            create_enemy Scout 1 0
            , create_enemy Scout 1 0.5
            , create_enemy Scout 1 1

            , create_enemy Scout 1 4
            , create_enemy Scout 1 4.5
            , create_enemy Scout 1 5

            , create_enemy Scout 1 8
            , create_enemy Scout 1 8.5
            , create_enemy Scout 1 9

            , create_enemy Scout 0 12
        ]  
        , create_wave 2 350
        [
            create_enemy Scout -0.2 0
            , create_enemy Scout 0 0
            , create_enemy Scout 0.2 0

            , create_enemy Soldier 0.2 4
            , create_enemy Soldier 0.2 4.2

            , create_enemy Scout -0.2 8
            , create_enemy Scout 0.2 8

            , create_enemy Soldier -0.2 12
            , create_enemy Soldier -0.2 12.2
        ]  
        , create_wave 3 300
        [
            create_enemy Soldier -0.2 0
            , create_enemy Soldier 0.2 0
            , create_enemy Soldier -1 0.25
            , create_enemy Soldier 0 0
            , create_enemy Soldier 1 0.25

            , create_enemy Soldier -0.2 8.5
            , create_enemy Soldier 0.2 8.5
            , create_enemy Soldier -1 8.75
            , create_enemy Soldier 0 8.75
            , create_enemy Soldier 1 8.75

            , create_enemy Warrior 1 16
            , create_enemy Warrior -1 16
        ]  
        , create_wave 4 400
        [
            create_enemy Veteran -1 0

            , create_enemy Warrior 0 4
            , create_enemy Warrior -0.2 4
            , create_enemy Warrior 0.2 4

            , create_enemy Veteran 1 6

            , create_enemy Tank 0 10

            , create_enemy Veteran -1 12
            , create_enemy Veteran 1 12
        ]  
        , create_wave 5 100
        [
            create_enemy Soldier -0.2 0
            , create_enemy Soldier -0.1 0
            , create_enemy Soldier 0 0
            , create_enemy Soldier 0.1 0
            , create_enemy Soldier 0.2 0
            , create_enemy Soldier -0.2 0.1
            , create_enemy Soldier -0.1 0.1
            , create_enemy Soldier 0 0.1
            , create_enemy Soldier 0.1 0.1
            , create_enemy Soldier 0.2 0.1

            , create_enemy Tank 0 8
            , create_enemy Tank 0 9

            , create_enemy Soldier -1 14
            , create_enemy Soldier -0.2 14
            , create_enemy Soldier 0 14
            , create_enemy Soldier 0.2 14
            , create_enemy Soldier 1 14
            , create_enemy Soldier -1 14.1
            , create_enemy Soldier -0.2 14.1
            , create_enemy Soldier 0 14.1
            , create_enemy Soldier 0.2 14.1
            , create_enemy Soldier 1 14.1
        ]  
        , create_wave 6 300
        [
            create_enemy Tank 0 0
            , create_enemy Tank 0 0.5
            , create_enemy Tank 0 1

            , create_enemy Tank -1 7
            , create_enemy Tank -1 7.5
            , create_enemy Tank -1 8

            , create_enemy Tank 1 14
            , create_enemy Tank 1 14.5
            , create_enemy Tank 1 15

            , create_enemy Tank -1 20
            , create_enemy Tank 1 20
        ]  
        , create_wave 7 450
        [
            create_enemy Tank 0 0

            , create_enemy Soldier 1 0
            , create_enemy Soldier 1 0.15
            , create_enemy Soldier 1 0.3
            , create_enemy Soldier 1 0.45
            , create_enemy Soldier 1 0.6
            , create_enemy Soldier 1 0.75
            , create_enemy Soldier 1 0.9
            , create_enemy Soldier 1 1

            , create_enemy Warrior 1 6
            , create_enemy Warrior 0.3 6
            , create_enemy Warrior 0.2 6
            , create_enemy Warrior 0.1 6
            , create_enemy Warrior -0.1 6
            , create_enemy Warrior -0.2 6
            , create_enemy Warrior -0.3 6
            , create_enemy Warrior -1 6

            , create_enemy Soldier 1 6
            , create_enemy Soldier 1 6.15
            , create_enemy Soldier 1 6.3
            , create_enemy Soldier 1 6.45
            , create_enemy Soldier 1 6.6
            , create_enemy Soldier 1 6.75
            , create_enemy Soldier 1 6.9
            , create_enemy Soldier 1 7

            , create_enemy Veteran -1 12
            , create_enemy Veteran 1 12

            , create_enemy Soldier 1 12
            , create_enemy Soldier 1 12.15
            , create_enemy Soldier 1 12.3
            , create_enemy Soldier 1 12.45
            , create_enemy Soldier 1 12.6
            , create_enemy Soldier 1 12.75
            , create_enemy Soldier 1 12.9
            , create_enemy Soldier 1 13

            , create_enemy Tank 0.3 18
            , create_enemy Tank -0.3 18
        ]  
        , create_wave 8 0
        [
            create_enemy Tank 0 0
            , create_enemy Veteran -1 0
            , create_enemy Veteran 1 0

            , create_enemy Warrior -1 1
            , create_enemy Warrior -0.2 1
            , create_enemy Warrior 0 1
            , create_enemy Warrior 0.2 1
            , create_enemy Warrior 1 1
            , create_enemy Warrior -1 1.2
            , create_enemy Warrior -0.2 1.2
            , create_enemy Warrior 0 1.2
            , create_enemy Warrior 0.2 1.2
            , create_enemy Warrior 1 1.2

            , create_enemy Tank 0 5
            , create_enemy Veteran -1 5
            , create_enemy Veteran 1 5

            , create_enemy Warrior -1 6
            , create_enemy Warrior -0.2 6
            , create_enemy Warrior 0 6
            , create_enemy Warrior 0.2 6
            , create_enemy Warrior 1 6
            , create_enemy Warrior -1 6.2
            , create_enemy Warrior -0.2 6.2
            , create_enemy Warrior 0 6.2
            , create_enemy Warrior 0.2 6.2
            , create_enemy Warrior 1 6.2

            , create_enemy Tank 0 10
            , create_enemy Veteran -1 10
            , create_enemy Veteran 1 10
            
            , create_enemy Warrior -1 6
            , create_enemy Warrior -0.2 6
            , create_enemy Tank 0 6
            , create_enemy Warrior 0.2 6
            , create_enemy Warrior 1 6
            , create_enemy Warrior -1 6.2
            , create_enemy Warrior -0.2 6.2
            , create_enemy Tank 0 6.2
            , create_enemy Warrior 0.2 6.2
            , create_enemy Warrior 1 6.2
        ]  
    ]

airport : Maybe Point 
airport = Nothing

path : List Point
path = 
    [
        Point (15, 2) Left
        , Point (12, 2) Left
        , Point (12, 12) Up
        , Point (9, 12) Left
        , Point (9, 8) Down
        , Point (6, 8) Left
        , Point (6, 12) Up
        , Point (3, 12) Left
        , Point (3, 11) Down
        , Point (2, 11) Left
        , Point (2, 5) Down
        , Point (3, 5) Right
        , Point (3, 4) Down
        , Point (8, 4) Right
        , Point (8, 0) Down
    ]

tileList : List ((Float, Float), Tile)
tileList =
    [
        create_tile (0,0) (Lot (create_obstacle "tree" 0.85 60 (1, 1))) 0
        , create_tile (1,0) (Lot (create_obstacle "bush-many" 0.7 20 (0, -1))) 0
        , create_tile (2,0) (Lot (create_obstacle "tree-round" 0.75 60 (-1, 1))) 0
        , create_tile (3,0) (Lot Nothing) 0
        , create_tile (4,0) (Lot Nothing) 0
        , create_tile (5,0) (Lot (create_obstacle "bush" 0.6 290 (-1, 0))) 0
        , create_tile (6,0) (Lot Nothing) 0
        , create_tile (7,0) Road 3
        , create_tile (8,0) Road 5 
        , create_tile (9,0) (Lot Nothing) 0
        , create_tile (10,0) (Lot (create_obstacle "tree-round" 0.7 10 (1, 0))) 0
        , create_tile (11,0) (Lot (create_obstacle "tree-star" 0.85 80 (0, -1))) 0
        , create_tile (12,0) (Lot (create_obstacle "rock-2" 0.8 170 (-1, 1))) 0
        , create_tile (13,0) (Lot Nothing) 0
        , create_tile (14,0) (Lot Nothing) 0
        , create_tile (0,1) (Lot (create_obstacle "tree-star" 0.9 50 (0, 0))) 0
        , create_tile (1,1) (Lot (create_obstacle "rock-1" 0.5 0 (-1, -1))) 0
        , create_tile (2,1) (Lot Nothing) 0
        , create_tile (3,1) (Lot Nothing) 0
        , create_tile (4,1) (Lot Nothing) 0
        , create_tile (5,1) (Lot Nothing) 0
        , create_tile (6,1) (Lot (create_obstacle "tree-star" 0.65 160 (-1, 1))) 0
        , create_tile (7,1) Road 3
        , create_tile (8,1) Road 5
        , create_tile (9,1) (Lot Nothing) 0
        , create_tile (10,1) (Lot Nothing) 0
        , create_tile (11,1) Road 12
        , create_tile (12,1) Road 2
        , create_tile (13,1) Road 2
        , create_tile (14,1) Road 2
        , create_tile (0,2) (Lot (create_obstacle "tree" 0.65 110 (1, -1))) 0
        , create_tile (1,2) (Lot (create_obstacle "bush" 0.8 90 (-1, 1))) 0
        , create_tile (2,2) (Lot Nothing) 0
        , create_tile (3,2) (Lot (create_obstacle "rock-4" 0.9 60 (0, 0))) 0
        , create_tile (4,2) (Lot (create_obstacle "tree-round" 0.6 130 (-1, 1))) 0
        , create_tile (5,2) (Lot Nothing) 0
        , create_tile (6,2) (Lot (create_obstacle "rock-6" 0.7 10 (1, 1))) 0
        , create_tile (7,2) Road 3
        , create_tile (8,2) Road 5
        , create_tile (9,2) (Lot (create_obstacle "rock-3" 0.9 90 (0, 0))) 0
        , create_tile (10,2) (Lot Nothing) 0
        , create_tile (11,2) Road 3
        , create_tile (12,2) Road 6
        , create_tile (13,2) Road 4
        , create_tile (14,2) Road 4
        , create_tile (0,3) (Lot (create_obstacle "rock-5" 0.85 45 (-1, -1))) 0
        , create_tile (1,3) (Lot Nothing) 0 
        , create_tile (2,3) Road 12
        , create_tile (3,3) Road 2
        , create_tile (4,3) Road 2
        , create_tile (5,3) Road 2
        , create_tile (6,3) Road 2
        , create_tile (7,3) Road 8
        , create_tile (8,3) Road 5
        , create_tile (9,3) (Lot (create_obstacle "rock-1" 0.65 70 (1, 1))) 0
        , create_tile (10,3) (Lot (create_obstacle "tree-round" 0.85 90 (-1, 1))) 0
        , create_tile (11,3) Road 3
        , create_tile (12,3) Road 5
        , create_tile (13,3) (Lot (create_obstacle "rock-4" 0.75 150 (-1, 1))) 0
        , create_tile (14,3) (Lot Nothing) 0
        , create_tile (0,4) (Lot Nothing) 0
        , create_tile (1,4) Road 12
        , create_tile (2,4) Road 8
        , create_tile (3,4) Road 6
        , create_tile (4,4) Road 4
        , create_tile (5,4) Road 4
        , create_tile (6,4) Road 4
        , create_tile (7,4) Road 4
        , create_tile (8,4) Road 11
        , create_tile (9,4) (Lot (create_obstacle "rock-6" 0.65 0 (-1, 1))) 0
        , create_tile (10,4) (Lot Nothing) 0
        , create_tile (11,4) Road 3
        , create_tile (12,4) Road 5
        , create_tile (13,4) (Lot (create_obstacle "bush-many" 0.85 45 (-1, 1))) 0
        , create_tile (14,4) (Lot Nothing) 0
        , create_tile (0,5) (Lot (create_obstacle "bush-many" 0.6 0 (1, -1))) 0
        , create_tile (1,5) Road 3
        , create_tile (2,5) Road 6
        , create_tile (3,5) Road 11
        , create_tile (4,5) (Lot (create_obstacle "bush" 0.7 20 (-1, 1))) 0
        , create_tile (5,5) (Lot Nothing) 0
        , create_tile (6,5) (Lot (create_obstacle "rock-1" 0.9 190 (0, 0))) 0
        , create_tile (7,5) (Lot (create_obstacle "tree-star" 0.85 0 (1, -1))) 0
        , create_tile (8,5) (Lot (create_obstacle "rock-2" 0.65 80 (-1, 1))) 0
        , create_tile (9,5) (Lot (create_obstacle "tree" 0.8 140 (1, 1))) 0
        , create_tile (10,5) (Lot (create_obstacle "rock-4" 0.9 200 (0, 0))) 0
        , create_tile (11,5) Road 3
        , create_tile (12,5) Road 5
        , create_tile (13,5) (Lot Nothing) 0
        , create_tile (14,5) (Lot (create_obstacle "tree" 0.7 100 (-1, -1))) 0
        , create_tile (0,6) (Lot Nothing) 0
        , create_tile (1,6) Road 3
        , create_tile (2,6) Road 5
        , create_tile (3,6) (Lot (create_obstacle "rock-3" 0.8 45 (1, -1))) 0
        , create_tile (4,6) (Lot (create_obstacle "tree" 0.7 0 (0, -1))) 0
        , create_tile (5,6) (Lot (create_obstacle "rock-2" 0.65 0 (1, 1))) 0
        , create_tile (6,6) (Lot (create_obstacle "rock-4" 0.55 160 (-1, -1))) 0
        , create_tile (7,6) (Lot (create_obstacle "tree-round" 0.85 60 (-1, -1))) 0
        , create_tile (8,6) (Lot Nothing) 0
        , create_tile (9,6) (Lot (create_obstacle "bush-many" 0.85 20 (-1, 1))) 0
        , create_tile (10,6) (Lot (create_obstacle "bush" 0.8 0 (0, 1))) 0
        , create_tile (11,6) Road 3
        , create_tile (12,6) Road 5
        , create_tile (13,6) (Lot Nothing) 0
        , create_tile (14,6) (Lot Nothing) 0
        , create_tile (0,7) (Lot (create_obstacle "rock-6" 0.75 180 (0, 1))) 0
        , create_tile (1,7) Road 3
        , create_tile (2,7) Road 5
        , create_tile (3,7) (Lot (create_obstacle "tree-round" 0.85 0 (1, -1))) 0
        , create_tile (4,7) (Lot (create_obstacle "rock-6" 0.65 30 (1, -1))) 0
        , create_tile (5,7) Road 12
        , create_tile (6,7) Road 2
        , create_tile (7,7) Road 2
        , create_tile (8,7) Road 2
        , create_tile (9,7) Road 13
        , create_tile (10,7) (Lot (create_obstacle "rock-5" 0.8 180 (1, -1))) 0
        , create_tile (11,7) Road 3
        , create_tile (12,7) Road 5
        , create_tile (13,7) (Lot Nothing) 0
        , create_tile (14,7) (Lot Nothing) 0
        , create_tile (0,8) (Lot (create_obstacle "tree-round" 0.55 70 (-1, -1))) 0
        , create_tile (1,8) Road 3
        , create_tile (2,8) Road 5
        , create_tile (3,8) (Lot (create_obstacle "rock-5" 0.85 140 (1, -1))) 0
        , create_tile (4,8)(Lot (create_obstacle "tree-star" 0.55 170 (-1, -1))) 0
        , create_tile (5,8) Road 3
        , create_tile (6,8) Road 6
        , create_tile (7,8) Road 4
        , create_tile (8,8) Road 7
        , create_tile (9,8) Road 5
        , create_tile (10,8) (Lot (create_obstacle "rock-3" 0.75 0 (0, 1))) 0
        , create_tile (11,8) Road 3
        , create_tile (12,8) Road 5
        , create_tile (13,8) (Lot Nothing) 0
        , create_tile (14,8) (Lot (create_obstacle "bush-many" 0.5 90 (0, 1))) 0
        , create_tile (0,9) (Lot (create_obstacle "bush" 0.8 40  (1, -1))) 0
        , create_tile (1,9) Road 3
        , create_tile (2,9) Road 5
        , create_tile (3,9) (Lot (create_obstacle "rock-1" 0.55 60 (-1, 1))) 0
        , create_tile (4,9) (Lot (create_obstacle "bush-many" 0.75 180 (1, -1))) 0
        , create_tile (5,9) Road 3
        , create_tile (6,9) Road 5
        , create_tile (7,9) (Lot (create_obstacle "rock-5" 0.85 130 (0, -1))) 0
        , create_tile (8,9) Road 3
        , create_tile (9,9) Road 5
        , create_tile (10,9) (Lot (create_obstacle "tree-star" 0.9 30 (0, 0))) 0
        , create_tile (11,9) Road 3
        , create_tile (12,9) Road 5
        , create_tile (13,9) (Lot (create_obstacle "tree" 0.65 80 (-1, 1))) 0
        , create_tile (14,9) (Lot Nothing) 0
        , create_tile (0,10) (Lot Nothing) 0
        , create_tile (1,10) Road 3
        , create_tile (2,10) Road 9
        , create_tile (3,10) Road 13
        , create_tile (4,10) (Lot (create_obstacle "rock-3" 0.9 40 (0, 0))) 0
        , create_tile (5,10) Road 3
        , create_tile (6,10) Road 5
        , create_tile (7,10) (Lot (create_obstacle "bush-many" 0.7 10 (1, -1))) 0
        , create_tile (8,10) Road 3
        , create_tile (9,10) Road 5
        , create_tile (10,10) (Lot (create_obstacle "rock-2" 0.75 290 (-1, 1))) 0
        , create_tile (11,10) Road 3
        , create_tile (12,10) Road 5
        , create_tile (13,10) (Lot (create_obstacle "tree-round" 0.9 90 (0, 0))) 0
        , create_tile (14,10) (Lot Nothing) 0
        , create_tile (0,11) (Lot Nothing) 0
        , create_tile (1,11) Road 10
        , create_tile (2,11) Road 7
        , create_tile (3,11) Road 9
        , create_tile (4,11) Road 2
        , create_tile (5,11) Road 8
        , create_tile (6,11) Road 5
        , create_tile (7,11) (Lot Nothing) 0
        , create_tile (8,11) Road 3
        , create_tile (9,11) Road 9
        , create_tile (10,11) Road 2
        , create_tile (11,11) Road 8
        , create_tile (12,11) Road 5
        , create_tile (13,11) (Lot Nothing) 0
        , create_tile (14,11) (Lot (create_obstacle "tree-round" 0.8 45 (-1, 1))) 0
        , create_tile (0,12) (Lot (create_obstacle "tree" 0.5 60 (0, -1))) 0
        , create_tile (1,12) (Lot (create_obstacle "tree-star" 0.7 170 (1, 1))) 0
        , create_tile (2,12) Road 10
        , create_tile (3,12) Road 4
        , create_tile (4,12) Road 4
        , create_tile (5,12) Road 4
        , create_tile (6,12) Road 11
        , create_tile (7,12) (Lot (create_obstacle "tree-round" 0.9 30 (0, 0))) 0
        , create_tile (8,12) Road 10
        , create_tile (9,12) Road 4
        , create_tile (10,12) Road 4
        , create_tile (11,12) Road 4
        , create_tile (12,12) Road 11
        , create_tile (13,12) (Lot (create_obstacle "rock-6" 0.7 180 (1, -1))) 0
        , create_tile (14,12) (Lot Nothing) 0
        , create_tile (0,13) (Lot (create_obstacle "rock-4" 0.55 0 (1, -1))) 0
        , create_tile (1,13) (Lot Nothing) 0
        , create_tile (2,13) (Lot (create_obstacle "rock-3" 0.8 10 (-1, 1))) 0
        , create_tile (3,13) (Lot (create_obstacle "bush" 0.65 140 (-1, 0))) 0
        , create_tile (4,13) (Lot Nothing) 0
        , create_tile (5,13) (Lot Nothing) 0
        , create_tile (6,13) (Lot Nothing) 0
        , create_tile (7,13) (Lot (create_obstacle "bush" 0.7 40 (1, -1))) 0
        , create_tile (8,13) (Lot (create_obstacle "tree-star" 0.85 0 (-1, 1))) 0
        , create_tile (9,13) (Lot Nothing) 0
        , create_tile (10,13) (Lot Nothing) 0 
        , create_tile (11,13) (Lot (create_obstacle "tree" 0.6 0 (-1, 0))) 0
        , create_tile (12,13) (Lot Nothing) 0
        , create_tile (13,13) (Lot Nothing) 0
        , create_tile (14,13) (Lot Nothing) 0
        , create_tile (0,14) (Lot Nothing) 0
        , create_tile (1,14) (Lot (create_obstacle "tree-round" 0.85 0 (1, -1))) 0
        , create_tile (2,14) (Lot Nothing) 0
        , create_tile (3,14) (Lot Nothing) 0
        , create_tile (4,14) (Lot (create_obstacle "tree" 0.9 120 (0, 0))) 0
        , create_tile (5,14) (Lot (create_obstacle "tree" 0.6 180 (-1, -1))) 0
        , create_tile (6,14) (Lot Nothing) 0
        , create_tile (7,14) (Lot Nothing) 0
        , create_tile (8,14) (Lot Nothing) 0
        , create_tile (9,14) (Lot (create_obstacle "rock-1" 0.65 290 (1, -1))) 0
        , create_tile (10,14) (Lot Nothing) 0
        , create_tile (11,14) (Lot (create_obstacle "bush-many" 0.9 160 (0, 0))) 0
        , create_tile (12,14) (Lot Nothing) 0
        , create_tile (13,14) (Lot Nothing) 0
        , create_tile (14,14) (Lot (create_obstacle "bush" 0.8 60 (-1, 1))) 0
    ]
