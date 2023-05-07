module Game.Maps.Map9 exposing (..)

import Game.Calculations exposing (..)
import Game.Tiles exposing (..)
import Game.Enemies exposing (..)

mapWidth : Int
mapWidth = 14

mapHeight : Int
mapHeight = 14

startingCash : Int
startingCash = 200

waveList : List Wave
waveList = 
    [
        create_wave 1 250
        [
            create_enemy Scout 1 0
            , create_enemy Scout 1 2.5
            , create_enemy Scout 1 5
            , create_enemy Scout 1 7.5
            , create_enemy Scout 1 10
            , create_enemy Scout 1 12.5
            , create_enemy Scout 0 15
            , create_enemy Scout 0 17
            , create_enemy Scout 0 19
            , create_enemy Scout 0 21
            , create_enemy Scout 0 23
            , create_enemy Scout 0 25
        ]  
        , create_wave 2 450
        [
            create_enemy Scout -1 0
            , create_enemy Scout -1 3

            , create_enemy Soldier 1 4.5

            , create_enemy Scout -1 6
            , create_enemy Scout -1 9

            , create_enemy Soldier 1 10.5

            , create_enemy Scout -1 12
            , create_enemy Scout -1 15

            , create_enemy Soldier 1 16.5

            , create_enemy Scout -1 18
            , create_enemy Scout -1 21

            , create_enemy Soldier 1 22.5

            , create_enemy Scout -1 24

            , create_enemy Soldier 0 25
            , create_enemy Soldier 0 27
        ]  
        , create_wave 3 350
        [
            create_enemy Warrior 1 0
            , create_enemy Warrior 1 0.5
            , create_enemy Warrior 1 1
            , create_enemy Warrior 1 1.5

            , create_enemy Warrior 0 4
            , create_enemy Warrior 0 4.5
            , create_enemy Warrior 0 5
            , create_enemy Warrior 0 5.5

            , create_enemy Warrior 1 8
            , create_enemy Warrior 1 8.5
            , create_enemy Warrior 1 9
            , create_enemy Warrior 1 9.5

            , create_enemy Warrior -1 15
            , create_enemy Warrior 0 15
            , create_enemy Warrior 1 15
            , create_enemy Warrior -1 16
            , create_enemy Warrior 0 16
            , create_enemy Warrior 1 16
        ]  
        , create_wave 4 600
        [
            create_enemy Veteran 0 0

            , create_enemy Warrior -1 0.2
            , create_enemy Warrior -1 0.4
            , create_enemy Warrior -1 0.6

            , create_enemy Veteran 0 4

            , create_enemy Warrior -1 4.2
            , create_enemy Warrior -1 4.4
            , create_enemy Warrior -1 4.6

            , create_enemy Veteran 0 8

            , create_enemy Warrior -1 8.2
            , create_enemy Warrior -1 8.4
            , create_enemy Warrior -1 8.6

            , create_enemy Veteran 0 12

            , create_enemy Warrior -1 12.2
            , create_enemy Warrior -1 12.4
            , create_enemy Warrior -1 12.6

            , create_enemy Warrior -0.2 14
            , create_enemy Warrior 0 14
            , create_enemy Warrior 0.2 14

            , create_enemy Warrior -0.2 15
            , create_enemy Warrior 0 15
            , create_enemy Warrior 0.2 15
        ]  
        , create_wave 5 600
        [
            create_enemy Tank -1 0
            , create_enemy Tank -1 0.8
            , create_enemy Tank -1 1.6

            , create_enemy HeavyTank -1 8

            , create_enemy Tank -1 10
            , create_enemy Tank -1 10.8
            , create_enemy Tank -1 11.6

            , create_enemy HeavyTank 0 16

            , create_enemy Tank -1 18
            , create_enemy Tank -1 18.8
            , create_enemy Tank -1 19.6

            , create_enemy HeavyTank 1 22
        ]   
        , create_wave 6 300
        [
            create_enemy Plane -1 0
            , create_enemy Plane 0 8
            , create_enemy Plane 1 16

            , create_enemy Plane -1 24
            , create_enemy Plane 1 24

            , create_enemy HeavyPlane -1 30
        ]  
        , create_wave 7 100
        [
            create_enemy HeavyPlane -1 0

            , create_enemy Soldier 1 1
            , create_enemy Soldier 1 1.5
            , create_enemy Soldier 1 2
            , create_enemy Soldier 1 2.5
            , create_enemy Soldier 1 3
            , create_enemy Soldier 1 3.5
            , create_enemy Soldier 1 4
            , create_enemy Soldier 1 4.5
            , create_enemy Soldier 1 5

            , create_enemy Tank -1 5
            , create_enemy Tank 1 5

            , create_enemy Soldier 1 6
            , create_enemy Soldier 1 6.5
            , create_enemy Soldier 1 7
            , create_enemy Soldier 1 7.5
            , create_enemy Soldier 1 8
            , create_enemy Soldier 1 8.5
            , create_enemy Soldier 1 9
            , create_enemy Soldier 1 9.5
            , create_enemy Soldier 1 10

            , create_enemy HeavyPlane -1 10

            , create_enemy Soldier 0 11
            , create_enemy Soldier 0 11.5
            , create_enemy Soldier 0 12
            , create_enemy Soldier 0 12.5
            , create_enemy Soldier 0 13
            , create_enemy Soldier 0 13.5
            , create_enemy Soldier 0 14
            , create_enemy Soldier 0 14.5
            , create_enemy Soldier 0 15

            , create_enemy Tank -1 15
            , create_enemy Tank 1 15

            , create_enemy Soldier 0 16
            , create_enemy Soldier 0 16.5
            , create_enemy Soldier 0 17
            , create_enemy Soldier 0 17.5
            , create_enemy Soldier 0 18
            , create_enemy Soldier 0 18.5
            , create_enemy Soldier 0 19
            , create_enemy Soldier 0 19.5
            , create_enemy Soldier 0 20

            , create_enemy HeavyPlane -1 20

            , create_enemy Soldier -1 21
            , create_enemy Soldier -1 22
            , create_enemy Soldier -1 23
            , create_enemy Soldier -1 24
            , create_enemy Soldier -1 25

            , create_enemy HeavyTank 0 25

            , create_enemy Plane -1 30
            , create_enemy Plane 0 30
            , create_enemy Plane 1 30
        ]  
        , create_wave 8 100
        [
            create_enemy HeavyTank -1 0
            , create_enemy HeavyTank 1 0

            , create_enemy Veteran 0.3 4
            , create_enemy Veteran 0.2 4
            , create_enemy Veteran 0.1 4
            , create_enemy Veteran -0.1 4
            , create_enemy Veteran -0.2 4
            , create_enemy Veteran -0.3 4

            , create_enemy Tank -1 8
            , create_enemy Tank 0 8
            , create_enemy Tank 1 8
            , create_enemy Tank -1 9
            , create_enemy Tank 0 9
            , create_enemy Tank 1 9
            , create_enemy Tank -1 10
            , create_enemy Tank 0 10
            , create_enemy Tank 1 10

            , create_enemy Veteran 0.3 14
            , create_enemy Veteran 0.2 14
            , create_enemy Veteran 0.1 14
            , create_enemy Veteran -0.1 14
            , create_enemy Veteran -0.2 14
            , create_enemy Veteran -0.3 14

            , create_enemy HeavyTank -1 18
            , create_enemy HeavyTank 1 18
        ]  
        , create_wave 9 50
        [
            create_enemy Plane -1 0
            , create_enemy Plane 1 0

            , create_enemy Warrior -0.3 1
            , create_enemy Warrior -0.2 1
            , create_enemy Warrior -0.1 1
            , create_enemy Veteran 0 1
            , create_enemy Warrior 0.1 1
            , create_enemy Warrior 0.2 1
            , create_enemy Warrior 0.3 1

            , create_enemy Tank -1 1.5
            , create_enemy Tank 1 1.5

            , create_enemy Warrior -0.3 2
            , create_enemy Warrior -0.2 2
            , create_enemy Warrior -0.1 2
            , create_enemy Veteran 0 2
            , create_enemy Warrior 0.1 2
            , create_enemy Warrior 0.2 2
            , create_enemy Warrior 0.3 2

            , create_enemy Warrior -0.3 5
            , create_enemy Warrior -0.2 5
            , create_enemy Warrior -0.1 5
            , create_enemy Veteran 0 5
            , create_enemy Warrior 0.1 5
            , create_enemy Warrior 0.2 5
            , create_enemy Warrior 0.3 5

            , create_enemy HeavyTank -1 5.5
            , create_enemy HeavyTank 1 5.5

            , create_enemy Warrior -0.3 6
            , create_enemy Warrior -0.2 6
            , create_enemy Warrior -0.1 6
            , create_enemy Veteran 0 6
            , create_enemy Warrior 0.1 6
            , create_enemy Warrior 0.2 6
            , create_enemy Warrior 0.3 6

            , create_enemy Plane -1 8
            , create_enemy Plane 1 8

            , create_enemy Warrior -0.3 9
            , create_enemy Warrior -0.2 9
            , create_enemy Warrior -0.1 9
            , create_enemy Veteran 0 9
            , create_enemy Warrior 0.1 9
            , create_enemy Warrior 0.2 9
            , create_enemy Warrior 0.3 9

            , create_enemy Tank -1 9
            , create_enemy Tank -1 9
            , create_enemy Tank 1 10
            , create_enemy Tank 1 10

            , create_enemy Warrior -0.3 10
            , create_enemy Warrior -0.2 10
            , create_enemy Warrior -0.1 10
            , create_enemy Veteran 0 10
            , create_enemy Warrior 0.1 10
            , create_enemy Warrior 0.2 10
            , create_enemy Warrior 0.3 10

            , create_enemy Warrior -0.3 13
            , create_enemy Warrior -0.2 13
            , create_enemy Warrior -0.1 13
            , create_enemy Veteran 0 13
            , create_enemy Warrior 0.1 13
            , create_enemy Warrior 0.2 13
            , create_enemy Warrior 0.3 13

            , create_enemy HeavyTank -1 13
            , create_enemy HeavyTank -1 13
            , create_enemy HeavyTank 1 14
            , create_enemy HeavyTank 1 14

            , create_enemy Warrior -0.3 14
            , create_enemy Warrior -0.2 14
            , create_enemy Warrior -0.1 14
            , create_enemy Veteran 0 14
            , create_enemy Warrior 0.1 14
            , create_enemy Warrior 0.2 14
            , create_enemy Warrior 0.3 14

            , create_enemy HeavyPlane -1 18
            , create_enemy HeavyPlane 1 18
        ]  
        , create_wave 10 50
        [
            create_enemy Warrior -1 0
            , create_enemy Soldier -0.3 0
            , create_enemy Warrior -0.2 0
            , create_enemy Warrior 0.2 0
            , create_enemy Soldier 0.3 0
            , create_enemy Warrior 1 0

            , create_enemy Tank -0.1 1
            , create_enemy Tank 0.1 1
            , create_enemy Tank -0.1 1.5
            , create_enemy Tank 0.1 1.5

            , create_enemy Soldier -1 2
            , create_enemy Warrior -0.3 2
            , create_enemy Soldier -0.2 2
            , create_enemy Soldier 0.2 2
            , create_enemy Warrior 0.3 2
            , create_enemy Soldier 1 2

            , create_enemy Warrior -1 4
            , create_enemy Soldier -0.3 4
            , create_enemy Warrior -0.2 4
            , create_enemy Warrior 0.2 4
            , create_enemy Soldier 0.3 4
            , create_enemy Warrior 1 4

            , create_enemy HeavyTank -0.1 5
            , create_enemy HeavyTank 0.1 5
            , create_enemy HeavyTank -0.1 5.5
            , create_enemy HeavyTank 0.1 5.5

            , create_enemy Soldier -1 6
            , create_enemy Warrior -0.3 6
            , create_enemy Soldier -0.2 6
            , create_enemy Soldier 0.2 6
            , create_enemy Warrior 0.3 6
            , create_enemy Soldier 1 6

            , create_enemy Warrior -1 8
            , create_enemy Soldier -0.3 8
            , create_enemy Warrior -0.2 8
            , create_enemy Warrior 0.2 8
            , create_enemy Soldier 0.3 8
            , create_enemy Warrior 1 8

            , create_enemy Tank -0.1 9
            , create_enemy Tank 0.1 9
            , create_enemy Tank -0.1 9.5
            , create_enemy Tank 0.1 9.5

            , create_enemy Soldier -1 10
            , create_enemy Warrior -0.3 10
            , create_enemy Soldier -0.2 10
            , create_enemy Soldier 0.2 10
            , create_enemy Warrior 0.3 10
            , create_enemy Soldier 1 10

            , create_enemy Warrior -1 12
            , create_enemy Soldier -0.3 12
            , create_enemy Warrior -0.2 12
            , create_enemy Warrior 0.2 12
            , create_enemy Soldier 0.3 12
            , create_enemy Warrior 1 12

            , create_enemy HeavyTank -0.1 13
            , create_enemy HeavyTank 0.1 13
            , create_enemy HeavyTank -0.1 13.5
            , create_enemy HeavyTank 0.1 13.5

            , create_enemy Soldier -1 14
            , create_enemy Warrior -0.3 14
            , create_enemy Soldier -0.2 14
            , create_enemy Soldier 0.2 14
            , create_enemy Warrior 0.3 14
            , create_enemy Soldier 1 14

            , create_enemy Warrior -1 16
            , create_enemy Soldier -0.3 16
            , create_enemy Warrior -0.2 16
            , create_enemy Warrior 0.2 16
            , create_enemy Soldier 0.3 16
            , create_enemy Warrior 1 16

            , create_enemy Tank -0.1 17
            , create_enemy Tank 0.1 17
            , create_enemy Tank -0.1 17.5
            , create_enemy Tank 0.1 17.5

            , create_enemy Soldier -1 18
            , create_enemy Warrior -0.3 18
            , create_enemy Soldier -0.2 18
            , create_enemy Soldier 0.2 18
            , create_enemy Warrior 0.3 18
            , create_enemy Soldier 1 18

            , create_enemy Warrior -1 20
            , create_enemy Soldier -0.3 20
            , create_enemy Warrior -0.2 20
            , create_enemy Warrior 0.2 20
            , create_enemy Soldier 0.3 20
            , create_enemy Warrior 1 20

            , create_enemy Plane 0 20
        ]  
        , create_wave 11 150
        [
            create_enemy Plane -1 0
            , create_enemy HeavyPlane 0 0
            , create_enemy Plane 1 0

            , create_enemy Plane -0.2 4
            , create_enemy Plane 0.2 4

            , create_enemy HeavyPlane -1 8
            , create_enemy Plane 0 8
            , create_enemy HeavyPlane 1 8

            , create_enemy Plane -0.2 12
            , create_enemy Plane 0.2 12

            , create_enemy Plane -1 18
            , create_enemy Plane 0 18
            , create_enemy Plane 1 18

            , create_enemy HeavyPlane -1 20
            , create_enemy HeavyPlane 0 20
            , create_enemy HeavyPlane 1 20
        ]  
        , create_wave 12 0
        [
            create_enemy Plane -1 0
            , create_enemy Plane 0 0
            , create_enemy Plane 1 0

            , create_enemy Scout -1 0
            , create_enemy Soldier 0 0
            , create_enemy Warrior 1 0

            , create_enemy Scout -1 0.5
            , create_enemy Soldier 0 0.5
            , create_enemy Warrior 1 0.5

            , create_enemy Scout -1 1
            , create_enemy Soldier 0 1
            , create_enemy Warrior 1 1

            , create_enemy Scout -1 1.5
            , create_enemy Soldier 0 1.5
            , create_enemy Warrior 1 1.5

            , create_enemy Scout -1 2
            , create_enemy Soldier 0 2
            , create_enemy Warrior 1 2

            , create_enemy HeavyTank -0.2 2
            , create_enemy HeavyTank 0.2 2

            , create_enemy Scout -1 2.5
            , create_enemy Soldier 0 2.5
            , create_enemy Warrior 1 2.5

            , create_enemy Scout -1 3
            , create_enemy Soldier 0 3
            , create_enemy Warrior 1 3

            , create_enemy Scout -1 3.5
            , create_enemy Soldier 0 3.5
            , create_enemy Warrior 1 3.5

            , create_enemy Scout -1 4
            , create_enemy Soldier 0 4
            , create_enemy Warrior 1 4

            , create_enemy Plane -1 4
            , create_enemy Plane 0 4
            , create_enemy Plane 1 4

            , create_enemy Scout -1 4.5
            , create_enemy Soldier 0 4.5
            , create_enemy Warrior 1 4.5

            , create_enemy Scout -1 5
            , create_enemy Soldier 0 5
            , create_enemy Warrior 1 5

            , create_enemy Scout -1 5.5
            , create_enemy Soldier 0 5.5
            , create_enemy Warrior 1 5.5

            , create_enemy Scout -1 6
            , create_enemy Soldier 0 6
            , create_enemy Warrior 1 6

            , create_enemy HeavyTank -0.2 6
            , create_enemy HeavyTank 0.2 6

            , create_enemy Plane -1 8
            , create_enemy HeavyPlane -0.2 8
            , create_enemy Plane 0 8
            , create_enemy HeavyPlane 0.2 8
            , create_enemy Plane 1 8

            , create_enemy Veteran -1 8
            , create_enemy Veteran 0 8
            , create_enemy Veteran 1 8

            , create_enemy Veteran -1 8.5
            , create_enemy Veteran 0 8.5
            , create_enemy Veteran 1 8.5

            , create_enemy Veteran -1 9
            , create_enemy Veteran 0 9
            , create_enemy Veteran 1 9

            , create_enemy Veteran -1 9.5
            , create_enemy Veteran 0 9.5
            , create_enemy Veteran 1 9.5

            , create_enemy Veteran -1 10
            , create_enemy Veteran 0 10
            , create_enemy Veteran 1 10

            , create_enemy Tank 0.2 10
            , create_enemy Tank -0.2 10

            , create_enemy Veteran -1 10.5
            , create_enemy Veteran 0 10.5
            , create_enemy Veteran 1 10.5

            , create_enemy Veteran -1 11
            , create_enemy Veteran 0 11
            , create_enemy Veteran 1 11

            , create_enemy Tank 0.2 11
            , create_enemy Tank -0.2 11

            , create_enemy Veteran -1 11.5
            , create_enemy Veteran 0 11.5
            , create_enemy Veteran 1 11.5

            , create_enemy Veteran -1 12
            , create_enemy Veteran 0 12
            , create_enemy Veteran 1 12

            , create_enemy Tank 0.2 12
            , create_enemy Tank -0.2 12

            , create_enemy Veteran -1 12.5
            , create_enemy Veteran 0 12.5
            , create_enemy Veteran 1 12.5

            , create_enemy Veteran -1 13
            , create_enemy Veteran 0 13
            , create_enemy Veteran 1 13

            , create_enemy Veteran -1 13.5
            , create_enemy Veteran 0 13.5
            , create_enemy Veteran 1 13.5

            , create_enemy Veteran -1 14
            , create_enemy Veteran 0 14
            , create_enemy Veteran 1 14

            , create_enemy Tank 0.2 14
            , create_enemy Tank -0.2 14

            , create_enemy Scout 1 16
            , create_enemy Veteran -1 16
            , create_enemy Tank 0 16
            , create_enemy HeavyTank 0 16.5
            , create_enemy Soldier 1 16.5
            , create_enemy Warrior -1 16.5

            , create_enemy Plane 1 17
            , create_enemy HeavyPlane -1 17

            , create_enemy Scout 1 18
            , create_enemy Veteran -1 18
            , create_enemy Tank 0 18
            , create_enemy HeavyTank 0 18.5
            , create_enemy Soldier 1 18.5
            , create_enemy Warrior -1 18.5

            , create_enemy Scout 1 20
            , create_enemy Veteran -1 20
            , create_enemy Tank 0 20
            , create_enemy HeavyTank 0 20.5
            , create_enemy Soldier 1 20.5
            , create_enemy Warrior -1 20.5

            , create_enemy Plane 1 21
            , create_enemy HeavyPlane -1 21

            , create_enemy Scout 1 22
            , create_enemy Veteran -1 22
            , create_enemy Tank 0 22
            , create_enemy HeavyTank 0 22.5
            , create_enemy Soldier 1 22.5
            , create_enemy Warrior -1 22.5

            , create_enemy Scout 1 24
            , create_enemy Veteran -1 24
            , create_enemy Tank 0 24
            , create_enemy HeavyTank 0 24.5
            , create_enemy Soldier 1 24.5
            , create_enemy Warrior -1 24.5

            , create_enemy Plane -1 38
            , create_enemy Plane -0.2 38
            , create_enemy HeavyPlane 0 38
            , create_enemy Plane 0.2 38
            , create_enemy Plane 1 38

            , create_enemy HeavyPlane -1 38.5
            , create_enemy HeavyPlane -0.2 38.5
            , create_enemy Plane 0 38.5
            , create_enemy HeavyPlane 0.2 38.5
            , create_enemy HeavyPlane 1 38.5

            , create_enemy Plane -1 39
            , create_enemy HeavyPlane -0.2 39
            , create_enemy Plane 0 39
            , create_enemy HeavyPlane 0.2 39
            , create_enemy Plane 1 39

            , create_enemy Scout 0 40
        ]  
    ]

airport : Maybe Point 
airport = Just (Point (2.5,0) Up)

path : List Point
path = 
    [
        Point (1,0) Up
        , Point (1,4) Up
        , Point (2,4) Right
        , Point (2,9) Up
        , Point (1,9) Left
        , Point (1,13) Up
        , Point (11,13) Right
        , Point (11,5) Down
        , Point (9,5) Left
        , Point (9,11) Up
        , Point (7,11) Left
        , Point (7,1) Down
        , Point (14,1) Right
    ]

tileList : List ((Float, Float), Tile)
tileList = 
    [
        create_tile (0,0) Road 3
        , create_tile (1,0) Road 5
        , create_tile (2,0) Road 15
        , create_tile (3,0) (Lot Nothing) 0
        , create_tile (4,0) (Lot (create_obstacle "bush" 0.9 40 (1, 1))) 0
        , create_tile (5,0) (Lot (create_obstacle "rock-3" 0.65 190 (1, 0))) 0
        , create_tile (6,0) Road 12
        , create_tile (7,0) Road 2
        , create_tile (8,0) Road 2
        , create_tile (9,0) Road 2
        , create_tile (10,0) Road 2
        , create_tile (11,0) Road 2
        , create_tile (12,0) Road 2
        , create_tile (13,0) Road 2
        , create_tile (0,1) Road 3
        , create_tile (1,1) Road 5
        , create_tile (2,1) (Lot Nothing) 0
        , create_tile (3,1) (Lot Nothing) 0
        , create_tile (4,1) (Lot Nothing) 0
        , create_tile (5,1) (Lot (create_obstacle "tree-round" 0.7 0 (-1, -1))) 0
        , create_tile (6,1) Road 3
        , create_tile (7,1) Road 6
        , create_tile (8,1) Road 4
        , create_tile (9,1) Road 4
        , create_tile (10,1) Road 4
        , create_tile (11,1) Road 4
        , create_tile (12,1) Road 4
        , create_tile (13,1) Road 4
        , create_tile (0,2) Road 3
        , create_tile (1,2) Road 5
        , create_tile (2,2) (Lot (create_obstacle "tree" 0.75 60 (0, 1))) 0
        , create_tile (3,2) (Lot (create_obstacle "bush-many" 0.85 210 (1, -1))) 0
        , create_tile (4,2) (Lot Nothing) 0
        , create_tile (5,2) (Lot Nothing) 0
        , create_tile (6,2) Road 3
        , create_tile (7,2) Road 5
        , create_tile (8,2) (Lot (create_obstacle "bush" 0.6 40 (0, -1))) 0
        , create_tile (9,2) (Lot Nothing) 0
        , create_tile (10,2) (Lot (create_obstacle "rock-1" 0.5 160 (-1, 1))) 0
        , create_tile (11,2) (Lot (create_obstacle "tree" 0.7 150 (0, 0))) 0
        , create_tile (12,2) (Lot Nothing) 0
        , create_tile (13,2) (Lot (create_obstacle "bush-many" 0.5 45 (0, -1))) 0
        , create_tile (0,3) Road 3
        , create_tile (1,3) Road 9
        , create_tile (2,3) Road 13
        , create_tile (3,3) (Lot Nothing) 0
        , create_tile (4,3) (Lot (create_obstacle "rock-4" 0.8 70 (1, -1))) 0
        , create_tile (5,3) (Lot Nothing) 0
        , create_tile (6,3) Road 3
        , create_tile (7,3) Road 5
        , create_tile (8,3) (Lot (create_obstacle "tree-star" 0.65 30 (-1, -1))) 0
        , create_tile (9,3) (Lot (create_obstacle "rock-6" 0.85 290 (0, 1))) 0
        , create_tile (10,3) (Lot (create_obstacle "bush-many" 0.9 120 (1, 1))) 0
        , create_tile (11,3) (Lot Nothing) 0
        , create_tile (12,3) (Lot (create_obstacle "tree-round" 0.6 90 (1, -1))) 0
        , create_tile (13,3) (Lot Nothing) 0
        , create_tile (0,4) Road 10
        , create_tile (1,4) Road 7
        , create_tile (2,4) Road 5
        , create_tile (3,4) (Lot Nothing) 0
        , create_tile (4,4) (Lot Nothing) 0
        , create_tile (5,4) (Lot Nothing) 0
        , create_tile (6,4) Road 3
        , create_tile (7,4) Road 5
        , create_tile (8,4) Road 12
        , create_tile (9,4) Road 2
        , create_tile (10,4) Road 2
        , create_tile (11,4) Road 13
        , create_tile (12,4) (Lot (create_obstacle "tree" 0.55 40 (0, -1))) 0
        , create_tile (13,4) (Lot (create_obstacle "bush" 0.85 200 (-1, 1))) 0
        , create_tile (0,5) (Lot (create_obstacle "rock-5" 0.75 140 (1, 1))) 0
        , create_tile (1,5) Road 3
        , create_tile (2,5) Road 5
        , create_tile (3,5) (Lot Nothing) 0
        , create_tile (4,5) (Lot Nothing) 0
        , create_tile (5,5) (Lot (create_obstacle "bush-many" 0.9 280 (-1, -1))) 0
        , create_tile (6,5) Road 3
        , create_tile (7,5) Road 5
        , create_tile (8,5) Road 3
        , create_tile (9,5) Road 6
        , create_tile (10,5) Road 7
        , create_tile (11,5) Road 5
        , create_tile (12,5) (Lot Nothing) 0
        , create_tile (13,5) (Lot (create_obstacle "tree-round" 0.75 0 (-1, 0))) 0
        , create_tile (0,6) (Lot (create_obstacle "tree-star" 0.8 30 (0, 0))) 0
        , create_tile (1,6) Road 3
        , create_tile (2,6) Road 5
        , create_tile (3,6) (Lot Nothing) 0
        , create_tile (4,6) (Lot (create_obstacle "tree-round" 0.9 0 (1, 1))) 0
        , create_tile (5,6) (Lot (create_obstacle "tree" 0.55 60 (-0.1, -1))) 0
        , create_tile (6,6) Road 3
        , create_tile (7,6) Road 5
        , create_tile (8,6) Road 3
        , create_tile (9,6) Road 5
        , create_tile (10,6) Road 3
        , create_tile (11,6) Road 5
        , create_tile (12,6) (Lot Nothing) 0
        , create_tile (13,6) (Lot (create_obstacle "tree-star" 0.8 45 (1, -1))) 0
        , create_tile (0,7) (Lot Nothing) 0
        , create_tile (1,7) Road 3
        , create_tile (2,7) Road 5
        , create_tile (3,7) (Lot Nothing) 0
        , create_tile (4,7) (Lot Nothing) 0
        , create_tile (5,7) (Lot (create_obstacle "bush" 0.65 170 (0, 1))) 0
        , create_tile (6,7) Road 3
        , create_tile (7,7) Road 5
        , create_tile (8,7) Road 3
        , create_tile (9,7) Road 5
        , create_tile (10,7) Road 3
        , create_tile (11,7) Road 5
        , create_tile (12,7) (Lot (create_obstacle "bush-many" 0.75 60 (1, -1))) 0
        , create_tile (13,7) (Lot (create_obstacle "rock-2" 0.6 0 (0, -1))) 0
        , create_tile (0,8) Road 12
        , create_tile (1,8) Road 8
        , create_tile (2,8) Road 5
        , create_tile (3,8) (Lot Nothing) 0
        , create_tile (4,8) (Lot Nothing) 0
        , create_tile (5,8) (Lot (create_obstacle "rock-3" 0.5 30 (-1, 0))) 0
        , create_tile (6,8) Road 3
        , create_tile (7,8) Road 5
        , create_tile (8,8) Road 3
        , create_tile (9,8) Road 5
        , create_tile (10,8) Road 3
        , create_tile (11,8) Road 5
        , create_tile (12,8) (Lot (create_obstacle "bush" 0.55 250 (-1, -1))) 0
        , create_tile (13,8) (Lot Nothing) 0
        , create_tile (0,9) Road 3
        , create_tile (1,9) Road 6
        , create_tile (2,9) Road 11
        , create_tile (3,9) (Lot Nothing) 0
        , create_tile (4,9) (Lot (create_obstacle "bush" 0.75 110 (1, -1))) 0
        , create_tile (5,9) (Lot (create_obstacle "tree" 0.9 45 (-1, -1))) 0
        , create_tile (6,9) Road 3
        , create_tile (7,9) Road 5
        , create_tile (8,9) Road 3
        , create_tile (9,9) Road 5
        , create_tile (10,9) Road 3
        , create_tile (11,9) Road 5
        , create_tile (12,9) (Lot Nothing) 0
        , create_tile (13,9) (Lot Nothing) 0
        , create_tile (0,10) Road 3
        , create_tile (1,10) Road 5
        , create_tile (2,10) (Lot (create_obstacle "tree" 0.5 250 (-1, 1))) 0
        , create_tile (3,10) (Lot (create_obstacle "rock-2" 0.65 40 (-1, 0))) 0
        , create_tile (4,10) (Lot (create_obstacle "tree-round" 0.7 0 (-1, -1))) 0
        , create_tile (5,10) (Lot Nothing) 0
        , create_tile (6,10) Road 3
        , create_tile (7,10) Road 9
        , create_tile (8,10) Road 8
        , create_tile (9,10) Road 5
        , create_tile (10,10) Road 3
        , create_tile (11,10) Road 5
        , create_tile (12,10) (Lot Nothing) 0
        , create_tile (13,10) (Lot (create_obstacle "tree" 0.9 160 (-1, 1))) 0
        , create_tile (0,11) Road 3
        , create_tile (1,11) Road 5
        , create_tile (2,11) (Lot (create_obstacle "tree-round" 0.85 230 (-1, 1))) 0
        , create_tile (3,11) (Lot (create_obstacle "tree-star" 0.7 150 (0, -1))) 0
        , create_tile (4,11) (Lot Nothing) 0
        , create_tile (5,11) (Lot (create_obstacle "bush-many" 0.55 80 (1, -1))) 0
        , create_tile (6,11) Road 10
        , create_tile (7,11) Road 4
        , create_tile (8,11) Road 4
        , create_tile (9,11) Road 11
        , create_tile (10,11) Road 3
        , create_tile (11,11) Road 5
        , create_tile (12,11) (Lot (create_obstacle "bush-many" 0.6 50 (-1, 1))) 0
        , create_tile (13,11) (Lot Nothing) 0
        , create_tile (0,12) Road 3
        , create_tile (1,12) Road 9
        , create_tile (2,12) Road 2
        , create_tile (3,12) Road 2
        , create_tile (4,12) Road 2
        , create_tile (5,12) Road 2
        , create_tile (6,12) Road 2
        , create_tile (7,12) Road 2
        , create_tile (8,12) Road 2
        , create_tile (9,12) Road 2
        , create_tile (10,12) Road 8
        , create_tile (11,12) Road 5
        , create_tile (12,12) (Lot (create_obstacle "tree-star" 0.8 270 (1, -1))) 0
        , create_tile (13,12) (Lot Nothing) 0
        , create_tile (0,13) Road 10
        , create_tile (1,13) Road 4
        , create_tile (2,13) Road 4
        , create_tile (3,13) Road 4
        , create_tile (4,13) Road 4
        , create_tile (5,13) Road 4
        , create_tile (6,13) Road 4
        , create_tile (7,13) Road 4
        , create_tile (8,13) Road 4
        , create_tile (9,13) Road 4
        , create_tile (10,13) Road 4
        , create_tile (11,13) Road 11
        , create_tile (12,13) (Lot (create_obstacle "rock-3" 0.7 90 (1, 0))) 0
        , create_tile (13,13) (Lot (create_obstacle "tree-round" 0.5 180 (-1, -1))) 0
    ]
